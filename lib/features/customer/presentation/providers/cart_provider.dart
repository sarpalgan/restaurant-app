import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Cart Item Model
class CartItem {
  final String menuItemId;
  final String name;
  final double unitPrice;
  final int quantity;
  final String? imageUrl;
  final String? specialRequests;

  CartItem({
    required this.menuItemId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.imageUrl,
    this.specialRequests,
  });

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? menuItemId,
    String? name,
    double? unitPrice,
    int? quantity,
    String? imageUrl,
    String? specialRequests,
  }) {
    return CartItem(
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }
}

// Cart State
class CartState {
  final List<CartItem> items;
  final String? orderNotes;
  final String? sessionId;
  final double taxRate;

  CartState({
    this.items = const [],
    this.orderNotes,
    this.sessionId,
    this.taxRate = 0.10, // 10% default tax
  });

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * taxRate;

  double get total => subtotal + tax;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    String? orderNotes,
    String? sessionId,
    double? taxRate,
  }) {
    return CartState(
      items: items ?? this.items,
      orderNotes: orderNotes ?? this.orderNotes,
      sessionId: sessionId ?? this.sessionId,
      taxRate: taxRate ?? this.taxRate,
    );
  }
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  final SupabaseClient _supabase;

  CartNotifier(this._supabase) : super(CartState());

  void addItem({
    required String menuItemId,
    required String name,
    required double unitPrice,
    String? imageUrl,
    int quantity = 1,
  }) {
    final existingIndex = state.items.indexWhere(
      (item) => item.menuItemId == menuItemId,
    );

    if (existingIndex >= 0) {
      // Update quantity of existing item
      final updatedItems = [...state.items];
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(
            menuItemId: menuItemId,
            name: name,
            unitPrice: unitPrice,
            quantity: quantity,
            imageUrl: imageUrl,
          ),
        ],
      );
    }
  }

  void removeItem(String menuItemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.menuItemId != menuItemId).toList(),
    );
  }

  void updateQuantity(String menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.menuItemId == menuItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void updateSpecialRequests(String menuItemId, String requests) {
    final updatedItems = state.items.map((item) {
      if (item.menuItemId == menuItemId) {
        return item.copyWith(specialRequests: requests);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void setOrderNotes(String notes) {
    state = state.copyWith(orderNotes: notes);
  }

  void clearCart() {
    state = CartState();
  }

  void setSessionId(String sessionId) {
    state = state.copyWith(sessionId: sessionId);
  }

  Future<String> placeOrder({
    required String restaurantSlug,
    required String tableId,
  }) async {
    if (state.items.isEmpty) {
      throw Exception('Cart is empty');
    }

    // Get restaurant and table info
    final restaurantResult = await _supabase
        .from('restaurants')
        .select('id')
        .eq('slug', restaurantSlug)
        .single();

    final tableResult = await _supabase
        .from('tables')
        .select('id, branch_id')
        .eq('id', tableId)
        .single();

    // Create or get customer session
    String sessionId = state.sessionId ?? '';
    if (sessionId.isEmpty) {
      final sessionResult = await _supabase
          .from('customer_sessions')
          .insert({
            'table_id': tableId,
            'branch_id': tableResult['branch_id'],
            'restaurant_id': restaurantResult['id'],
            'is_active': true,
          })
          .select('id')
          .single();
      sessionId = sessionResult['id'];
      setSessionId(sessionId);
    }

    // Create order
    final orderResult = await _supabase
        .from('orders')
        .insert({
          'session_id': sessionId,
          'table_id': tableId,
          'branch_id': tableResult['branch_id'],
          'restaurant_id': restaurantResult['id'],
          'status': 'pending',
          'payment_status': 'unpaid',
          'subtotal': state.subtotal,
          'tax': state.tax,
          'total': state.total,
          'platform_fee': state.total * 0.025, // 2.5% platform fee
          'notes': state.orderNotes,
        })
        .select('id')
        .single();

    final orderId = orderResult['id'] as String;

    // Create order items
    final orderItems = state.items.map((item) => {
      'order_id': orderId,
      'menu_item_id': item.menuItemId,
      'item_name': item.name,
      'quantity': item.quantity,
      'unit_price': item.unitPrice,
      'total_price': item.totalPrice,
      'special_requests': item.specialRequests,
    }).toList();

    await _supabase.from('order_items').insert(orderItems);

    // Track analytics event
    await _supabase.from('analytics_events').insert({
      'restaurant_id': restaurantResult['id'],
      'branch_id': tableResult['branch_id'],
      'session_id': sessionId,
      'table_id': tableId,
      'event_type': 'order_placed',
      'metadata': {
        'order_id': orderId,
        'total': state.total,
        'item_count': state.itemCount,
      },
    });

    return orderId;
  }
}

// Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(Supabase.instance.client);
});
