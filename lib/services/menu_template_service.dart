import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../core/models/menu_template.dart';
import '../core/config/app_config.dart';
import 'ai_menu_service.dart';
import 'menu_service.dart';

/// Provider for menu templates of a restaurant
final menuTemplatesProvider = FutureProvider.family<List<MenuTemplate>, String>((ref, restaurantId) async {
  final response = await supabase
      .from('menu_templates')
      .select()
      .eq('restaurant_id', restaurantId)
      .order('created_at', ascending: false);

  return (response as List).map((json) => MenuTemplate.fromJson(json)).toList();
});

/// Provider for the active menu template
final activeMenuTemplateProvider = FutureProvider.family<MenuTemplate?, String>((ref, restaurantId) async {
  final response = await supabase
      .from('menu_templates')
      .select()
      .eq('restaurant_id', restaurantId)
      .eq('is_active', true)
      .limit(1)
      .maybeSingle();

  if (response == null) return null;
  return MenuTemplate.fromJson(response);
});

/// Service for managing menu templates
class MenuTemplateService {
  /// Save an AI analysis result as a template
  Future<MenuTemplate> saveTemplate({
    required String restaurantId,
    required String name,
    String? description,
    required MenuAnalysisResult analysisResult,
    required Set<int> selectedItems,
  }) async {
    // Convert analysis result to template data
    final templateData = _convertToTemplateData(analysisResult, selectedItems);

    final response = await supabase.from('menu_templates').insert({
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'detected_language': analysisResult.detectedLanguage,
      'detected_language_name': analysisResult.detectedLanguageName,
      'currency': analysisResult.currency,
      'template_data': templateData,
      'is_active': false,
    }).select().single();

    return MenuTemplate.fromJson(response);
  }

  /// Convert MenuAnalysisResult to storable template data
  Map<String, dynamic> _convertToTemplateData(
    MenuAnalysisResult result,
    Set<int> selectedItems,
  ) {
    // Filter to only selected items
    final selectedItemsList = <Map<String, dynamic>>[];
    for (int i = 0; i < result.items.length; i++) {
      if (selectedItems.contains(i)) {
        selectedItemsList.add(result.items[i].toJson());
      }
    }

    // Get categories that have selected items
    final usedCategories = selectedItemsList.map((i) => i['category']).toSet();
    final filteredCategories = result.categories
        .where((c) => usedCategories.contains(c.name))
        .map((c) => {
              'name': c.name,
              'original_language': c.originalLanguage,
              'translated_names': c.translatedNames,
            })
        .toList();

    return {
      'categories': filteredCategories,
      'items': selectedItemsList,
    };
  }

  /// Update a template
  Future<MenuTemplate> updateTemplate({
    required String id,
    String? name,
    String? description,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;

    final response = await supabase
        .from('menu_templates')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    return MenuTemplate.fromJson(response);
  }

  /// Delete a template
  Future<void> deleteTemplate(String id) async {
    await supabase.from('menu_templates').delete().eq('id', id);
  }

  /// Activate a template - replaces the current menu with this template
  Future<void> activateTemplate({
    required String templateId,
    required String restaurantId,
    required MenuService menuService,
  }) async {
    // Get the template
    final response = await supabase
        .from('menu_templates')
        .select()
        .eq('id', templateId)
        .single();
    
    final template = MenuTemplate.fromJson(response);
    final templateData = template.templateData;

    // Delete all existing menu items and categories
    final existingCategories = await supabase
        .from('menu_categories')
        .select('id')
        .eq('restaurant_id', restaurantId);
    
    for (final cat in existingCategories) {
      await menuService.deleteCategory(cat['id']);
    }

    // Create categories from template
    final categories = templateData['categories'] as List? ?? [];
    final items = templateData['items'] as List? ?? [];
    final createdCategories = <String, String>{}; // original name -> new id

    int categoryOrder = 0;
    for (final catData in categories) {
      final catName = (catData['name'] as String?) ?? 'Uncategorized';
      
      // Safely handle translated names for categories
      final rawCatTranslatedNames = catData['translated_names'];
      final translatedNames = <String, String>{};
      if (rawCatTranslatedNames is Map) {
        for (final entry in rawCatTranslatedNames.entries) {
          if (entry.key is String && entry.value is String) {
            translatedNames[entry.key] = entry.value;
          }
        }
      }

      final createdCategory = await menuService.createCategory(
        restaurantId: restaurantId,
        name: translatedNames['en'] ?? catName,
        description: null,
        sortOrder: categoryOrder++,
      );
      createdCategories[catName] = createdCategory.id;

      // Add translations (skip 'en' as it's already added by createCategory)
      for (final entry in translatedNames.entries) {
        if (entry.key == 'en') continue; // Already added
        await menuService.addCategoryTranslation(
          categoryId: createdCategory.id,
          languageCode: entry.key,
          name: entry.value,
        );
      }
    }

    // Create items from template
    final itemDisplayOrders = <String, int>{};
    for (final itemData in items) {
      final categoryName = itemData['category'] as String? ?? 'Uncategorized';
      final categoryId = createdCategories[categoryName];
      if (categoryId == null) continue;

      // Safely handle translated names - ensure all values are strings
      final rawTranslatedNames = itemData['translated_names'];
      final translatedNames = <String, String>{};
      if (rawTranslatedNames is Map) {
        for (final entry in rawTranslatedNames.entries) {
          if (entry.key is String && entry.value is String) {
            translatedNames[entry.key] = entry.value;
          }
        }
      }
      
      // Safely handle translated descriptions - ensure values are strings or null
      final rawTranslatedDescriptions = itemData['translated_descriptions'];
      final translatedDescriptions = <String, String?>{};
      if (rawTranslatedDescriptions is Map) {
        for (final entry in rawTranslatedDescriptions.entries) {
          if (entry.key is String) {
            translatedDescriptions[entry.key] = entry.value?.toString();
          }
        }
      }

      itemDisplayOrders[categoryId] = (itemDisplayOrders[categoryId] ?? 0) + 1;

      // Safely get item name and description with fallbacks
      final itemName = translatedNames['en'] ?? (itemData['name'] as String?) ?? 'Unnamed Item';
      final itemDescription = translatedDescriptions['en'] ?? (itemData['description'] as String?);
      final itemPrice = (itemData['price'] as num?)?.toDouble() ?? 0.0;

      final createdItem = await menuService.createItem(
        categoryId: categoryId,
        restaurantId: restaurantId,
        name: itemName,
        description: itemDescription,
        price: itemPrice,
        sortOrder: itemDisplayOrders[categoryId],
      );

      // Add translations (skip 'en' as it's already added by createItem)
      for (final lang in AppConfig.supportedLanguages) {
        if (lang == 'en') continue; // Already added
        final translatedName = translatedNames[lang];
        final translatedDesc = translatedDescriptions[lang];

        if (translatedName != null) {
          await menuService.addItemTranslation(
            itemId: createdItem.id,
            languageCode: lang,
            name: translatedName,
            description: translatedDesc,
          );
        }
      }
    }

    // Mark this template as active
    await supabase
        .from('menu_templates')
        .update({'is_active': true})
        .eq('id', templateId);
  }

  /// Duplicate a template
  Future<MenuTemplate> duplicateTemplate({
    required String templateId,
    required String newName,
  }) async {
    // Get the original template
    final response = await supabase
        .from('menu_templates')
        .select()
        .eq('id', templateId)
        .single();
    
    final original = MenuTemplate.fromJson(response);

    // Create a copy
    final copyResponse = await supabase.from('menu_templates').insert({
      'restaurant_id': original.restaurantId,
      'name': newName,
      'description': original.description,
      'detected_language': original.detectedLanguage,
      'detected_language_name': original.detectedLanguageName,
      'currency': original.currency,
      'template_data': original.templateData,
      'is_active': false,
    }).select().single();

    return MenuTemplate.fromJson(copyResponse);
  }
}

// Provider for MenuTemplateService
final menuTemplateServiceProvider = Provider<MenuTemplateService>((ref) {
  return MenuTemplateService();
});
