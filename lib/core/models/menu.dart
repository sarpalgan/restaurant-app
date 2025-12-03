import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu.freezed.dart';
part 'menu.g.dart';

/// Represents a variant/option for a menu item (e.g., Small, Medium, Large)
@freezed
class MenuItemVariant with _$MenuItemVariant {
  const factory MenuItemVariant({
    required String id,
    required String itemId,
    required double price,
    @Default(0) int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default({}) Map<String, VariantTranslation> translations,
  }) = _MenuItemVariant;

  factory MenuItemVariant.fromSupabase(Map<String, dynamic> json) {
    final translations = <String, VariantTranslation>{};
    final translationsList = json['menu_item_variant_translations'] as List?;
    if (translationsList != null) {
      for (final t in translationsList) {
        final langCode = t['language_code'] as String? ?? 'en';
        translations[langCode] = VariantTranslation(
          id: t['id'] as String? ?? '',
          variantId: t['variant_id'] as String? ?? '',
          languageCode: langCode,
          name: t['name'] as String? ?? '',
        );
      }
    }

    return MenuItemVariant(
      id: json['id'] as String? ?? '',
      itemId: json['item_id'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sortOrder: (json['sort_order'] ?? 0) as int,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
      translations: translations,
    );
  }

  factory MenuItemVariant.fromJson(Map<String, dynamic> json) =>
      _$MenuItemVariantFromJson(json);
}

@freezed
class VariantTranslation with _$VariantTranslation {
  const factory VariantTranslation({
    required String id,
    required String variantId,
    required String languageCode,
    required String name,
  }) = _VariantTranslation;

  factory VariantTranslation.fromJson(Map<String, dynamic> json) =>
      _$VariantTranslationFromJson(json);
}

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
    // Original uploaded image (stored separately from the display imageUrl)
    String? originalImageUrl,
    // AI-generated images stored separately from the original uploaded image
    @Default([]) List<String> aiGeneratedImages,
    // Index of the currently selected AI image (-1 means use original imageUrl)
    @Default(-1) int selectedAiImageIndex,
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
    // Variants (size/quantity options with different prices)
    @Default([]) List<MenuItemVariant> variants,
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

    // Parse variants from the nested array
    final variants = <MenuItemVariant>[];
    final variantsList = json['menu_item_variants'] as List?;
    if (variantsList != null) {
      for (final v in variantsList) {
        variants.add(MenuItemVariant.fromSupabase(v as Map<String, dynamic>));
      }
      // Sort by sortOrder
      variants.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }

    return MenuItem(
      id: json['id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      restaurantId: json['restaurant_id'] as String? ?? 
                    (json['menu_categories'] as Map?)?['restaurant_id'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      originalImageUrl: json['original_image_url'] as String?,
      aiGeneratedImages: (json['ai_generated_images'] as List?)?.cast<String>() ?? [],
      selectedAiImageIndex: json['selected_ai_image_index'] as int? ?? -1,
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
      variants: variants,
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
  bool get hasVariants => variants.isNotEmpty;
  
  /// Get the currently displayed image URL (AI-generated or original)
  String? get displayImageUrl {
    if (selectedAiImageIndex >= 0 && selectedAiImageIndex < aiGeneratedImages.length) {
      return aiGeneratedImages[selectedAiImageIndex];
    }
    return imageUrl;
  }
  
  /// Check if using an AI-generated image
  bool get isUsingAiImage => selectedAiImageIndex >= 0 && selectedAiImageIndex < aiGeneratedImages.length;
  
  /// Check if has AI-generated images
  bool get hasAiImages => aiGeneratedImages.isNotEmpty;
}

extension MenuItemVariantExtension on MenuItemVariant {
  String getName(String languageCode) {
    return translations[languageCode]?.name ?? 
           translations['en']?.name ?? 
           'Unnamed Variant';
  }
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
