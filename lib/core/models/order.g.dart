// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerSessionImpl _$$CustomerSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerSessionImpl(
      id: json['id'] as String,
      tableId: json['tableId'] as String?,
      branchId: json['branchId'] as String?,
      restaurantId: json['restaurantId'] as String?,
      languageCode: json['languageCode'] as String? ?? 'en',
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>? ?? const {},
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CustomerSessionImplToJson(
        _$CustomerSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableId': instance.tableId,
      'branchId': instance.branchId,
      'restaurantId': instance.restaurantId,
      'languageCode': instance.languageCode,
      'deviceInfo': instance.deviceInfo,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      orderNumber: (json['orderNumber'] as num).toInt(),
      sessionId: json['sessionId'] as String?,
      tableId: json['tableId'] as String?,
      branchId: json['branchId'] as String?,
      restaurantId: json['restaurantId'] as String,
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
      paymentMethod: json['paymentMethod'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      customerLanguage: json['customerLanguage'] as String? ?? 'en',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'sessionId': instance.sessionId,
      'tableId': instance.tableId,
      'branchId': instance.branchId,
      'restaurantId': instance.restaurantId,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'total': instance.total,
      'platformFee': instance.platformFee,
      'notes': instance.notes,
      'customerLanguage': instance.customerLanguage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'items': instance.items,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      menuItemId: json['menuItemId'] as String?,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      specialRequests: json['specialRequests'] as String?,
      modifiers: (json['modifiers'] as List<dynamic>?)
              ?.map((e) => OrderModifier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'menuItemId': instance.menuItemId,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
      'specialRequests': instance.specialRequests,
      'modifiers': instance.modifiers,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$OrderModifierImpl _$$OrderModifierImplFromJson(Map<String, dynamic> json) =>
    _$OrderModifierImpl(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderModifierImplToJson(_$OrderModifierImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };
