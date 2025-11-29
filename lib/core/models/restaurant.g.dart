// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantImpl _$$RestaurantImplFromJson(Map<String, dynamic> json) =>
    _$RestaurantImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logoUrl: json['logoUrl'] as String?,
      currency: json['currency'] as String? ?? 'USD',
      timezone: json['timezone'] as String? ?? 'UTC',
      defaultLanguage: json['defaultLanguage'] as String? ?? 'en',
      settings: json['settings'] == null
          ? const RestaurantSettings()
          : RestaurantSettings.fromJson(
              json['settings'] as Map<String, dynamic>),
      stripeAccountId: json['stripeAccountId'] as String?,
      stripeAccountStatus: json['stripeAccountStatus'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RestaurantImplToJson(_$RestaurantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'slug': instance.slug,
      'logoUrl': instance.logoUrl,
      'currency': instance.currency,
      'timezone': instance.timezone,
      'defaultLanguage': instance.defaultLanguage,
      'settings': instance.settings,
      'stripeAccountId': instance.stripeAccountId,
      'stripeAccountStatus': instance.stripeAccountStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$RestaurantSettingsImpl _$$RestaurantSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantSettingsImpl(
      requireOrderConfirmation:
          json['requireOrderConfirmation'] as bool? ?? false,
      allowDirectPayment: json['allowDirectPayment'] as bool? ?? true,
      autoAcceptOrders: json['autoAcceptOrders'] as bool? ?? true,
    );

Map<String, dynamic> _$$RestaurantSettingsImplToJson(
        _$RestaurantSettingsImpl instance) =>
    <String, dynamic>{
      'requireOrderConfirmation': instance.requireOrderConfirmation,
      'allowDirectPayment': instance.allowDirectPayment,
      'autoAcceptOrders': instance.autoAcceptOrders,
    };

_$BranchImpl _$$BranchImplFromJson(Map<String, dynamic> json) => _$BranchImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      phone: json['phone'] as String?,
      timezone: json['timezone'] as String? ?? 'UTC',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BranchImplToJson(_$BranchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'phone': instance.phone,
      'timezone': instance.timezone,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$RestaurantTableImpl _$$RestaurantTableImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantTableImpl(
      id: json['id'] as String,
      branchId: json['branchId'] as String,
      tableNumber: json['tableNumber'] as String,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      capacity: (json['capacity'] as num?)?.toInt() ?? 4,
      isActive: json['isActive'] as bool? ?? true,
      currentSessionId: json['currentSessionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RestaurantTableImplToJson(
        _$RestaurantTableImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'tableNumber': instance.tableNumber,
      'qrCodeUrl': instance.qrCodeUrl,
      'capacity': instance.capacity,
      'isActive': instance.isActive,
      'currentSessionId': instance.currentSessionId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      tier: json['tier'] as String? ?? 'starter',
      status: json['status'] as String? ?? 'active',
      videoCreditsRemaining:
          (json['videoCreditsRemaining'] as num?)?.toInt() ?? 5,
      currentPeriodStart: json['currentPeriodStart'] == null
          ? null
          : DateTime.parse(json['currentPeriodStart'] as String),
      currentPeriodEnd: json['currentPeriodEnd'] == null
          ? null
          : DateTime.parse(json['currentPeriodEnd'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'stripeCustomerId': instance.stripeCustomerId,
      'tier': instance.tier,
      'status': instance.status,
      'videoCreditsRemaining': instance.videoCreditsRemaining,
      'currentPeriodStart': instance.currentPeriodStart?.toIso8601String(),
      'currentPeriodEnd': instance.currentPeriodEnd?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$StaffMemberImpl _$$StaffMemberImplFromJson(Map<String, dynamic> json) =>
    _$StaffMemberImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      userId: json['userId'] as String?,
      role: json['role'] as String? ?? 'staff',
      branchIds: (json['branchIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      permissions: json['permissions'] as Map<String, dynamic>? ?? const {},
      isActive: json['isActive'] as bool? ?? true,
      invitedEmail: json['invitedEmail'] as String?,
      invitedAt: json['invitedAt'] == null
          ? null
          : DateTime.parse(json['invitedAt'] as String),
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StaffMemberImplToJson(_$StaffMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'userId': instance.userId,
      'role': instance.role,
      'branchIds': instance.branchIds,
      'permissions': instance.permissions,
      'isActive': instance.isActive,
      'invitedEmail': instance.invitedEmail,
      'invitedAt': instance.invitedAt?.toIso8601String(),
      'joinedAt': instance.joinedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
