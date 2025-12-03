// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemVariantImpl _$$MenuItemVariantImplFromJson(
        Map<String, dynamic> json) =>
    _$MenuItemVariantImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      price: (json['price'] as num).toDouble(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, VariantTranslation.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$MenuItemVariantImplToJson(
        _$MenuItemVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'price': instance.price,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'translations': instance.translations,
    };

_$VariantTranslationImpl _$$VariantTranslationImplFromJson(
        Map<String, dynamic> json) =>
    _$VariantTranslationImpl(
      id: json['id'] as String,
      variantId: json['variantId'] as String,
      languageCode: json['languageCode'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$VariantTranslationImplToJson(
        _$VariantTranslationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variantId': instance.variantId,
      'languageCode': instance.languageCode,
      'name': instance.name,
    };

_$MenuCategoryImpl _$$MenuCategoryImplFromJson(Map<String, dynamic> json) =>
    _$MenuCategoryImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      imageUrl: json['imageUrl'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, CategoryTranslation.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$MenuCategoryImplToJson(_$MenuCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'imageUrl': instance.imageUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'translations': instance.translations,
    };

_$CategoryTranslationImpl _$$CategoryTranslationImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryTranslationImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      languageCode: json['languageCode'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$CategoryTranslationImplToJson(
        _$CategoryTranslationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'languageCode': instance.languageCode,
      'name': instance.name,
      'description': instance.description,
    };

_$MenuItemImpl _$$MenuItemImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      restaurantId: json['restaurantId'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      originalImageUrl: json['originalImageUrl'] as String?,
      aiGeneratedImages: (json['aiGeneratedImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      selectedAiImageIndex:
          (json['selectedAiImageIndex'] as num?)?.toInt() ?? -1,
      videoUrl: json['videoUrl'] as String?,
      videoThumbnailUrl: json['videoThumbnailUrl'] as String?,
      videoStatus: json['videoStatus'] as String? ?? 'none',
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryTags: (json['dietaryTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      calories: (json['calories'] as num?)?.toInt(),
      prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ItemTranslation.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => MenuItemVariant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MenuItemImplToJson(_$MenuItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'restaurantId': instance.restaurantId,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'originalImageUrl': instance.originalImageUrl,
      'aiGeneratedImages': instance.aiGeneratedImages,
      'selectedAiImageIndex': instance.selectedAiImageIndex,
      'videoUrl': instance.videoUrl,
      'videoThumbnailUrl': instance.videoThumbnailUrl,
      'videoStatus': instance.videoStatus,
      'allergens': instance.allergens,
      'dietaryTags': instance.dietaryTags,
      'calories': instance.calories,
      'prepTimeMinutes': instance.prepTimeMinutes,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'translations': instance.translations,
      'variants': instance.variants,
    };

_$ItemTranslationImpl _$$ItemTranslationImplFromJson(
        Map<String, dynamic> json) =>
    _$ItemTranslationImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      languageCode: json['languageCode'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ItemTranslationImplToJson(
        _$ItemTranslationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'languageCode': instance.languageCode,
      'name': instance.name,
      'description': instance.description,
    };
