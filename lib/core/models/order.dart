import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class CustomerSession with _$CustomerSession {
  const factory CustomerSession({
    required String id,
    String? tableId,
    String? branchId,
    String? restaurantId,
    @Default('en') String languageCode,
    @Default({}) Map<String, dynamic> deviceInfo,
    required DateTime startedAt,
    DateTime? endedAt,
    @Default(true) bool isActive,
  }) = _CustomerSession;

  factory CustomerSession.fromJson(Map<String, dynamic> json) =>
      _$CustomerSessionFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required int orderNumber,
    String? sessionId,
    String? tableId,
    String? branchId,
    required String restaurantId,
    @Default('pending') String status,
    @Default('unpaid') String paymentStatus,
    String? paymentMethod,
    String? stripePaymentIntentId,
    @Default(0) double subtotal,
    @Default(0) double tax,
    @Default(0) double total,
    @Default(0) double platformFee,
    String? notes,
    @Default('en') String customerLanguage,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
    // Order items loaded separately
    @Default([]) List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String orderId,
    String? menuItemId,
    required String itemName,
    @Default(1) int quantity,
    required double unitPrice,
    required double totalPrice,
    String? specialRequests,
    @Default([]) List<OrderModifier> modifiers,
    required DateTime createdAt,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class OrderModifier with _$OrderModifier {
  const factory OrderModifier({
    required String name,
    required double price,
  }) = _OrderModifier;

  factory OrderModifier.fromJson(Map<String, dynamic> json) =>
      _$OrderModifierFromJson(json);
}

// Order status enum with helper methods
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  served,
  completed,
  cancelled;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.pending,
    );
  }

  bool get isActive => this != completed && this != cancelled;
  bool get canBeCancelled => this == pending || this == confirmed;
  bool get canBeConfirmed => this == pending;
  bool get canBePreparing => this == confirmed;
  bool get canBeReady => this == preparing;
  bool get canBeServed => this == ready;
  bool get canBeCompleted => this == served;
}

enum PaymentStatus {
  unpaid,
  paid,
  refunded;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentStatus.unpaid,
    );
  }
}

enum PaymentMethod {
  stripe,
  direct;

  static PaymentMethod? fromString(String? value) {
    if (value == null) return null;
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentMethod.direct,
    );
  }
}

// Extension for order calculations
extension OrderExtension on Order {
  OrderStatus get statusEnum => OrderStatus.fromString(status);
  PaymentStatus get paymentStatusEnum => PaymentStatus.fromString(paymentStatus);
  PaymentMethod? get paymentMethodEnum => PaymentMethod.fromString(paymentMethod);
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isPreparing => status == 'preparing';
  bool get isReady => status == 'ready';
  bool get isServed => status == 'served';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isActive => statusEnum.isActive;
  
  bool get isPaid => paymentStatus == 'paid';
  bool get isUnpaid => paymentStatus == 'unpaid';
}
