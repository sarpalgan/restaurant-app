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
      .select('*, menu_item_translations(*)')
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
    });
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
    String? videoUrl,
    int? sortOrder,
    bool? isAvailable,
    List<String>? allergens,
    Map<String, dynamic>? nutritionalInfo,
    int? preparationTime,
  }) async {
    final updates = <String, dynamic>{};
    // Note: name/description are in translations table, not here
    if (price != null) updates['price'] = price;
    if (imageUrl != null) updates['image_url'] = imageUrl;
    if (videoUrl != null) updates['video_url'] = videoUrl;
    if (sortOrder != null) updates['sort_order'] = sortOrder;
    if (isAvailable != null) updates['is_available'] = isAvailable;
    if (allergens != null) updates['allergens'] = allergens;
    if (preparationTime != null) updates['prep_time_minutes'] = preparationTime;

    final response = await supabase
        .from('menu_items')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    // Update English translation if name/description provided
    if (name != null) {
      await addItemTranslation(
        itemId: id,
        languageCode: 'en',
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
    });
  }

  Future<void> toggleItemAvailability(String id, bool isAvailable) async {
    await supabase
        .from('menu_items')
        .update({'is_available': isAvailable})
        .eq('id', id);
  }
}

// Menu service provider
final menuServiceProvider = Provider<MenuService>((ref) {
  return MenuService();
});
