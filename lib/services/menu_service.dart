import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../core/models/menu.dart';

// Menu categories provider
final menuCategoriesProvider = FutureProvider.family<List<MenuCategory>, String>((ref, restaurantId) async {
  final response = await supabase
      .from('menu_categories')
      .select('*, menu_category_translations(*)')
      .eq('restaurant_id', restaurantId)
      .order('sort_order');

  return (response as List).map((json) => MenuCategory.fromSupabase(json)).toList();
});

// Menu items provider
final menuItemsProvider = FutureProvider.family<List<MenuItem>, String>((ref, categoryId) async {
  final response = await supabase
      .from('menu_items')
      .select('*, menu_item_translations(*), menu_item_variants(*, menu_item_variant_translations(*))')
      .eq('category_id', categoryId)
      .order('sort_order');

  return (response as List).map((json) => MenuItem.fromSupabase(json)).toList();
});

// All menu items for a restaurant
final allMenuItemsProvider = FutureProvider.family<List<MenuItem>, String>((ref, restaurantId) async {
  final response = await supabase
      .from('menu_items')
      .select('''
        *,
        menu_item_translations(*),
        menu_item_variants(*, menu_item_variant_translations(*)),
        menu_categories!inner(restaurant_id)
      ''')
      .eq('menu_categories.restaurant_id', restaurantId)
      .order('sort_order');

  return (response as List).map((json) => MenuItem.fromSupabase(json)).toList();
});

// Menu service for CRUD operations
class MenuService {
  // ============================================================
  // CATEGORIES
  // ============================================================

  Future<MenuCategory> createCategory({
    required String restaurantId,
    String? name,
    String? description,
    String? imageUrl,
    int? sortOrder,
  }) async {
    // Create the category (name/description go in translations table)
    final response = await supabase.from('menu_categories').insert({
      'restaurant_id': restaurantId,
      'image_url': imageUrl,
      'sort_order': sortOrder ?? 0,
    }).select().single();

    final category = MenuCategory.fromSupabase(response);
    
    // Add English translation if name provided
    if (name != null) {
      await addCategoryTranslation(
        categoryId: category.id,
        languageCode: 'en',
        name: name,
        description: description,
      );
    }

    return category;
  }

  Future<MenuCategory> updateCategory({
    required String id,
    String? name,
    String? description,
    String? imageUrl,
    int? sortOrder,
    bool? isActive,
  }) async {
    final updates = <String, dynamic>{};
    // Note: name/description are in translations table, not here
    if (imageUrl != null) updates['image_url'] = imageUrl;
    if (sortOrder != null) updates['sort_order'] = sortOrder;
    if (isActive != null) updates['is_active'] = isActive;

    final response = await supabase
        .from('menu_categories')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    // Update English translation if name/description provided
    if (name != null) {
      await addCategoryTranslation(
        categoryId: id,
        languageCode: 'en',
        name: name,
        description: description,
      );
    }

    return MenuCategory.fromSupabase(response);
  }

  Future<void> deleteCategory(String id) async {
    await supabase.from('menu_categories').delete().eq('id', id);
  }

  Future<void> addCategoryTranslation({
    required String categoryId,
    required String languageCode,
    required String name,
    String? description,
  }) async {
    await supabase.from('menu_category_translations').upsert({
      'category_id': categoryId,
      'language_code': languageCode,
      'name': name,
      'description': description,
    }, onConflict: 'category_id,language_code');
  }

  // ============================================================
  // MENU ITEMS
  // ============================================================

  Future<MenuItem> createItem({
    required String categoryId,
    required String restaurantId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    String? videoUrl,
    int? sortOrder,
    List<String>? allergens,
    Map<String, dynamic>? nutritionalInfo,
    int? preparationTime,
  }) async {
    // Create the item (name/description go in translations table)
    final response = await supabase.from('menu_items').insert({
      'category_id': categoryId,
      'restaurant_id': restaurantId,
      'price': price,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'sort_order': sortOrder ?? 0,
      'allergens': allergens ?? [],
      'prep_time_minutes': preparationTime,
    }).select().single();

    final item = MenuItem.fromSupabase(response);
    
    // Add English translation
    await addItemTranslation(
      itemId: item.id,
      languageCode: 'en',
      name: name,
      description: description,
    );

    return item;
  }

  Future<MenuItem> updateItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool clearImageUrl = false,
    String? originalImageUrl,
    bool clearOriginalImageUrl = false,
    String? videoUrl,
    int? sortOrder,
    bool? isAvailable,
    List<String>? allergens,
    Map<String, dynamic>? nutritionalInfo,
    int? preparationTime,
    String languageCode = 'en',
    List<String>? aiGeneratedImages,
    int? selectedAiImageIndex,
  }) async {
    final updates = <String, dynamic>{};
    // Note: name/description are in translations table, not here
    if (price != null) updates['price'] = price;
    if (imageUrl != null) {
      updates['image_url'] = imageUrl;
    } else if (clearImageUrl) {
      updates['image_url'] = null;
    }
    if (originalImageUrl != null) {
      updates['original_image_url'] = originalImageUrl;
    } else if (clearOriginalImageUrl) {
      updates['original_image_url'] = null;
    }
    if (videoUrl != null) updates['video_url'] = videoUrl;
    if (sortOrder != null) updates['sort_order'] = sortOrder;
    if (isAvailable != null) updates['is_available'] = isAvailable;
    if (allergens != null) updates['allergens'] = allergens;
    if (preparationTime != null) updates['prep_time_minutes'] = preparationTime;
    if (aiGeneratedImages != null) updates['ai_generated_images'] = aiGeneratedImages;
    if (selectedAiImageIndex != null) updates['selected_ai_image_index'] = selectedAiImageIndex;

    Map<String, dynamic> response;
    
    // Only call update if there are fields to update
    if (updates.isNotEmpty) {
      response = await supabase
          .from('menu_items')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
    } else {
      // Just fetch the current item
      response = await supabase
          .from('menu_items')
          .select()
          .eq('id', id)
          .single();
    }

    // Update translation for the specified language if name/description provided
    if (name != null) {
      await addItemTranslation(
        itemId: id,
        languageCode: languageCode,
        name: name,
        description: description,
      );
    }

    return MenuItem.fromSupabase(response);
  }

  Future<void> deleteItem(String id) async {
    await supabase.from('menu_items').delete().eq('id', id);
  }

  Future<void> addItemTranslation({
    required String itemId,
    required String languageCode,
    required String name,
    String? description,
  }) async {
    await supabase.from('menu_item_translations').upsert({
      'item_id': itemId,
      'language_code': languageCode,
      'name': name,
      'description': description,
    }, onConflict: 'item_id,language_code');
  }

  Future<void> toggleItemAvailability(String id, bool isAvailable) async {
    await supabase
        .from('menu_items')
        .update({'is_available': isAvailable})
        .eq('id', id);
  }

  // ============================================================
  // ITEM VARIANTS
  // ============================================================

  Future<String> createVariant({
    required String itemId,
    required String name,
    required double price,
    int? sortOrder,
  }) async {
    final response = await supabase.from('menu_item_variants').insert({
      'item_id': itemId,
      'name': name,
      'price': price,
      'sort_order': sortOrder ?? 0,
    }).select().single();

    final variantId = response['id'] as String;

    // Add English translation
    await addVariantTranslation(
      variantId: variantId,
      languageCode: 'en',
      name: name,
    );

    return variantId;
  }

  Future<void> addVariantTranslation({
    required String variantId,
    required String languageCode,
    required String name,
  }) async {
    await supabase.from('menu_item_variant_translations').upsert({
      'variant_id': variantId,
      'language_code': languageCode,
      'name': name,
    }, onConflict: 'variant_id,language_code');
  }

  Future<void> deleteVariant(String variantId) async {
    await supabase.from('menu_item_variants').delete().eq('id', variantId);
  }

  Future<void> updateVariant({
    required String variantId,
    required double price,
    required String name,
    required String languageCode,
  }) async {
    // Update variant price
    await supabase.from('menu_item_variants').update({
      'price': price,
    }).eq('id', variantId);

    // Update or insert translation for the given language
    await supabase.from('menu_item_variant_translations').upsert({
      'variant_id': variantId,
      'language_code': languageCode,
      'name': name,
    }, onConflict: 'variant_id,language_code');
  }

  Future<List<Map<String, dynamic>>> getVariantsForItem(String itemId) async {
    final response = await supabase
        .from('menu_item_variants')
        .select('*, menu_item_variant_translations(*)')
        .eq('item_id', itemId)
        .order('sort_order');
    return List<Map<String, dynamic>>.from(response);
  }

  // ============================================================
  // BATCH TRANSLATION HELPERS
  // ============================================================

  /// Save all translations for a menu item (used after AI translation)
  Future<void> saveItemTranslations({
    required String itemId,
    required Map<String, Map<String, String?>> translations,
  }) async {
    for (final entry in translations.entries) {
      final langCode = entry.key;
      final translation = entry.value;
      final name = translation['name'];
      if (name != null && name.isNotEmpty) {
        await addItemTranslation(
          itemId: itemId,
          languageCode: langCode,
          name: name,
          description: translation['description'],
        );
      }
    }
  }

  /// Save all translations for a variant (used after AI translation)
  Future<void> saveVariantTranslations({
    required String variantId,
    required Map<String, String> translations,
  }) async {
    for (final entry in translations.entries) {
      final langCode = entry.key;
      final name = entry.value;
      if (name.isNotEmpty) {
        await addVariantTranslation(
          variantId: variantId,
          languageCode: langCode,
          name: name,
        );
      }
    }
  }

  // ============================================================
  // AI-GENERATED IMAGES
  // ============================================================

  /// Add an AI-generated image to a menu item
  Future<void> addAiGeneratedImage({
    required String itemId,
    required String imageBase64,
  }) async {
    // First get current AI images
    final response = await supabase
        .from('menu_items')
        .select('ai_generated_images')
        .eq('id', itemId)
        .single();

    final currentImages = List<String>.from(response['ai_generated_images'] ?? []);
    currentImages.add(imageBase64);

    // Update the item with the new image added
    await supabase.from('menu_items').update({
      'ai_generated_images': currentImages,
      'selected_ai_image_index': currentImages.length - 1, // Select the new image by default
    }).eq('id', itemId);
  }

  /// Select which AI-generated image to display
  Future<void> selectAiGeneratedImage({
    required String itemId,
    required int index,
  }) async {
    await supabase.from('menu_items').update({
      'selected_ai_image_index': index,
    }).eq('id', itemId);
  }

  /// Remove an AI-generated image from a menu item
  Future<void> removeAiGeneratedImage({
    required String itemId,
    required int index,
  }) async {
    // First get current AI images and selected index
    final response = await supabase
        .from('menu_items')
        .select('ai_generated_images, selected_ai_image_index')
        .eq('id', itemId)
        .single();

    final currentImages = List<String>.from(response['ai_generated_images'] ?? []);
    final currentSelectedIndex = response['selected_ai_image_index'] as int? ?? 0;

    if (index >= 0 && index < currentImages.length) {
      currentImages.removeAt(index);

      // Adjust selected index if needed
      int newSelectedIndex = currentSelectedIndex;
      if (currentImages.isEmpty) {
        newSelectedIndex = 0;
      } else if (index <= currentSelectedIndex) {
        newSelectedIndex = (currentSelectedIndex - 1).clamp(0, currentImages.length - 1);
      }

      await supabase.from('menu_items').update({
        'ai_generated_images': currentImages,
        'selected_ai_image_index': newSelectedIndex,
      }).eq('id', itemId);
    }
  }

  /// Use an AI-generated image as the main image (copies to image_url)
  Future<void> useAiImageAsMain({
    required String itemId,
    required int aiImageIndex,
  }) async {
    // Get the AI image at the specified index
    final response = await supabase
        .from('menu_items')
        .select('ai_generated_images')
        .eq('id', itemId)
        .single();

    final aiImages = List<String>.from(response['ai_generated_images'] ?? []);
    
    if (aiImageIndex >= 0 && aiImageIndex < aiImages.length) {
      // Set the AI image as the main image_url
      await supabase.from('menu_items').update({
        'image_url': aiImages[aiImageIndex],
        'selected_ai_image_index': aiImageIndex,
      }).eq('id', itemId);
    }
  }
}

// Menu service provider
final menuServiceProvider = Provider<MenuService>((ref) {
  return MenuService();
});
