// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MenuItemVariant _$MenuItemVariantFromJson(Map<String, dynamic> json) {
  return _MenuItemVariant.fromJson(json);
}

/// @nodoc
mixin _$MenuItemVariant {
  String get id => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Map<String, VariantTranslation> get translations =>
      throw _privateConstructorUsedError;

  /// Serializes this MenuItemVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MenuItemVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuItemVariantCopyWith<MenuItemVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuItemVariantCopyWith<$Res> {
  factory $MenuItemVariantCopyWith(
          MenuItemVariant value, $Res Function(MenuItemVariant) then) =
      _$MenuItemVariantCopyWithImpl<$Res, MenuItemVariant>;
  @useResult
  $Res call(
      {String id,
      String itemId,
      double price,
      int sortOrder,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, VariantTranslation> translations});
}

/// @nodoc
class _$MenuItemVariantCopyWithImpl<$Res, $Val extends MenuItemVariant>
    implements $MenuItemVariantCopyWith<$Res> {
  _$MenuItemVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuItemVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? price = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value.translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, VariantTranslation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuItemVariantImplCopyWith<$Res>
    implements $MenuItemVariantCopyWith<$Res> {
  factory _$$MenuItemVariantImplCopyWith(_$MenuItemVariantImpl value,
          $Res Function(_$MenuItemVariantImpl) then) =
      __$$MenuItemVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String itemId,
      double price,
      int sortOrder,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, VariantTranslation> translations});
}

/// @nodoc
class __$$MenuItemVariantImplCopyWithImpl<$Res>
    extends _$MenuItemVariantCopyWithImpl<$Res, _$MenuItemVariantImpl>
    implements _$$MenuItemVariantImplCopyWith<$Res> {
  __$$MenuItemVariantImplCopyWithImpl(
      _$MenuItemVariantImpl _value, $Res Function(_$MenuItemVariantImpl) _then)
      : super(_value, _then);

  /// Create a copy of MenuItemVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? price = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
  }) {
    return _then(_$MenuItemVariantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value._translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, VariantTranslation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MenuItemVariantImpl implements _MenuItemVariant {
  const _$MenuItemVariantImpl(
      {required this.id,
      required this.itemId,
      required this.price,
      this.sortOrder = 0,
      required this.createdAt,
      required this.updatedAt,
      final Map<String, VariantTranslation> translations = const {}})
      : _translations = translations;

  factory _$MenuItemVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuItemVariantImplFromJson(json);

  @override
  final String id;
  @override
  final String itemId;
  @override
  final double price;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final Map<String, VariantTranslation> _translations;
  @override
  @JsonKey()
  Map<String, VariantTranslation> get translations {
    if (_translations is EqualUnmodifiableMapView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_translations);
  }

  @override
  String toString() {
    return 'MenuItemVariant(id: $id, itemId: $itemId, price: $price, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuItemVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._translations, _translations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, itemId, price, sortOrder,
      createdAt, updatedAt, const DeepCollectionEquality().hash(_translations));

  /// Create a copy of MenuItemVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuItemVariantImplCopyWith<_$MenuItemVariantImpl> get copyWith =>
      __$$MenuItemVariantImplCopyWithImpl<_$MenuItemVariantImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuItemVariantImplToJson(
      this,
    );
  }
}

abstract class _MenuItemVariant implements MenuItemVariant {
  const factory _MenuItemVariant(
          {required final String id,
          required final String itemId,
          required final double price,
          final int sortOrder,
          required final DateTime createdAt,
          required final DateTime updatedAt,
          final Map<String, VariantTranslation> translations}) =
      _$MenuItemVariantImpl;

  factory _MenuItemVariant.fromJson(Map<String, dynamic> json) =
      _$MenuItemVariantImpl.fromJson;

  @override
  String get id;
  @override
  String get itemId;
  @override
  double get price;
  @override
  int get sortOrder;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Map<String, VariantTranslation> get translations;

  /// Create a copy of MenuItemVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuItemVariantImplCopyWith<_$MenuItemVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VariantTranslation _$VariantTranslationFromJson(Map<String, dynamic> json) {
  return _VariantTranslation.fromJson(json);
}

/// @nodoc
mixin _$VariantTranslation {
  String get id => throw _privateConstructorUsedError;
  String get variantId => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this VariantTranslation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VariantTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariantTranslationCopyWith<VariantTranslation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariantTranslationCopyWith<$Res> {
  factory $VariantTranslationCopyWith(
          VariantTranslation value, $Res Function(VariantTranslation) then) =
      _$VariantTranslationCopyWithImpl<$Res, VariantTranslation>;
  @useResult
  $Res call({String id, String variantId, String languageCode, String name});
}

/// @nodoc
class _$VariantTranslationCopyWithImpl<$Res, $Val extends VariantTranslation>
    implements $VariantTranslationCopyWith<$Res> {
  _$VariantTranslationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VariantTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variantId = null,
    Object? languageCode = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: null == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VariantTranslationImplCopyWith<$Res>
    implements $VariantTranslationCopyWith<$Res> {
  factory _$$VariantTranslationImplCopyWith(_$VariantTranslationImpl value,
          $Res Function(_$VariantTranslationImpl) then) =
      __$$VariantTranslationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String variantId, String languageCode, String name});
}

/// @nodoc
class __$$VariantTranslationImplCopyWithImpl<$Res>
    extends _$VariantTranslationCopyWithImpl<$Res, _$VariantTranslationImpl>
    implements _$$VariantTranslationImplCopyWith<$Res> {
  __$$VariantTranslationImplCopyWithImpl(_$VariantTranslationImpl _value,
      $Res Function(_$VariantTranslationImpl) _then)
      : super(_value, _then);

  /// Create a copy of VariantTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variantId = null,
    Object? languageCode = null,
    Object? name = null,
  }) {
    return _then(_$VariantTranslationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: null == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VariantTranslationImpl implements _VariantTranslation {
  const _$VariantTranslationImpl(
      {required this.id,
      required this.variantId,
      required this.languageCode,
      required this.name});

  factory _$VariantTranslationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariantTranslationImplFromJson(json);

  @override
  final String id;
  @override
  final String variantId;
  @override
  final String languageCode;
  @override
  final String name;

  @override
  String toString() {
    return 'VariantTranslation(id: $id, variantId: $variantId, languageCode: $languageCode, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariantTranslationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, variantId, languageCode, name);

  /// Create a copy of VariantTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariantTranslationImplCopyWith<_$VariantTranslationImpl> get copyWith =>
      __$$VariantTranslationImplCopyWithImpl<_$VariantTranslationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariantTranslationImplToJson(
      this,
    );
  }
}

abstract class _VariantTranslation implements VariantTranslation {
  const factory _VariantTranslation(
      {required final String id,
      required final String variantId,
      required final String languageCode,
      required final String name}) = _$VariantTranslationImpl;

  factory _VariantTranslation.fromJson(Map<String, dynamic> json) =
      _$VariantTranslationImpl.fromJson;

  @override
  String get id;
  @override
  String get variantId;
  @override
  String get languageCode;
  @override
  String get name;

  /// Create a copy of VariantTranslation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariantTranslationImplCopyWith<_$VariantTranslationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MenuCategory _$MenuCategoryFromJson(Map<String, dynamic> json) {
  return _MenuCategory.fromJson(json);
}

/// @nodoc
mixin _$MenuCategory {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Translations loaded separately
  Map<String, CategoryTranslation> get translations =>
      throw _privateConstructorUsedError;

  /// Serializes this MenuCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MenuCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuCategoryCopyWith<MenuCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuCategoryCopyWith<$Res> {
  factory $MenuCategoryCopyWith(
          MenuCategory value, $Res Function(MenuCategory) then) =
      _$MenuCategoryCopyWithImpl<$Res, MenuCategory>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String? imageUrl,
      int sortOrder,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, CategoryTranslation> translations});
}

/// @nodoc
class _$MenuCategoryCopyWithImpl<$Res, $Val extends MenuCategory>
    implements $MenuCategoryCopyWith<$Res> {
  _$MenuCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value.translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, CategoryTranslation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuCategoryImplCopyWith<$Res>
    implements $MenuCategoryCopyWith<$Res> {
  factory _$$MenuCategoryImplCopyWith(
          _$MenuCategoryImpl value, $Res Function(_$MenuCategoryImpl) then) =
      __$$MenuCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String? imageUrl,
      int sortOrder,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, CategoryTranslation> translations});
}

/// @nodoc
class __$$MenuCategoryImplCopyWithImpl<$Res>
    extends _$MenuCategoryCopyWithImpl<$Res, _$MenuCategoryImpl>
    implements _$$MenuCategoryImplCopyWith<$Res> {
  __$$MenuCategoryImplCopyWithImpl(
      _$MenuCategoryImpl _value, $Res Function(_$MenuCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MenuCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? imageUrl = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
  }) {
    return _then(_$MenuCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value._translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, CategoryTranslation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MenuCategoryImpl implements _MenuCategory {
  const _$MenuCategoryImpl(
      {required this.id,
      required this.restaurantId,
      this.imageUrl,
      this.sortOrder = 0,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      final Map<String, CategoryTranslation> translations = const {}})
      : _translations = translations;

  factory _$MenuCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Translations loaded separately
  final Map<String, CategoryTranslation> _translations;
// Translations loaded separately
  @override
  @JsonKey()
  Map<String, CategoryTranslation> get translations {
    if (_translations is EqualUnmodifiableMapView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_translations);
  }

  @override
  String toString() {
    return 'MenuCategory(id: $id, restaurantId: $restaurantId, imageUrl: $imageUrl, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._translations, _translations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      restaurantId,
      imageUrl,
      sortOrder,
      isActive,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_translations));

  /// Create a copy of MenuCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuCategoryImplCopyWith<_$MenuCategoryImpl> get copyWith =>
      __$$MenuCategoryImplCopyWithImpl<_$MenuCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuCategoryImplToJson(
      this,
    );
  }
}

abstract class _MenuCategory implements MenuCategory {
  const factory _MenuCategory(
          {required final String id,
          required final String restaurantId,
          final String? imageUrl,
          final int sortOrder,
          final bool isActive,
          required final DateTime createdAt,
          required final DateTime updatedAt,
          final Map<String, CategoryTranslation> translations}) =
      _$MenuCategoryImpl;

  factory _MenuCategory.fromJson(Map<String, dynamic> json) =
      _$MenuCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String? get imageUrl;
  @override
  int get sortOrder;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Translations loaded separately
  @override
  Map<String, CategoryTranslation> get translations;

  /// Create a copy of MenuCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuCategoryImplCopyWith<_$MenuCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryTranslation _$CategoryTranslationFromJson(Map<String, dynamic> json) {
  return _CategoryTranslation.fromJson(json);
}

/// @nodoc
mixin _$CategoryTranslation {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CategoryTranslation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryTranslationCopyWith<CategoryTranslation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryTranslationCopyWith<$Res> {
  factory $CategoryTranslationCopyWith(
          CategoryTranslation value, $Res Function(CategoryTranslation) then) =
      _$CategoryTranslationCopyWithImpl<$Res, CategoryTranslation>;
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String languageCode,
      String name,
      String? description});
}

/// @nodoc
class _$CategoryTranslationCopyWithImpl<$Res, $Val extends CategoryTranslation>
    implements $CategoryTranslationCopyWith<$Res> {
  _$CategoryTranslationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? languageCode = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryTranslationImplCopyWith<$Res>
    implements $CategoryTranslationCopyWith<$Res> {
  factory _$$CategoryTranslationImplCopyWith(_$CategoryTranslationImpl value,
          $Res Function(_$CategoryTranslationImpl) then) =
      __$$CategoryTranslationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String languageCode,
      String name,
      String? description});
}

/// @nodoc
class __$$CategoryTranslationImplCopyWithImpl<$Res>
    extends _$CategoryTranslationCopyWithImpl<$Res, _$CategoryTranslationImpl>
    implements _$$CategoryTranslationImplCopyWith<$Res> {
  __$$CategoryTranslationImplCopyWithImpl(_$CategoryTranslationImpl _value,
      $Res Function(_$CategoryTranslationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? languageCode = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_$CategoryTranslationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryTranslationImpl implements _CategoryTranslation {
  const _$CategoryTranslationImpl(
      {required this.id,
      required this.categoryId,
      required this.languageCode,
      required this.name,
      this.description});

  factory _$CategoryTranslationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryTranslationImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final String languageCode;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'CategoryTranslation(id: $id, categoryId: $categoryId, languageCode: $languageCode, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryTranslationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, categoryId, languageCode, name, description);

  /// Create a copy of CategoryTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryTranslationImplCopyWith<_$CategoryTranslationImpl> get copyWith =>
      __$$CategoryTranslationImplCopyWithImpl<_$CategoryTranslationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryTranslationImplToJson(
      this,
    );
  }
}

abstract class _CategoryTranslation implements CategoryTranslation {
  const factory _CategoryTranslation(
      {required final String id,
      required final String categoryId,
      required final String languageCode,
      required final String name,
      final String? description}) = _$CategoryTranslationImpl;

  factory _CategoryTranslation.fromJson(Map<String, dynamic> json) =
      _$CategoryTranslationImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get languageCode;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of CategoryTranslation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryTranslationImplCopyWith<_$CategoryTranslationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) {
  return _MenuItem.fromJson(json);
}

/// @nodoc
mixin _$MenuItem {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get imageUrl =>
      throw _privateConstructorUsedError; // Original uploaded image (stored separately from the display imageUrl)
  String? get originalImageUrl =>
      throw _privateConstructorUsedError; // AI-generated images stored separately from the original uploaded image
  List<String> get aiGeneratedImages =>
      throw _privateConstructorUsedError; // Index of the currently selected AI image (-1 means use original imageUrl)
  int get selectedAiImageIndex => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;
  String? get videoThumbnailUrl => throw _privateConstructorUsedError;
  String get videoStatus => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  List<String> get dietaryTags => throw _privateConstructorUsedError;
  int? get calories => throw _privateConstructorUsedError;
  int? get prepTimeMinutes => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Translations loaded separately
  Map<String, ItemTranslation> get translations =>
      throw _privateConstructorUsedError; // Variants (size/quantity options with different prices)
  List<MenuItemVariant> get variants => throw _privateConstructorUsedError;

  /// Serializes this MenuItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuItemCopyWith<MenuItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuItemCopyWith<$Res> {
  factory $MenuItemCopyWith(MenuItem value, $Res Function(MenuItem) then) =
      _$MenuItemCopyWithImpl<$Res, MenuItem>;
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String restaurantId,
      double price,
      String? imageUrl,
      String? originalImageUrl,
      List<String> aiGeneratedImages,
      int selectedAiImageIndex,
      String? videoUrl,
      String? videoThumbnailUrl,
      String videoStatus,
      List<String> allergens,
      List<String> dietaryTags,
      int? calories,
      int? prepTimeMinutes,
      bool isAvailable,
      bool isFeatured,
      int sortOrder,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, ItemTranslation> translations,
      List<MenuItemVariant> variants});
}

/// @nodoc
class _$MenuItemCopyWithImpl<$Res, $Val extends MenuItem>
    implements $MenuItemCopyWith<$Res> {
  _$MenuItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? restaurantId = null,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? originalImageUrl = freezed,
    Object? aiGeneratedImages = null,
    Object? selectedAiImageIndex = null,
    Object? videoUrl = freezed,
    Object? videoThumbnailUrl = freezed,
    Object? videoStatus = null,
    Object? allergens = null,
    Object? dietaryTags = null,
    Object? calories = freezed,
    Object? prepTimeMinutes = freezed,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
    Object? variants = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalImageUrl: freezed == originalImageUrl
          ? _value.originalImageUrl
          : originalImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      aiGeneratedImages: null == aiGeneratedImages
          ? _value.aiGeneratedImages
          : aiGeneratedImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedAiImageIndex: null == selectedAiImageIndex
          ? _value.selectedAiImageIndex
          : selectedAiImageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoThumbnailUrl: freezed == videoThumbnailUrl
          ? _value.videoThumbnailUrl
          : videoThumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoStatus: null == videoStatus
          ? _value.videoStatus
          : videoStatus // ignore: cast_nullable_to_non_nullable
              as String,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryTags: null == dietaryTags
          ? _value.dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      prepTimeMinutes: freezed == prepTimeMinutes
          ? _value.prepTimeMinutes
          : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value.translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, ItemTranslation>,
      variants: null == variants
          ? _value.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<MenuItemVariant>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuItemImplCopyWith<$Res>
    implements $MenuItemCopyWith<$Res> {
  factory _$$MenuItemImplCopyWith(
          _$MenuItemImpl value, $Res Function(_$MenuItemImpl) then) =
      __$$MenuItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String restaurantId,
      double price,
      String? imageUrl,
      String? originalImageUrl,
      List<String> aiGeneratedImages,
      int selectedAiImageIndex,
      String? videoUrl,
      String? videoThumbnailUrl,
      String videoStatus,
      List<String> allergens,
      List<String> dietaryTags,
      int? calories,
      int? prepTimeMinutes,
      bool isAvailable,
      bool isFeatured,
      int sortOrder,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, ItemTranslation> translations,
      List<MenuItemVariant> variants});
}

/// @nodoc
class __$$MenuItemImplCopyWithImpl<$Res>
    extends _$MenuItemCopyWithImpl<$Res, _$MenuItemImpl>
    implements _$$MenuItemImplCopyWith<$Res> {
  __$$MenuItemImplCopyWithImpl(
      _$MenuItemImpl _value, $Res Function(_$MenuItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? restaurantId = null,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? originalImageUrl = freezed,
    Object? aiGeneratedImages = null,
    Object? selectedAiImageIndex = null,
    Object? videoUrl = freezed,
    Object? videoThumbnailUrl = freezed,
    Object? videoStatus = null,
    Object? allergens = null,
    Object? dietaryTags = null,
    Object? calories = freezed,
    Object? prepTimeMinutes = freezed,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
    Object? variants = null,
  }) {
    return _then(_$MenuItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalImageUrl: freezed == originalImageUrl
          ? _value.originalImageUrl
          : originalImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      aiGeneratedImages: null == aiGeneratedImages
          ? _value._aiGeneratedImages
          : aiGeneratedImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedAiImageIndex: null == selectedAiImageIndex
          ? _value.selectedAiImageIndex
          : selectedAiImageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoThumbnailUrl: freezed == videoThumbnailUrl
          ? _value.videoThumbnailUrl
          : videoThumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoStatus: null == videoStatus
          ? _value.videoStatus
          : videoStatus // ignore: cast_nullable_to_non_nullable
              as String,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryTags: null == dietaryTags
          ? _value._dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      prepTimeMinutes: freezed == prepTimeMinutes
          ? _value.prepTimeMinutes
          : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value._translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, ItemTranslation>,
      variants: null == variants
          ? _value._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<MenuItemVariant>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MenuItemImpl implements _MenuItem {
  const _$MenuItemImpl(
      {required this.id,
      required this.categoryId,
      required this.restaurantId,
      required this.price,
      this.imageUrl,
      this.originalImageUrl,
      final List<String> aiGeneratedImages = const [],
      this.selectedAiImageIndex = -1,
      this.videoUrl,
      this.videoThumbnailUrl,
      this.videoStatus = 'none',
      final List<String> allergens = const [],
      final List<String> dietaryTags = const [],
      this.calories,
      this.prepTimeMinutes,
      this.isAvailable = true,
      this.isFeatured = false,
      this.sortOrder = 0,
      required this.createdAt,
      required this.updatedAt,
      final Map<String, ItemTranslation> translations = const {},
      final List<MenuItemVariant> variants = const []})
      : _aiGeneratedImages = aiGeneratedImages,
        _allergens = allergens,
        _dietaryTags = dietaryTags,
        _translations = translations,
        _variants = variants;

  factory _$MenuItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuItemImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final String restaurantId;
  @override
  final double price;
  @override
  final String? imageUrl;
// Original uploaded image (stored separately from the display imageUrl)
  @override
  final String? originalImageUrl;
// AI-generated images stored separately from the original uploaded image
  final List<String> _aiGeneratedImages;
// AI-generated images stored separately from the original uploaded image
  @override
  @JsonKey()
  List<String> get aiGeneratedImages {
    if (_aiGeneratedImages is EqualUnmodifiableListView)
      return _aiGeneratedImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_aiGeneratedImages);
  }

// Index of the currently selected AI image (-1 means use original imageUrl)
  @override
  @JsonKey()
  final int selectedAiImageIndex;
  @override
  final String? videoUrl;
  @override
  final String? videoThumbnailUrl;
  @override
  @JsonKey()
  final String videoStatus;
  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  final List<String> _dietaryTags;
  @override
  @JsonKey()
  List<String> get dietaryTags {
    if (_dietaryTags is EqualUnmodifiableListView) return _dietaryTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryTags);
  }

  @override
  final int? calories;
  @override
  final int? prepTimeMinutes;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Translations loaded separately
  final Map<String, ItemTranslation> _translations;
// Translations loaded separately
  @override
  @JsonKey()
  Map<String, ItemTranslation> get translations {
    if (_translations is EqualUnmodifiableMapView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_translations);
  }

// Variants (size/quantity options with different prices)
  final List<MenuItemVariant> _variants;
// Variants (size/quantity options with different prices)
  @override
  @JsonKey()
  List<MenuItemVariant> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, categoryId: $categoryId, restaurantId: $restaurantId, price: $price, imageUrl: $imageUrl, originalImageUrl: $originalImageUrl, aiGeneratedImages: $aiGeneratedImages, selectedAiImageIndex: $selectedAiImageIndex, videoUrl: $videoUrl, videoThumbnailUrl: $videoThumbnailUrl, videoStatus: $videoStatus, allergens: $allergens, dietaryTags: $dietaryTags, calories: $calories, prepTimeMinutes: $prepTimeMinutes, isAvailable: $isAvailable, isFeatured: $isFeatured, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations, variants: $variants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.originalImageUrl, originalImageUrl) ||
                other.originalImageUrl == originalImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._aiGeneratedImages, _aiGeneratedImages) &&
            (identical(other.selectedAiImageIndex, selectedAiImageIndex) ||
                other.selectedAiImageIndex == selectedAiImageIndex) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.videoThumbnailUrl, videoThumbnailUrl) ||
                other.videoThumbnailUrl == videoThumbnailUrl) &&
            (identical(other.videoStatus, videoStatus) ||
                other.videoStatus == videoStatus) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._dietaryTags, _dietaryTags) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.prepTimeMinutes, prepTimeMinutes) ||
                other.prepTimeMinutes == prepTimeMinutes) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._translations, _translations) &&
            const DeepCollectionEquality().equals(other._variants, _variants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        categoryId,
        restaurantId,
        price,
        imageUrl,
        originalImageUrl,
        const DeepCollectionEquality().hash(_aiGeneratedImages),
        selectedAiImageIndex,
        videoUrl,
        videoThumbnailUrl,
        videoStatus,
        const DeepCollectionEquality().hash(_allergens),
        const DeepCollectionEquality().hash(_dietaryTags),
        calories,
        prepTimeMinutes,
        isAvailable,
        isFeatured,
        sortOrder,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_translations),
        const DeepCollectionEquality().hash(_variants)
      ]);

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuItemImplCopyWith<_$MenuItemImpl> get copyWith =>
      __$$MenuItemImplCopyWithImpl<_$MenuItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuItemImplToJson(
      this,
    );
  }
}

abstract class _MenuItem implements MenuItem {
  const factory _MenuItem(
      {required final String id,
      required final String categoryId,
      required final String restaurantId,
      required final double price,
      final String? imageUrl,
      final String? originalImageUrl,
      final List<String> aiGeneratedImages,
      final int selectedAiImageIndex,
      final String? videoUrl,
      final String? videoThumbnailUrl,
      final String videoStatus,
      final List<String> allergens,
      final List<String> dietaryTags,
      final int? calories,
      final int? prepTimeMinutes,
      final bool isAvailable,
      final bool isFeatured,
      final int sortOrder,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final Map<String, ItemTranslation> translations,
      final List<MenuItemVariant> variants}) = _$MenuItemImpl;

  factory _MenuItem.fromJson(Map<String, dynamic> json) =
      _$MenuItemImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get restaurantId;
  @override
  double get price;
  @override
  String?
      get imageUrl; // Original uploaded image (stored separately from the display imageUrl)
  @override
  String?
      get originalImageUrl; // AI-generated images stored separately from the original uploaded image
  @override
  List<String>
      get aiGeneratedImages; // Index of the currently selected AI image (-1 means use original imageUrl)
  @override
  int get selectedAiImageIndex;
  @override
  String? get videoUrl;
  @override
  String? get videoThumbnailUrl;
  @override
  String get videoStatus;
  @override
  List<String> get allergens;
  @override
  List<String> get dietaryTags;
  @override
  int? get calories;
  @override
  int? get prepTimeMinutes;
  @override
  bool get isAvailable;
  @override
  bool get isFeatured;
  @override
  int get sortOrder;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Translations loaded separately
  @override
  Map<String, ItemTranslation>
      get translations; // Variants (size/quantity options with different prices)
  @override
  List<MenuItemVariant> get variants;

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuItemImplCopyWith<_$MenuItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ItemTranslation _$ItemTranslationFromJson(Map<String, dynamic> json) {
  return _ItemTranslation.fromJson(json);
}

/// @nodoc
mixin _$ItemTranslation {
  String get id => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ItemTranslation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemTranslationCopyWith<ItemTranslation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemTranslationCopyWith<$Res> {
  factory $ItemTranslationCopyWith(
          ItemTranslation value, $Res Function(ItemTranslation) then) =
      _$ItemTranslationCopyWithImpl<$Res, ItemTranslation>;
  @useResult
  $Res call(
      {String id,
      String itemId,
      String languageCode,
      String name,
      String? description});
}

/// @nodoc
class _$ItemTranslationCopyWithImpl<$Res, $Val extends ItemTranslation>
    implements $ItemTranslationCopyWith<$Res> {
  _$ItemTranslationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? languageCode = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemTranslationImplCopyWith<$Res>
    implements $ItemTranslationCopyWith<$Res> {
  factory _$$ItemTranslationImplCopyWith(_$ItemTranslationImpl value,
          $Res Function(_$ItemTranslationImpl) then) =
      __$$ItemTranslationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String itemId,
      String languageCode,
      String name,
      String? description});
}

/// @nodoc
class __$$ItemTranslationImplCopyWithImpl<$Res>
    extends _$ItemTranslationCopyWithImpl<$Res, _$ItemTranslationImpl>
    implements _$$ItemTranslationImplCopyWith<$Res> {
  __$$ItemTranslationImplCopyWithImpl(
      _$ItemTranslationImpl _value, $Res Function(_$ItemTranslationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItemTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? languageCode = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_$ItemTranslationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemTranslationImpl implements _ItemTranslation {
  const _$ItemTranslationImpl(
      {required this.id,
      required this.itemId,
      required this.languageCode,
      required this.name,
      this.description});

  factory _$ItemTranslationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemTranslationImplFromJson(json);

  @override
  final String id;
  @override
  final String itemId;
  @override
  final String languageCode;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'ItemTranslation(id: $id, itemId: $itemId, languageCode: $languageCode, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemTranslationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, itemId, languageCode, name, description);

  /// Create a copy of ItemTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemTranslationImplCopyWith<_$ItemTranslationImpl> get copyWith =>
      __$$ItemTranslationImplCopyWithImpl<_$ItemTranslationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemTranslationImplToJson(
      this,
    );
  }
}

abstract class _ItemTranslation implements ItemTranslation {
  const factory _ItemTranslation(
      {required final String id,
      required final String itemId,
      required final String languageCode,
      required final String name,
      final String? description}) = _$ItemTranslationImpl;

  factory _ItemTranslation.fromJson(Map<String, dynamic> json) =
      _$ItemTranslationImpl.fromJson;

  @override
  String get id;
  @override
  String get itemId;
  @override
  String get languageCode;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of ItemTranslation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemTranslationImplCopyWith<_$ItemTranslationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
