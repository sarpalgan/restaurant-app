import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

/// Helper to convert snake_case keys to camelCase for Supabase responses
Map<String, dynamic> _convertRestaurantJson(Map<String, dynamic> json) {
  return {
    'id': json['id'],
    'ownerId': json['owner_id'],
    'name': json['name'],
    'slug': json['slug'],
    'logoUrl': json['logo_url'],
    'currency': json['currency'],
    'timezone': json['timezone'],
    'defaultLanguage': json['default_language'],
    'settings': json['settings'],
    'stripeAccountId': json['stripe_account_id'],
    'stripeAccountStatus': json['stripe_account_status'],
    'createdAt': json['created_at'],
    'updatedAt': json['updated_at'],
  };
}

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String ownerId,
    required String name,
    required String slug,
    String? logoUrl,
    @Default('USD') String currency,
    @Default('UTC') String timezone,
    @Default('en') String defaultLanguage,
    @Default(RestaurantSettings()) RestaurantSettings settings,
    String? stripeAccountId,
    @Default('pending') String stripeAccountStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(_convertRestaurantJson(json));
}

@freezed
class RestaurantSettings with _$RestaurantSettings {
  const factory RestaurantSettings({
    @Default(false) bool requireOrderConfirmation,
    @Default(true) bool allowDirectPayment,
    @Default(true) bool autoAcceptOrders,
  }) = _RestaurantSettings;

  factory RestaurantSettings.fromJson(Map<String, dynamic> json) =>
      _$RestaurantSettingsFromJson({
        'requireOrderConfirmation': json['require_order_confirmation'] ?? json['requireOrderConfirmation'],
        'allowDirectPayment': json['allow_direct_payment'] ?? json['allowDirectPayment'],
        'autoAcceptOrders': json['auto_accept_orders'] ?? json['autoAcceptOrders'],
      });
}

Map<String, dynamic> _convertBranchJson(Map<String, dynamic> json) {
  return {
    'id': json['id'],
    'restaurantId': json['restaurant_id'],
    'name': json['name'],
    'address': json['address'],
    'city': json['city'],
    'country': json['country'],
    'phone': json['phone'],
    'timezone': json['timezone'],
    'isActive': json['is_active'],
    'createdAt': json['created_at'],
    'updatedAt': json['updated_at'],
  };
}

@freezed
class Branch with _$Branch {
  const factory Branch({
    required String id,
    required String restaurantId,
    required String name,
    String? address,
    String? city,
    String? country,
    String? phone,
    @Default('UTC') String timezone,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(_convertBranchJson(json));
}

Map<String, dynamic> _convertTableJson(Map<String, dynamic> json) {
  return {
    'id': json['id'],
    'branchId': json['branch_id'],
    'tableNumber': json['table_number'],
    'qrCodeUrl': json['qr_code_url'],
    'capacity': json['capacity'],
    'isActive': json['is_active'],
    'currentSessionId': json['current_session_id'],
    'createdAt': json['created_at'],
  };
}

@freezed
class RestaurantTable with _$RestaurantTable {
  const factory RestaurantTable({
    required String id,
    required String branchId,
    required String tableNumber,
    String? qrCodeUrl,
    @Default(4) int capacity,
    @Default(true) bool isActive,
    String? currentSessionId,
    required DateTime createdAt,
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      _$RestaurantTableFromJson(_convertTableJson(json));
}

Map<String, dynamic> _convertSubscriptionJson(Map<String, dynamic> json) {
  return {
    'id': json['id'],
    'restaurantId': json['restaurant_id'],
    'stripeSubscriptionId': json['stripe_subscription_id'],
    'stripeCustomerId': json['stripe_customer_id'],
    'tier': json['tier'],
    'status': json['status'],
    'videoCreditsRemaining': json['video_credits_remaining'],
    'currentPeriodStart': json['current_period_start'],
    'currentPeriodEnd': json['current_period_end'],
    'createdAt': json['created_at'],
    'updatedAt': json['updated_at'],
  };
}

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String restaurantId,
    String? stripeSubscriptionId,
    String? stripeCustomerId,
    @Default('starter') String tier,
    @Default('active') String status,
    @Default(5) int videoCreditsRemaining,
    DateTime? currentPeriodStart,
    DateTime? currentPeriodEnd,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(_convertSubscriptionJson(json));
}

Map<String, dynamic> _convertStaffJson(Map<String, dynamic> json) {
  return {
    'id': json['id'],
    'restaurantId': json['restaurant_id'],
    'userId': json['user_id'],
    'role': json['role'],
    'branchIds': json['branch_ids'],
    'permissions': json['permissions'],
    'isActive': json['is_active'],
    'invitedEmail': json['invited_email'],
    'invitedAt': json['invited_at'],
    'joinedAt': json['joined_at'],
    'createdAt': json['created_at'],
  };
}

@freezed
class StaffMember with _$StaffMember {
  const factory StaffMember({
    required String id,
    required String restaurantId,
    String? userId,
    @Default('staff') String role,
    @Default([]) List<String> branchIds,
    @Default({}) Map<String, dynamic> permissions,
    @Default(true) bool isActive,
    String? invitedEmail,
    DateTime? invitedAt,
    DateTime? joinedAt,
    required DateTime createdAt,
  }) = _StaffMember;

  factory StaffMember.fromJson(Map<String, dynamic> json) =>
      _$StaffMemberFromJson(_convertStaffJson(json));
}
