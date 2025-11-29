import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<_OrderTab> _tabs = [
    _OrderTab(title: 'New', status: OrderStatus.pending, count: 5),
    _OrderTab(title: 'Preparing', status: OrderStatus.preparing, count: 3),
    _OrderTab(title: 'Ready', status: OrderStatus.ready, count: 2),
    _OrderTab(title: 'Completed', status: OrderStatus.completed, count: 45),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showOrderHistory,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: isSmallScreen,
          tabAlignment: isSmallScreen ? TabAlignment.start : TabAlignment.fill,
          labelPadding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 8),
          tabs: _tabs.map((tab) => Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      tab.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (tab.count > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(tab.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${tab.count}',
                        style: TextStyle(
                          fontSize: 11,
                          color: _getStatusColor(tab.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => _buildOrdersList(theme, tab.status)).toList(),
      ),
    );
  }

  Widget _buildOrdersList(ThemeData theme, OrderStatus status) {
    // Mock data - will be replaced with real data from Supabase
    final orders = _getMockOrders(status);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No ${status.name} orders',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh orders
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(theme, orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(ThemeData theme, _Order order) {
    final statusColor = _getStatusColor(order.status);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.table_bar,
                      color: theme.primaryColor,
                      size: isSmallScreen ? 18 : 20,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.tableNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Order #${order.orderNumber}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontSize: isSmallScreen ? 11 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order.status.displayName,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontSize: isSmallScreen ? 10 : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              // Items
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: isSmallScreen ? 22 : 24,
                      height: isSmallScreen ? 22 : 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 11 : 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.notes != null)
                            Text(
                              item.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange,
                                fontStyle: FontStyle.italic,
                                fontSize: isSmallScreen ? 11 : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: isSmallScreen ? 12 : null,
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const Divider(height: 16),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.items.length} items',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (order.status != OrderStatus.completed) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (order.status == OrderStatus.pending) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectOrder(order),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 8 : 12,
                            ),
                          ),
                          child: Text(
                            'Reject',
                            style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                    ],
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _updateOrderStatus(order),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _getNextActionText(order.status),
                            style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getNextActionText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Accept & Start';
      case OrderStatus.preparing:
        return 'Mark Ready';
      case OrderStatus.ready:
        return 'Complete';
      default:
        return '';
    }
  }

  void _showOrderDetails(_Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _OrderDetailsSheet(
          order: order,
          scrollController: scrollController,
          onStatusUpdate: () {
            Navigator.pop(context);
            _updateOrderStatus(order);
          },
        ),
      ),
    );
  }

  void _updateOrderStatus(_Order order) {
    // TODO: Update order status in database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #${order.orderNumber} status updated'),
      ),
    );
  }

  void _rejectOrder(_Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Order'),
        content: Text('Are you sure you want to reject order #${order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Reject order
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #${order.orderNumber} rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filter Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Today'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('This Week'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.table_bar),
              title: const Text('By Table'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderHistory() {
    // TODO: Navigate to order history
  }

  List<_Order> _getMockOrders(OrderStatus status) {
    final allOrders = [
      _Order(
        id: '1',
        orderNumber: '1234',
        tableNumber: 'Table 5',
        status: OrderStatus.pending,
        timeAgo: '2 min ago',
        items: [
          _OrderItem(name: 'Grilled Salmon', quantity: 2, price: 24.99),
          _OrderItem(name: 'Caesar Salad', quantity: 1, price: 12.99),
          _OrderItem(name: 'Sparkling Water', quantity: 2, price: 4.99, notes: 'No ice'),
        ],
        total: 72.95,
      ),
      _Order(
        id: '2',
        orderNumber: '1233',
        tableNumber: 'Table 2',
        status: OrderStatus.pending,
        timeAgo: '5 min ago',
        items: [
          _OrderItem(name: 'Margherita Pizza', quantity: 1, price: 18.99),
          _OrderItem(name: 'Tiramisu', quantity: 2, price: 8.99),
        ],
        total: 36.97,
      ),
      _Order(
        id: '3',
        orderNumber: '1232',
        tableNumber: 'Table 8',
        status: OrderStatus.preparing,
        timeAgo: '12 min ago',
        items: [
          _OrderItem(name: 'Beef Steak', quantity: 1, price: 32.99, notes: 'Medium rare'),
          _OrderItem(name: 'Mashed Potatoes', quantity: 1, price: 6.99),
        ],
        total: 39.98,
      ),
      _Order(
        id: '4',
        orderNumber: '1231',
        tableNumber: 'Table 3',
        status: OrderStatus.ready,
        timeAgo: '18 min ago',
        items: [
          _OrderItem(name: 'Chicken Pasta', quantity: 2, price: 16.99),
        ],
        total: 33.98,
      ),
    ];

    return allOrders.where((o) => o.status == status).toList();
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  final _Order order;
  final ScrollController scrollController;
  final VoidCallback onStatusUpdate;

  const _OrderDetailsSheet({
    required this.order,
    required this.scrollController,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderNumber}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        order.tableNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    order.timeAgo,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Items
              Text(
                'Order Items',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...order.items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}x',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (item.notes != null)
                            Text(
                              'Note: ${item.notes}',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )).toList(),
              
              const Divider(height: 32),
              
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              if (order.status != OrderStatus.completed)
                FilledButton(
                  onPressed: onStatusUpdate,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_getActionText()),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getActionText() {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Accept & Start Preparing';
      case OrderStatus.preparing:
        return 'Mark as Ready';
      case OrderStatus.ready:
        return 'Complete Order';
      default:
        return '';
    }
  }
}

class _OrderTab {
  final String title;
  final OrderStatus status;
  final int count;

  _OrderTab({
    required this.title,
    required this.status,
    required this.count,
  });
}

enum OrderStatus {
  pending('New'),
  preparing('Preparing'),
  ready('Ready'),
  completed('Completed'),
  cancelled('Cancelled');

  final String displayName;
  const OrderStatus(this.displayName);
}

class _Order {
  final String id;
  final String orderNumber;
  final String tableNumber;
  final OrderStatus status;
  final String timeAgo;
  final List<_OrderItem> items;
  final double total;

  _Order({
    required this.id,
    required this.orderNumber,
    required this.tableNumber,
    required this.status,
    required this.timeAgo,
    required this.items,
    required this.total,
  });
}

class _OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String? notes;

  _OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.notes,
  });
}
