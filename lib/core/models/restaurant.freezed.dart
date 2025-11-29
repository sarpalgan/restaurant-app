// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return _Restaurant.fromJson(json);
}

/// @nodoc
mixin _$Restaurant {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  String get defaultLanguage => throw _privateConstructorUsedError;
  RestaurantSettings get settings => throw _privateConstructorUsedError;
  String? get stripeAccountId => throw _privateConstructorUsedError;
  String get stripeAccountStatus => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Restaurant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantCopyWith<Restaurant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantCopyWith<$Res> {
  factory $RestaurantCopyWith(
          Restaurant value, $Res Function(Restaurant) then) =
      _$RestaurantCopyWithImpl<$Res, Restaurant>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String slug,
      String? logoUrl,
      String currency,
      String timezone,
      String defaultLanguage,
      RestaurantSettings settings,
      String? stripeAccountId,
      String stripeAccountStatus,
      DateTime createdAt,
      DateTime updatedAt});

  $RestaurantSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$RestaurantCopyWithImpl<$Res, $Val extends Restaurant>
    implements $RestaurantCopyWith<$Res> {
  _$RestaurantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? slug = null,
    Object? logoUrl = freezed,
    Object? currency = null,
    Object? timezone = null,
    Object? defaultLanguage = null,
    Object? settings = null,
    Object? stripeAccountId = freezed,
    Object? stripeAccountStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as RestaurantSettings,
      stripeAccountId: freezed == stripeAccountId
          ? _value.stripeAccountId
          : stripeAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeAccountStatus: null == stripeAccountStatus
          ? _value.stripeAccountStatus
          : stripeAccountStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestaurantSettingsCopyWith<$Res> get settings {
    return $RestaurantSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RestaurantImplCopyWith<$Res>
    implements $RestaurantCopyWith<$Res> {
  factory _$$RestaurantImplCopyWith(
          _$RestaurantImpl value, $Res Function(_$RestaurantImpl) then) =
      __$$RestaurantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String slug,
      String? logoUrl,
      String currency,
      String timezone,
      String defaultLanguage,
      RestaurantSettings settings,
      String? stripeAccountId,
      String stripeAccountStatus,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $RestaurantSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$RestaurantImplCopyWithImpl<$Res>
    extends _$RestaurantCopyWithImpl<$Res, _$RestaurantImpl>
    implements _$$RestaurantImplCopyWith<$Res> {
  __$$RestaurantImplCopyWithImpl(
      _$RestaurantImpl _value, $Res Function(_$RestaurantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? slug = null,
    Object? logoUrl = freezed,
    Object? currency = null,
    Object? timezone = null,
    Object? defaultLanguage = null,
    Object? settings = null,
    Object? stripeAccountId = freezed,
    Object? stripeAccountStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$RestaurantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as RestaurantSettings,
      stripeAccountId: freezed == stripeAccountId
          ? _value.stripeAccountId
          : stripeAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeAccountStatus: null == stripeAccountStatus
          ? _value.stripeAccountStatus
          : stripeAccountStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantImpl implements _Restaurant {
  const _$RestaurantImpl(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.slug,
      this.logoUrl,
      this.currency = 'USD',
      this.timezone = 'UTC',
      this.defaultLanguage = 'en',
      this.settings = const RestaurantSettings(),
      this.stripeAccountId,
      this.stripeAccountStatus = 'pending',
      required this.createdAt,
      required this.updatedAt});

  factory _$RestaurantImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String timezone;
  @override
  @JsonKey()
  final String defaultLanguage;
  @override
  @JsonKey()
  final RestaurantSettings settings;
  @override
  final String? stripeAccountId;
  @override
  @JsonKey()
  final String stripeAccountStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Restaurant(id: $id, ownerId: $ownerId, name: $name, slug: $slug, logoUrl: $logoUrl, currency: $currency, timezone: $timezone, defaultLanguage: $defaultLanguage, settings: $settings, stripeAccountId: $stripeAccountId, stripeAccountStatus: $stripeAccountStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.stripeAccountId, stripeAccountId) ||
                other.stripeAccountId == stripeAccountId) &&
            (identical(other.stripeAccountStatus, stripeAccountStatus) ||
                other.stripeAccountStatus == stripeAccountStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ownerId,
      name,
      slug,
      logoUrl,
      currency,
      timezone,
      defaultLanguage,
      settings,
      stripeAccountId,
      stripeAccountStatus,
      createdAt,
      updatedAt);

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      __$$RestaurantImplCopyWithImpl<_$RestaurantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantImplToJson(
      this,
    );
  }
}

abstract class _Restaurant implements Restaurant {
  const factory _Restaurant(
      {required final String id,
      required final String ownerId,
      required final String name,
      required final String slug,
      final String? logoUrl,
      final String currency,
      final String timezone,
      final String defaultLanguage,
      final RestaurantSettings settings,
      final String? stripeAccountId,
      final String stripeAccountStatus,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$RestaurantImpl;

  factory _Restaurant.fromJson(Map<String, dynamic> json) =
      _$RestaurantImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get logoUrl;
  @override
  String get currency;
  @override
  String get timezone;
  @override
  String get defaultLanguage;
  @override
  RestaurantSettings get settings;
  @override
  String? get stripeAccountId;
  @override
  String get stripeAccountStatus;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RestaurantSettings _$RestaurantSettingsFromJson(Map<String, dynamic> json) {
  return _RestaurantSettings.fromJson(json);
}

/// @nodoc
mixin _$RestaurantSettings {
  bool get requireOrderConfirmation => throw _privateConstructorUsedError;
  bool get allowDirectPayment => throw _privateConstructorUsedError;
  bool get autoAcceptOrders => throw _privateConstructorUsedError;

  /// Serializes this RestaurantSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantSettingsCopyWith<RestaurantSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantSettingsCopyWith<$Res> {
  factory $RestaurantSettingsCopyWith(
          RestaurantSettings value, $Res Function(RestaurantSettings) then) =
      _$RestaurantSettingsCopyWithImpl<$Res, RestaurantSettings>;
  @useResult
  $Res call(
      {bool requireOrderConfirmation,
      bool allowDirectPayment,
      bool autoAcceptOrders});
}

/// @nodoc
class _$RestaurantSettingsCopyWithImpl<$Res, $Val extends RestaurantSettings>
    implements $RestaurantSettingsCopyWith<$Res> {
  _$RestaurantSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requireOrderConfirmation = null,
    Object? allowDirectPayment = null,
    Object? autoAcceptOrders = null,
  }) {
    return _then(_value.copyWith(
      requireOrderConfirmation: null == requireOrderConfirmation
          ? _value.requireOrderConfirmation
          : requireOrderConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDirectPayment: null == allowDirectPayment
          ? _value.allowDirectPayment
          : allowDirectPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      autoAcceptOrders: null == autoAcceptOrders
          ? _value.autoAcceptOrders
          : autoAcceptOrders // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RestaurantSettingsImplCopyWith<$Res>
    implements $RestaurantSettingsCopyWith<$Res> {
  factory _$$RestaurantSettingsImplCopyWith(_$RestaurantSettingsImpl value,
          $Res Function(_$RestaurantSettingsImpl) then) =
      __$$RestaurantSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool requireOrderConfirmation,
      bool allowDirectPayment,
      bool autoAcceptOrders});
}

/// @nodoc
class __$$RestaurantSettingsImplCopyWithImpl<$Res>
    extends _$RestaurantSettingsCopyWithImpl<$Res, _$RestaurantSettingsImpl>
    implements _$$RestaurantSettingsImplCopyWith<$Res> {
  __$$RestaurantSettingsImplCopyWithImpl(_$RestaurantSettingsImpl _value,
      $Res Function(_$RestaurantSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RestaurantSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requireOrderConfirmation = null,
    Object? allowDirectPayment = null,
    Object? autoAcceptOrders = null,
  }) {
    return _then(_$RestaurantSettingsImpl(
      requireOrderConfirmation: null == requireOrderConfirmation
          ? _value.requireOrderConfirmation
          : requireOrderConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDirectPayment: null == allowDirectPayment
          ? _value.allowDirectPayment
          : allowDirectPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      autoAcceptOrders: null == autoAcceptOrders
          ? _value.autoAcceptOrders
          : autoAcceptOrders // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantSettingsImpl implements _RestaurantSettings {
  const _$RestaurantSettingsImpl(
      {this.requireOrderConfirmation = false,
      this.allowDirectPayment = true,
      this.autoAcceptOrders = true});

  factory _$RestaurantSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool requireOrderConfirmation;
  @override
  @JsonKey()
  final bool allowDirectPayment;
  @override
  @JsonKey()
  final bool autoAcceptOrders;

  @override
  String toString() {
    return 'RestaurantSettings(requireOrderConfirmation: $requireOrderConfirmation, allowDirectPayment: $allowDirectPayment, autoAcceptOrders: $autoAcceptOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantSettingsImpl &&
            (identical(
                    other.requireOrderConfirmation, requireOrderConfirmation) ||
                other.requireOrderConfirmation == requireOrderConfirmation) &&
            (identical(other.allowDirectPayment, allowDirectPayment) ||
                other.allowDirectPayment == allowDirectPayment) &&
            (identical(other.autoAcceptOrders, autoAcceptOrders) ||
                other.autoAcceptOrders == autoAcceptOrders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, requireOrderConfirmation,
      allowDirectPayment, autoAcceptOrders);

  /// Create a copy of RestaurantSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantSettingsImplCopyWith<_$RestaurantSettingsImpl> get copyWith =>
      __$$RestaurantSettingsImplCopyWithImpl<_$RestaurantSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantSettingsImplToJson(
      this,
    );
  }
}

abstract class _RestaurantSettings implements RestaurantSettings {
  const factory _RestaurantSettings(
      {final bool requireOrderConfirmation,
      final bool allowDirectPayment,
      final bool autoAcceptOrders}) = _$RestaurantSettingsImpl;

  factory _RestaurantSettings.fromJson(Map<String, dynamic> json) =
      _$RestaurantSettingsImpl.fromJson;

  @override
  bool get requireOrderConfirmation;
  @override
  bool get allowDirectPayment;
  @override
  bool get autoAcceptOrders;

  /// Create a copy of RestaurantSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantSettingsImplCopyWith<_$RestaurantSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return _Branch.fromJson(json);
}

/// @nodoc
mixin _$Branch {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchCopyWith<Branch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchCopyWith<$Res> {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) then) =
      _$BranchCopyWithImpl<$Res, Branch>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String name,
      String? address,
      String? city,
      String? country,
      String? phone,
      String timezone,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$BranchCopyWithImpl<$Res, $Val extends Branch>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? phone = freezed,
    Object? timezone = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchImplCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$$BranchImplCopyWith(
          _$BranchImpl value, $Res Function(_$BranchImpl) then) =
      __$$BranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String name,
      String? address,
      String? city,
      String? country,
      String? phone,
      String timezone,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$BranchImplCopyWithImpl<$Res>
    extends _$BranchCopyWithImpl<$Res, _$BranchImpl>
    implements _$$BranchImplCopyWith<$Res> {
  __$$BranchImplCopyWithImpl(
      _$BranchImpl _value, $Res Function(_$BranchImpl) _then)
      : super(_value, _then);

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? phone = freezed,
    Object? timezone = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$BranchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchImpl implements _Branch {
  const _$BranchImpl(
      {required this.id,
      required this.restaurantId,
      required this.name,
      this.address,
      this.city,
      this.country,
      this.phone,
      this.timezone = 'UTC',
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});

  factory _$BranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchImplFromJson(json);

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? phone;
  @override
  @JsonKey()
  final String timezone;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Branch(id: $id, restaurantId: $restaurantId, name: $name, address: $address, city: $city, country: $country, phone: $phone, timezone: $timezone, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, restaurantId, name, address,
      city, country, phone, timezone, isActive, createdAt, updatedAt);

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      __$$BranchImplCopyWithImpl<_$BranchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchImplToJson(
      this,
    );
  }
}

abstract class _Branch implements Branch {
  const factory _Branch(
      {required final String id,
      required final String restaurantId,
      required final String name,
      final String? address,
      final String? city,
      final String? country,
      final String? phone,
      final String timezone,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$BranchImpl;

  factory _Branch.fromJson(Map<String, dynamic> json) = _$BranchImpl.fromJson;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get country;
  @override
  String? get phone;
  @override
  String get timezone;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RestaurantTable _$RestaurantTableFromJson(Map<String, dynamic> json) {
  return _RestaurantTable.fromJson(json);
}

/// @nodoc
mixin _$RestaurantTable {
  String get id => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get tableNumber => throw _privateConstructorUsedError;
  String? get qrCodeUrl => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get currentSessionId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RestaurantTable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantTableCopyWith<RestaurantTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantTableCopyWith<$Res> {
  factory $RestaurantTableCopyWith(
          RestaurantTable value, $Res Function(RestaurantTable) then) =
      _$RestaurantTableCopyWithImpl<$Res, RestaurantTable>;
  @useResult
  $Res call(
      {String id,
      String branchId,
      String tableNumber,
      String? qrCodeUrl,
      int capacity,
      bool isActive,
      String? currentSessionId,
      DateTime createdAt});
}

/// @nodoc
class _$RestaurantTableCopyWithImpl<$Res, $Val extends RestaurantTable>
    implements $RestaurantTableCopyWith<$Res> {
  _$RestaurantTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? tableNumber = null,
    Object? qrCodeUrl = freezed,
    Object? capacity = null,
    Object? isActive = null,
    Object? currentSessionId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      tableNumber: null == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSessionId: freezed == currentSessionId
          ? _value.currentSessionId
          : currentSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RestaurantTableImplCopyWith<$Res>
    implements $RestaurantTableCopyWith<$Res> {
  factory _$$RestaurantTableImplCopyWith(_$RestaurantTableImpl value,
          $Res Function(_$RestaurantTableImpl) then) =
      __$$RestaurantTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String branchId,
      String tableNumber,
      String? qrCodeUrl,
      int capacity,
      bool isActive,
      String? currentSessionId,
      DateTime createdAt});
}

/// @nodoc
class __$$RestaurantTableImplCopyWithImpl<$Res>
    extends _$RestaurantTableCopyWithImpl<$Res, _$RestaurantTableImpl>
    implements _$$RestaurantTableImplCopyWith<$Res> {
  __$$RestaurantTableImplCopyWithImpl(
      _$RestaurantTableImpl _value, $Res Function(_$RestaurantTableImpl) _then)
      : super(_value, _then);

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? tableNumber = null,
    Object? qrCodeUrl = freezed,
    Object? capacity = null,
    Object? isActive = null,
    Object? currentSessionId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$RestaurantTableImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      tableNumber: null == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSessionId: freezed == currentSessionId
          ? _value.currentSessionId
          : currentSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantTableImpl implements _RestaurantTable {
  const _$RestaurantTableImpl(
      {required this.id,
      required this.branchId,
      required this.tableNumber,
      this.qrCodeUrl,
      this.capacity = 4,
      this.isActive = true,
      this.currentSessionId,
      required this.createdAt});

  factory _$RestaurantTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantTableImplFromJson(json);

  @override
  final String id;
  @override
  final String branchId;
  @override
  final String tableNumber;
  @override
  final String? qrCodeUrl;
  @override
  @JsonKey()
  final int capacity;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? currentSessionId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RestaurantTable(id: $id, branchId: $branchId, tableNumber: $tableNumber, qrCodeUrl: $qrCodeUrl, capacity: $capacity, isActive: $isActive, currentSessionId: $currentSessionId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantTableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.qrCodeUrl, qrCodeUrl) ||
                other.qrCodeUrl == qrCodeUrl) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.currentSessionId, currentSessionId) ||
                other.currentSessionId == currentSessionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, branchId, tableNumber,
      qrCodeUrl, capacity, isActive, currentSessionId, createdAt);

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      __$$RestaurantTableImplCopyWithImpl<_$RestaurantTableImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantTableImplToJson(
      this,
    );
  }
}

abstract class _RestaurantTable implements RestaurantTable {
  const factory _RestaurantTable(
      {required final String id,
      required final String branchId,
      required final String tableNumber,
      final String? qrCodeUrl,
      final int capacity,
      final bool isActive,
      final String? currentSessionId,
      required final DateTime createdAt}) = _$RestaurantTableImpl;

  factory _RestaurantTable.fromJson(Map<String, dynamic> json) =
      _$RestaurantTableImpl.fromJson;

  @override
  String get id;
  @override
  String get branchId;
  @override
  String get tableNumber;
  @override
  String? get qrCodeUrl;
  @override
  int get capacity;
  @override
  bool get isActive;
  @override
  String? get currentSessionId;
  @override
  DateTime get createdAt;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String? get stripeSubscriptionId => throw _privateConstructorUsedError;
  String? get stripeCustomerId => throw _privateConstructorUsedError;
  String get tier => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get videoCreditsRemaining => throw _privateConstructorUsedError;
  DateTime? get currentPeriodStart => throw _privateConstructorUsedError;
  DateTime? get currentPeriodEnd => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String? stripeSubscriptionId,
      String? stripeCustomerId,
      String tier,
      String status,
      int videoCreditsRemaining,
      DateTime? currentPeriodStart,
      DateTime? currentPeriodEnd,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? stripeSubscriptionId = freezed,
    Object? stripeCustomerId = freezed,
    Object? tier = null,
    Object? status = null,
    Object? videoCreditsRemaining = null,
    Object? currentPeriodStart = freezed,
    Object? currentPeriodEnd = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      stripeSubscriptionId: freezed == stripeSubscriptionId
          ? _value.stripeSubscriptionId
          : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeCustomerId: freezed == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      videoCreditsRemaining: null == videoCreditsRemaining
          ? _value.videoCreditsRemaining
          : videoCreditsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      currentPeriodStart: freezed == currentPeriodStart
          ? _value.currentPeriodStart
          : currentPeriodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentPeriodEnd: freezed == currentPeriodEnd
          ? _value.currentPeriodEnd
          : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String? stripeSubscriptionId,
      String? stripeCustomerId,
      String tier,
      String status,
      int videoCreditsRemaining,
      DateTime? currentPeriodStart,
      DateTime? currentPeriodEnd,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? stripeSubscriptionId = freezed,
    Object? stripeCustomerId = freezed,
    Object? tier = null,
    Object? status = null,
    Object? videoCreditsRemaining = null,
    Object? currentPeriodStart = freezed,
    Object? currentPeriodEnd = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SubscriptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      stripeSubscriptionId: freezed == stripeSubscriptionId
          ? _value.stripeSubscriptionId
          : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeCustomerId: freezed == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      videoCreditsRemaining: null == videoCreditsRemaining
          ? _value.videoCreditsRemaining
          : videoCreditsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      currentPeriodStart: freezed == currentPeriodStart
          ? _value.currentPeriodStart
          : currentPeriodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentPeriodEnd: freezed == currentPeriodEnd
          ? _value.currentPeriodEnd
          : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl implements _Subscription {
  const _$SubscriptionImpl(
      {required this.id,
      required this.restaurantId,
      this.stripeSubscriptionId,
      this.stripeCustomerId,
      this.tier = 'starter',
      this.status = 'active',
      this.videoCreditsRemaining = 5,
      this.currentPeriodStart,
      this.currentPeriodEnd,
      required this.createdAt,
      required this.updatedAt});

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String? stripeSubscriptionId;
  @override
  final String? stripeCustomerId;
  @override
  @JsonKey()
  final String tier;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int videoCreditsRemaining;
  @override
  final DateTime? currentPeriodStart;
  @override
  final DateTime? currentPeriodEnd;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Subscription(id: $id, restaurantId: $restaurantId, stripeSubscriptionId: $stripeSubscriptionId, stripeCustomerId: $stripeCustomerId, tier: $tier, status: $status, videoCreditsRemaining: $videoCreditsRemaining, currentPeriodStart: $currentPeriodStart, currentPeriodEnd: $currentPeriodEnd, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.stripeSubscriptionId, stripeSubscriptionId) ||
                other.stripeSubscriptionId == stripeSubscriptionId) &&
            (identical(other.stripeCustomerId, stripeCustomerId) ||
                other.stripeCustomerId == stripeCustomerId) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.videoCreditsRemaining, videoCreditsRemaining) ||
                other.videoCreditsRemaining == videoCreditsRemaining) &&
            (identical(other.currentPeriodStart, currentPeriodStart) ||
                other.currentPeriodStart == currentPeriodStart) &&
            (identical(other.currentPeriodEnd, currentPeriodEnd) ||
                other.currentPeriodEnd == currentPeriodEnd) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      restaurantId,
      stripeSubscriptionId,
      stripeCustomerId,
      tier,
      status,
      videoCreditsRemaining,
      currentPeriodStart,
      currentPeriodEnd,
      createdAt,
      updatedAt);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription implements Subscription {
  const factory _Subscription(
      {required final String id,
      required final String restaurantId,
      final String? stripeSubscriptionId,
      final String? stripeCustomerId,
      final String tier,
      final String status,
      final int videoCreditsRemaining,
      final DateTime? currentPeriodStart,
      final DateTime? currentPeriodEnd,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$SubscriptionImpl;

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String? get stripeSubscriptionId;
  @override
  String? get stripeCustomerId;
  @override
  String get tier;
  @override
  String get status;
  @override
  int get videoCreditsRemaining;
  @override
  DateTime? get currentPeriodStart;
  @override
  DateTime? get currentPeriodEnd;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StaffMember _$StaffMemberFromJson(Map<String, dynamic> json) {
  return _StaffMember.fromJson(json);
}

/// @nodoc
mixin _$StaffMember {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  List<String> get branchIds => throw _privateConstructorUsedError;
  Map<String, dynamic> get permissions => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get invitedEmail => throw _privateConstructorUsedError;
  DateTime? get invitedAt => throw _privateConstructorUsedError;
  DateTime? get joinedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this StaffMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffMemberCopyWith<StaffMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffMemberCopyWith<$Res> {
  factory $StaffMemberCopyWith(
          StaffMember value, $Res Function(StaffMember) then) =
      _$StaffMemberCopyWithImpl<$Res, StaffMember>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String? userId,
      String role,
      List<String> branchIds,
      Map<String, dynamic> permissions,
      bool isActive,
      String? invitedEmail,
      DateTime? invitedAt,
      DateTime? joinedAt,
      DateTime createdAt});
}

/// @nodoc
class _$StaffMemberCopyWithImpl<$Res, $Val extends StaffMember>
    implements $StaffMemberCopyWith<$Res> {
  _$StaffMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? userId = freezed,
    Object? role = null,
    Object? branchIds = null,
    Object? permissions = null,
    Object? isActive = null,
    Object? invitedEmail = freezed,
    Object? invitedAt = freezed,
    Object? joinedAt = freezed,
    Object? createdAt = null,
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
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      branchIds: null == branchIds
          ? _value.branchIds
          : branchIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      invitedEmail: freezed == invitedEmail
          ? _value.invitedEmail
          : invitedEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedAt: freezed == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffMemberImplCopyWith<$Res>
    implements $StaffMemberCopyWith<$Res> {
  factory _$$StaffMemberImplCopyWith(
          _$StaffMemberImpl value, $Res Function(_$StaffMemberImpl) then) =
      __$$StaffMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String? userId,
      String role,
      List<String> branchIds,
      Map<String, dynamic> permissions,
      bool isActive,
      String? invitedEmail,
      DateTime? invitedAt,
      DateTime? joinedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$StaffMemberImplCopyWithImpl<$Res>
    extends _$StaffMemberCopyWithImpl<$Res, _$StaffMemberImpl>
    implements _$$StaffMemberImplCopyWith<$Res> {
  __$$StaffMemberImplCopyWithImpl(
      _$StaffMemberImpl _value, $Res Function(_$StaffMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? userId = freezed,
    Object? role = null,
    Object? branchIds = null,
    Object? permissions = null,
    Object? isActive = null,
    Object? invitedEmail = freezed,
    Object? invitedAt = freezed,
    Object? joinedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$StaffMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      branchIds: null == branchIds
          ? _value._branchIds
          : branchIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      invitedEmail: freezed == invitedEmail
          ? _value.invitedEmail
          : invitedEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedAt: freezed == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffMemberImpl implements _StaffMember {
  const _$StaffMemberImpl(
      {required this.id,
      required this.restaurantId,
      this.userId,
      this.role = 'staff',
      final List<String> branchIds = const [],
      final Map<String, dynamic> permissions = const {},
      this.isActive = true,
      this.invitedEmail,
      this.invitedAt,
      this.joinedAt,
      required this.createdAt})
      : _branchIds = branchIds,
        _permissions = permissions;

  factory _$StaffMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String? userId;
  @override
  @JsonKey()
  final String role;
  final List<String> _branchIds;
  @override
  @JsonKey()
  List<String> get branchIds {
    if (_branchIds is EqualUnmodifiableListView) return _branchIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branchIds);
  }

  final Map<String, dynamic> _permissions;
  @override
  @JsonKey()
  Map<String, dynamic> get permissions {
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_permissions);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? invitedEmail;
  @override
  final DateTime? invitedAt;
  @override
  final DateTime? joinedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'StaffMember(id: $id, restaurantId: $restaurantId, userId: $userId, role: $role, branchIds: $branchIds, permissions: $permissions, isActive: $isActive, invitedEmail: $invitedEmail, invitedAt: $invitedAt, joinedAt: $joinedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._branchIds, _branchIds) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.invitedEmail, invitedEmail) ||
                other.invitedEmail == invitedEmail) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      restaurantId,
      userId,
      role,
      const DeepCollectionEquality().hash(_branchIds),
      const DeepCollectionEquality().hash(_permissions),
      isActive,
      invitedEmail,
      invitedAt,
      joinedAt,
      createdAt);

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffMemberImplCopyWith<_$StaffMemberImpl> get copyWith =>
      __$$StaffMemberImplCopyWithImpl<_$StaffMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffMemberImplToJson(
      this,
    );
  }
}

abstract class _StaffMember implements StaffMember {
  const factory _StaffMember(
      {required final String id,
      required final String restaurantId,
      final String? userId,
      final String role,
      final List<String> branchIds,
      final Map<String, dynamic> permissions,
      final bool isActive,
      final String? invitedEmail,
      final DateTime? invitedAt,
      final DateTime? joinedAt,
      required final DateTime createdAt}) = _$StaffMemberImpl;

  factory _StaffMember.fromJson(Map<String, dynamic> json) =
      _$StaffMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String? get userId;
  @override
  String get role;
  @override
  List<String> get branchIds;
  @override
  Map<String, dynamic> get permissions;
  @override
  bool get isActive;
  @override
  String? get invitedEmail;
  @override
  DateTime? get invitedAt;
  @override
  DateTime? get joinedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of StaffMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffMemberImplCopyWith<_$StaffMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
