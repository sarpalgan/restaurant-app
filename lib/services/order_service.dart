import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../core/models/order.dart';

// Active orders provider (realtime)
final activeOrdersProvider = StreamProvider.family<List<Order>, String>((ref, restaurantId) {
  return supabase
      .from('orders')
      .stream(primaryKey: ['id'])
      .eq('restaurant_id', restaurantId)
      .order('created_at', ascending: false)
      .map((data) => data
          .where((o) => ['pending', 'confirmed', 'preparing', 'ready'].contains(o['status']))
          .map((json) => Order.fromJson(json))
          .toList());
});

// Order history provider
final orderHistoryProvider = FutureProvider.family<List<Order>, String>((ref, restaurantId) async {
  final response = await supabase
      .from('orders')
      .select('*, order_items(*)')
      .eq('restaurant_id', restaurantId)
      .order('created_at', ascending: false)
      .limit(100);

  return (response as List).map((json) => Order.fromJson(json)).toList();
});

// Today's orders count
final todayOrdersCountProvider = FutureProvider.family<int, String>((ref, restaurantId) async {
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  
  final response = await supabase
      .from('orders')
      .select('id')
      .eq('restaurant_id', restaurantId)
      .gte('created_at', startOfDay.toIso8601String());

  return (response as List).length;
});

// Today's revenue
final todayRevenueProvider = FutureProvider.family<double, String>((ref, restaurantId) async {
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  
  final response = await supabase
      .from('orders')
      .select('total_amount')
      .eq('restaurant_id', restaurantId)
      .eq('status', 'completed')
      .gte('created_at', startOfDay.toIso8601String());

  double total = 0;
  for (final order in (response as List)) {
    total += (order['total_amount'] as num).toDouble();
  }
  return total;
});

// Order service for CRUD operations
class OrderService {
  // Create order (for customer)
  Future<Order> createOrder({
    required String restaurantId,
    required String tableId,
    required String sessionId,
    required List<OrderItem> items,
    String? notes,
  }) async {
    // Calculate totals
    double subtotal = 0;
    for (final item in items) {
      subtotal += item.unitPrice * item.quantity;
    }

    final response = await supabase.from('orders').insert({
      'restaurant_id': restaurantId,
      'table_id': tableId,
      'session_id': sessionId,
      'status': 'pending',
      'subtotal': subtotal,
      'tax_amount': 0,
      'total_amount': subtotal,
      'notes': notes,
    }).select().single();

    final orderId = response['id'];

    // Insert order items
    for (final item in items) {
      await supabase.from('order_items').insert({
        'order_id': orderId,
        'menu_item_id': item.menuItemId,
        'quantity': item.quantity,
        'unit_price': item.unitPrice,
        'special_requests': item.specialRequests,
      });
    }

    return Order.fromJson(response);
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await supabase
        .from('orders')
        .update({'status': status})
        .eq('id', orderId);
  }

  // Get order by ID
  Future<Order?> getOrder(String orderId) async {
    final response = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', orderId)
        .maybeSingle();

    if (response == null) return null;
    return Order.fromJson(response);
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    await supabase
        .from('orders')
        .update({'status': 'cancelled'})
        .eq('id', orderId);
  }

  // Mark order as paid
  Future<void> markOrderAsPaid({
    required String orderId,
    required String paymentIntentId,
    required String paymentMethod,
  }) async {
    await supabase.from('orders').update({
      'payment_status': 'paid',
      'payment_intent_id': paymentIntentId,
      'payment_method': paymentMethod,
    }).eq('id', orderId);
  }
}

// Order service provider
final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

// Customer session provider
class CustomerSessionService {
  Future<CustomerSession> createSession({
    required String tableId,
    String? languageCode,
  }) async {
    final response = await supabase.from('customer_sessions').insert({
      'table_id': tableId,
      'language_code': languageCode ?? 'en',
      'status': 'active',
    }).select().single();

    return CustomerSession.fromJson(response);
  }

  Future<CustomerSession?> getActiveSession(String tableId) async {
    final response = await supabase
        .from('customer_sessions')
        .select()
        .eq('table_id', tableId)
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return CustomerSession.fromJson(response);
  }

  Future<void> endSession(String sessionId) async {
    await supabase
        .from('customer_sessions')
        .update({'status': 'closed', 'ended_at': DateTime.now().toIso8601String()})
        .eq('id', sessionId);
  }
}

final customerSessionServiceProvider = Provider<CustomerSessionService>((ref) {
  return CustomerSessionService();
});
