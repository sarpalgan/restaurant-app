// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerSession _$CustomerSessionFromJson(Map<String, dynamic> json) {
  return _CustomerSession.fromJson(json);
}

/// @nodoc
mixin _$CustomerSession {
  String get id => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String? get restaurantId => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  Map<String, dynamic> get deviceInfo => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this CustomerSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerSessionCopyWith<CustomerSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerSessionCopyWith<$Res> {
  factory $CustomerSessionCopyWith(
          CustomerSession value, $Res Function(CustomerSession) then) =
      _$CustomerSessionCopyWithImpl<$Res, CustomerSession>;
  @useResult
  $Res call(
      {String id,
      String? tableId,
      String? branchId,
      String? restaurantId,
      String languageCode,
      Map<String, dynamic> deviceInfo,
      DateTime startedAt,
      DateTime? endedAt,
      bool isActive});
}

/// @nodoc
class _$CustomerSessionCopyWithImpl<$Res, $Val extends CustomerSession>
    implements $CustomerSessionCopyWith<$Res> {
  _$CustomerSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableId = freezed,
    Object? branchId = freezed,
    Object? restaurantId = freezed,
    Object? languageCode = null,
    Object? deviceInfo = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tableId: freezed == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String?,
      restaurantId: freezed == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String?,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: null == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerSessionImplCopyWith<$Res>
    implements $CustomerSessionCopyWith<$Res> {
  factory _$$CustomerSessionImplCopyWith(_$CustomerSessionImpl value,
          $Res Function(_$CustomerSessionImpl) then) =
      __$$CustomerSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? tableId,
      String? branchId,
      String? restaurantId,
      String languageCode,
      Map<String, dynamic> deviceInfo,
      DateTime startedAt,
      DateTime? endedAt,
      bool isActive});
}

/// @nodoc
class __$$CustomerSessionImplCopyWithImpl<$Res>
    extends _$CustomerSessionCopyWithImpl<$Res, _$CustomerSessionImpl>
    implements _$$CustomerSessionImplCopyWith<$Res> {
  __$$CustomerSessionImplCopyWithImpl(
      _$CustomerSessionImpl _value, $Res Function(_$CustomerSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomerSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableId = freezed,
    Object? branchId = freezed,
    Object? restaurantId = freezed,
    Object? languageCode = null,
    Object? deviceInfo = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$CustomerSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tableId: freezed == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String?,
      restaurantId: freezed == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String?,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: null == deviceInfo
          ? _value._deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerSessionImpl implements _CustomerSession {
  const _$CustomerSessionImpl(
      {required this.id,
      this.tableId,
      this.branchId,
      this.restaurantId,
      this.languageCode = 'en',
      final Map<String, dynamic> deviceInfo = const {},
      required this.startedAt,
      this.endedAt,
      this.isActive = true})
      : _deviceInfo = deviceInfo;

  factory _$CustomerSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String? tableId;
  @override
  final String? branchId;
  @override
  final String? restaurantId;
  @override
  @JsonKey()
  final String languageCode;
  final Map<String, dynamic> _deviceInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get deviceInfo {
    if (_deviceInfo is EqualUnmodifiableMapView) return _deviceInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deviceInfo);
  }

  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CustomerSession(id: $id, tableId: $tableId, branchId: $branchId, restaurantId: $restaurantId, languageCode: $languageCode, deviceInfo: $deviceInfo, startedAt: $startedAt, endedAt: $endedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            const DeepCollectionEquality()
                .equals(other._deviceInfo, _deviceInfo) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tableId,
      branchId,
      restaurantId,
      languageCode,
      const DeepCollectionEquality().hash(_deviceInfo),
      startedAt,
      endedAt,
      isActive);

  /// Create a copy of CustomerSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerSessionImplCopyWith<_$CustomerSessionImpl> get copyWith =>
      __$$CustomerSessionImplCopyWithImpl<_$CustomerSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerSessionImplToJson(
      this,
    );
  }
}

abstract class _CustomerSession implements CustomerSession {
  const factory _CustomerSession(
      {required final String id,
      final String? tableId,
      final String? branchId,
      final String? restaurantId,
      final String languageCode,
      final Map<String, dynamic> deviceInfo,
      required final DateTime startedAt,
      final DateTime? endedAt,
      final bool isActive}) = _$CustomerSessionImpl;

  factory _CustomerSession.fromJson(Map<String, dynamic> json) =
      _$CustomerSessionImpl.fromJson;

  @override
  String get id;
  @override
  String? get tableId;
  @override
  String? get branchId;
  @override
  String? get restaurantId;
  @override
  String get languageCode;
  @override
  Map<String, dynamic> get deviceInfo;
  @override
  DateTime get startedAt;
  @override
  DateTime? get endedAt;
  @override
  bool get isActive;

  /// Create a copy of CustomerSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerSessionImplCopyWith<_$CustomerSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  int get orderNumber => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get stripePaymentIntentId => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double get platformFee => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get customerLanguage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt =>
      throw _privateConstructorUsedError; // Order items loaded separately
  List<OrderItem> get items => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {String id,
      int orderNumber,
      String? sessionId,
      String? tableId,
      String? branchId,
      String restaurantId,
      String status,
      String paymentStatus,
      String? paymentMethod,
      String? stripePaymentIntentId,
      double subtotal,
      double tax,
      double total,
      double platformFee,
      String? notes,
      String customerLanguage,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? confirmedAt,
      DateTime? completedAt,
      List<OrderItem> items});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? sessionId = freezed,
    Object? tableId = freezed,
    Object? branchId = freezed,
    Object? restaurantId = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? subtotal = null,
    Object? tax = null,
    Object? total = null,
    Object? platformFee = null,
    Object? notes = freezed,
    Object? customerLanguage = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tableId: freezed == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String?,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      stripePaymentIntentId: freezed == stripePaymentIntentId
          ? _value.stripePaymentIntentId
          : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerLanguage: null == customerLanguage
          ? _value.customerLanguage
          : customerLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int orderNumber,
      String? sessionId,
      String? tableId,
      String? branchId,
      String restaurantId,
      String status,
      String paymentStatus,
      String? paymentMethod,
      String? stripePaymentIntentId,
      double subtotal,
      double tax,
      double total,
      double platformFee,
      String? notes,
      String customerLanguage,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? confirmedAt,
      DateTime? completedAt,
      List<OrderItem> items});
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? sessionId = freezed,
    Object? tableId = freezed,
    Object? branchId = freezed,
    Object? restaurantId = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? subtotal = null,
    Object? tax = null,
    Object? total = null,
    Object? platformFee = null,
    Object? notes = freezed,
    Object? customerLanguage = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
    Object? items = null,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tableId: freezed == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String?,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      stripePaymentIntentId: freezed == stripePaymentIntentId
          ? _value.stripePaymentIntentId
          : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerLanguage: null == customerLanguage
          ? _value.customerLanguage
          : customerLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      required this.orderNumber,
      this.sessionId,
      this.tableId,
      this.branchId,
      required this.restaurantId,
      this.status = 'pending',
      this.paymentStatus = 'unpaid',
      this.paymentMethod,
      this.stripePaymentIntentId,
      this.subtotal = 0,
      this.tax = 0,
      this.total = 0,
      this.platformFee = 0,
      this.notes,
      this.customerLanguage = 'en',
      required this.createdAt,
      required this.updatedAt,
      this.confirmedAt,
      this.completedAt,
      final List<OrderItem> items = const []})
      : _items = items;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final int orderNumber;
  @override
  final String? sessionId;
  @override
  final String? tableId;
  @override
  final String? branchId;
  @override
  final String restaurantId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  final String? paymentMethod;
  @override
  final String? stripePaymentIntentId;
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double tax;
  @override
  @JsonKey()
  final double total;
  @override
  @JsonKey()
  final double platformFee;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String customerLanguage;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? confirmedAt;
  @override
  final DateTime? completedAt;
// Order items loaded separately
  final List<OrderItem> _items;
// Order items loaded separately
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, sessionId: $sessionId, tableId: $tableId, branchId: $branchId, restaurantId: $restaurantId, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, stripePaymentIntentId: $stripePaymentIntentId, subtotal: $subtotal, tax: $tax, total: $total, platformFee: $platformFee, notes: $notes, customerLanguage: $customerLanguage, createdAt: $createdAt, updatedAt: $updatedAt, confirmedAt: $confirmedAt, completedAt: $completedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.stripePaymentIntentId, stripePaymentIntentId) ||
                other.stripePaymentIntentId == stripePaymentIntentId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customerLanguage, customerLanguage) ||
                other.customerLanguage == customerLanguage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        sessionId,
        tableId,
        branchId,
        restaurantId,
        status,
        paymentStatus,
        paymentMethod,
        stripePaymentIntentId,
        subtotal,
        tax,
        total,
        platformFee,
        notes,
        customerLanguage,
        createdAt,
        updatedAt,
        confirmedAt,
        completedAt,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {required final String id,
      required final int orderNumber,
      final String? sessionId,
      final String? tableId,
      final String? branchId,
      required final String restaurantId,
      final String status,
      final String paymentStatus,
      final String? paymentMethod,
      final String? stripePaymentIntentId,
      final double subtotal,
      final double tax,
      final double total,
      final double platformFee,
      final String? notes,
      final String customerLanguage,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? confirmedAt,
      final DateTime? completedAt,
      final List<OrderItem> items}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  int get orderNumber;
  @override
  String? get sessionId;
  @override
  String? get tableId;
  @override
  String? get branchId;
  @override
  String get restaurantId;
  @override
  String get status;
  @override
  String get paymentStatus;
  @override
  String? get paymentMethod;
  @override
  String? get stripePaymentIntentId;
  @override
  double get subtotal;
  @override
  double get tax;
  @override
  double get total;
  @override
  double get platformFee;
  @override
  String? get notes;
  @override
  String get customerLanguage;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get confirmedAt;
  @override
  DateTime? get completedAt; // Order items loaded separately
  @override
  List<OrderItem> get items;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String? get menuItemId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  List<OrderModifier> get modifiers => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      String? menuItemId,
      String itemName,
      int quantity,
      double unitPrice,
      double totalPrice,
      String? specialRequests,
      List<OrderModifier> modifiers,
      DateTime createdAt});
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? menuItemId = freezed,
    Object? itemName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? specialRequests = freezed,
    Object? modifiers = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      menuItemId: freezed == menuItemId
          ? _value.menuItemId
          : menuItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      modifiers: null == modifiers
          ? _value.modifiers
          : modifiers // ignore: cast_nullable_to_non_nullable
              as List<OrderModifier>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      String? menuItemId,
      String itemName,
      int quantity,
      double unitPrice,
      double totalPrice,
      String? specialRequests,
      List<OrderModifier> modifiers,
      DateTime createdAt});
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? menuItemId = freezed,
    Object? itemName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? specialRequests = freezed,
    Object? modifiers = null,
    Object? createdAt = null,
  }) {
    return _then(_$OrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      menuItemId: freezed == menuItemId
          ? _value.menuItemId
          : menuItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      modifiers: null == modifiers
          ? _value._modifiers
          : modifiers // ignore: cast_nullable_to_non_nullable
              as List<OrderModifier>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl(
      {required this.id,
      required this.orderId,
      this.menuItemId,
      required this.itemName,
      this.quantity = 1,
      required this.unitPrice,
      required this.totalPrice,
      this.specialRequests,
      final List<OrderModifier> modifiers = const [],
      required this.createdAt})
      : _modifiers = modifiers;

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String? menuItemId;
  @override
  final String itemName;
  @override
  @JsonKey()
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double totalPrice;
  @override
  final String? specialRequests;
  final List<OrderModifier> _modifiers;
  @override
  @JsonKey()
  List<OrderModifier> get modifiers {
    if (_modifiers is EqualUnmodifiableListView) return _modifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modifiers);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, menuItemId: $menuItemId, itemName: $itemName, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, specialRequests: $specialRequests, modifiers: $modifiers, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            const DeepCollectionEquality()
                .equals(other._modifiers, _modifiers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      menuItemId,
      itemName,
      quantity,
      unitPrice,
      totalPrice,
      specialRequests,
      const DeepCollectionEquality().hash(_modifiers),
      createdAt);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem(
      {required final String id,
      required final String orderId,
      final String? menuItemId,
      required final String itemName,
      final int quantity,
      required final double unitPrice,
      required final double totalPrice,
      final String? specialRequests,
      final List<OrderModifier> modifiers,
      required final DateTime createdAt}) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String? get menuItemId;
  @override
  String get itemName;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get totalPrice;
  @override
  String? get specialRequests;
  @override
  List<OrderModifier> get modifiers;
  @override
  DateTime get createdAt;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderModifier _$OrderModifierFromJson(Map<String, dynamic> json) {
  return _OrderModifier.fromJson(json);
}

/// @nodoc
mixin _$OrderModifier {
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this OrderModifier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModifierCopyWith<OrderModifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModifierCopyWith<$Res> {
  factory $OrderModifierCopyWith(
          OrderModifier value, $Res Function(OrderModifier) then) =
      _$OrderModifierCopyWithImpl<$Res, OrderModifier>;
  @useResult
  $Res call({String name, double price});
}

/// @nodoc
class _$OrderModifierCopyWithImpl<$Res, $Val extends OrderModifier>
    implements $OrderModifierCopyWith<$Res> {
  _$OrderModifierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModifierImplCopyWith<$Res>
    implements $OrderModifierCopyWith<$Res> {
  factory _$$OrderModifierImplCopyWith(
          _$OrderModifierImpl value, $Res Function(_$OrderModifierImpl) then) =
      __$$OrderModifierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double price});
}

/// @nodoc
class __$$OrderModifierImplCopyWithImpl<$Res>
    extends _$OrderModifierCopyWithImpl<$Res, _$OrderModifierImpl>
    implements _$$OrderModifierImplCopyWith<$Res> {
  __$$OrderModifierImplCopyWithImpl(
      _$OrderModifierImpl _value, $Res Function(_$OrderModifierImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderModifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = null,
  }) {
    return _then(_$OrderModifierImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModifierImpl implements _OrderModifier {
  const _$OrderModifierImpl({required this.name, required this.price});

  factory _$OrderModifierImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModifierImplFromJson(json);

  @override
  final String name;
  @override
  final double price;

  @override
  String toString() {
    return 'OrderModifier(name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModifierImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, price);

  /// Create a copy of OrderModifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModifierImplCopyWith<_$OrderModifierImpl> get copyWith =>
      __$$OrderModifierImplCopyWithImpl<_$OrderModifierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModifierImplToJson(
      this,
    );
  }
}

abstract class _OrderModifier implements OrderModifier {
  const factory _OrderModifier(
      {required final String name,
      required final double price}) = _$OrderModifierImpl;

  factory _OrderModifier.fromJson(Map<String, dynamic> json) =
      _$OrderModifierImpl.fromJson;

  @override
  String get name;
  @override
  double get price;

  /// Create a copy of OrderModifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModifierImplCopyWith<_$OrderModifierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
