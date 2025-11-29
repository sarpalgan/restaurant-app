import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu.freezed.dart';
part 'menu.g.dart';

@freezed
class MenuCategory with _$MenuCategory {
  const factory MenuCategory({
    required String id,
    required String restaurantId,
    String? imageUrl,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Translations loaded separately
    @Default({}) Map<String, CategoryTranslation> translations,
  }) = _MenuCategory;

  /// Parse from Supabase snake_case response
  factory MenuCategory.fromSupabase(Map<String, dynamic> json) {
    // Parse translations from the nested array
    final translations = <String, CategoryTranslation>{};
    final translationsList = json['menu_category_translations'] as List?;
    if (translationsList != null) {
      for (final t in translationsList) {
        final langCode = t['language_code'] as String? ?? 'en';
        translations[langCode] = CategoryTranslation(
          id: t['id'] as String? ?? '',
          categoryId: t['category_id'] as String? ?? '',
          languageCode: langCode,
          name: t['name'] as String? ?? '',
          description: t['description'] as String?,
        );
      }
    }

    return MenuCategory(
      id: json['id'] as String? ?? '',
      restaurantId: json['restaurant_id'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      sortOrder: (json['display_order'] ?? json['sort_order'] ?? 0) as int,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
      translations: translations,
    );
  }

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);
}

@freezed
class CategoryTranslation with _$CategoryTranslation {
  const factory CategoryTranslation({
    required String id,
    required String categoryId,
    required String languageCode,
    required String name,
    String? description,
  }) = _CategoryTranslation;

  factory CategoryTranslation.fromJson(Map<String, dynamic> json) =>
      _$CategoryTranslationFromJson(json);
}

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String categoryId,
    required String restaurantId,
    required double price,
    String? imageUrl,
    String? videoUrl,
    String? videoThumbnailUrl,
    @Default('none') String videoStatus,
    @Default([]) List<String> allergens,
    @Default([]) List<String> dietaryTags,
    int? calories,
    int? prepTimeMinutes,
    @Default(true) bool isAvailable,
    @Default(false) bool isFeatured,
    @Default(0) int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Translations loaded separately
    @Default({}) Map<String, ItemTranslation> translations,
  }) = _MenuItem;

  /// Parse from Supabase snake_case response
  factory MenuItem.fromSupabase(Map<String, dynamic> json) {
    // Parse translations from the nested array
    final translations = <String, ItemTranslation>{};
    final translationsList = json['menu_item_translations'] as List?;
    if (translationsList != null) {
      for (final t in translationsList) {
        final langCode = t['language_code'] as String? ?? 'en';
        translations[langCode] = ItemTranslation(
          id: t['id'] as String? ?? '',
          itemId: t['item_id'] as String? ?? '',
          languageCode: langCode,
          name: t['name'] as String? ?? '',
          description: t['description'] as String?,
        );
      }
    }

    return MenuItem(
      id: json['id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      restaurantId: json['restaurant_id'] as String? ?? 
                    (json['menu_categories'] as Map?)?['restaurant_id'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      videoThumbnailUrl: json['video_thumbnail_url'] as String?,
      videoStatus: json['video_status'] as String? ?? 'none',
      allergens: (json['allergens'] as List?)?.cast<String>() ?? [],
      dietaryTags: (json['dietary_tags'] as List?)?.cast<String>() ?? [],
      calories: json['calories'] as int?,
      prepTimeMinutes: json['prep_time_minutes'] as int? ?? json['preparation_time'] as int?,
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      sortOrder: (json['display_order'] ?? json['sort_order'] ?? 0) as int,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
      translations: translations,
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}

@freezed
class ItemTranslation with _$ItemTranslation {
  const factory ItemTranslation({
    required String id,
    required String itemId,
    required String languageCode,
    required String name,
    String? description,
  }) = _ItemTranslation;

  factory ItemTranslation.fromJson(Map<String, dynamic> json) =>
      _$ItemTranslationFromJson(json);
}

// Extension to get translation for current language
extension MenuCategoryExtension on MenuCategory {
  String getName(String languageCode) {
    return translations[languageCode]?.name ?? 
           translations['en']?.name ?? 
           'Unnamed Category';
  }
  
  String? getDescription(String languageCode) {
    return translations[languageCode]?.description ?? 
           translations['en']?.description;
  }
}

extension MenuItemExtension on MenuItem {
  String getName(String languageCode) {
    return translations[languageCode]?.name ?? 
           translations['en']?.name ?? 
           'Unnamed Item';
  }
  
  String? getDescription(String languageCode) {
    return translations[languageCode]?.description ?? 
           translations['en']?.description;
  }
  
  bool get hasVideo => videoStatus == 'ready' && videoUrl != null;
  bool get isVideoProcessing => videoStatus == 'queued' || videoStatus == 'processing';
}

// Dietary tag constants
class DietaryTags {
  static const String vegetarian = 'vegetarian';
  static const String vegan = 'vegan';
  static const String glutenFree = 'gluten-free';
  static const String halal = 'halal';
  static const String kosher = 'kosher';
  static const String spicy = 'spicy';
  static const String nutFree = 'nut-free';
  static const String dairyFree = 'dairy-free';
  
  static const List<String> all = [
    vegetarian, vegan, glutenFree, halal, kosher, spicy, nutFree, dairyFree
  ];
}

// Common allergens
class Allergens {
  static const String gluten = 'gluten';
  static const String dairy = 'dairy';
  static const String eggs = 'eggs';
  static const String fish = 'fish';
  static const String shellfish = 'shellfish';
  static const String treeNuts = 'tree-nuts';
  static const String peanuts = 'peanuts';
  static const String soy = 'soy';
  static const String sesame = 'sesame';
  
  static const List<String> all = [
    gluten, dairy, eggs, fish, shellfish, treeNuts, peanuts, soy, sesame
  ];
}
