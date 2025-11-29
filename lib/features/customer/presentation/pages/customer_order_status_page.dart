import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../l10n/app_localizations.dart';

class CustomerOrderStatusPage extends ConsumerStatefulWidget {
  final String restaurantSlug;
  final String tableId;
  final String orderId;

  const CustomerOrderStatusPage({
    super.key,
    required this.restaurantSlug,
    required this.tableId,
    required this.orderId,
  });

  @override
  ConsumerState<CustomerOrderStatusPage> createState() =>
      _CustomerOrderStatusPageState();
}

class _CustomerOrderStatusPageState
    extends ConsumerState<CustomerOrderStatusPage> {
  StreamSubscription? _orderSubscription;
  Map<String, dynamic>? _order;
  List<Map<String, dynamic>> _orderItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
    _subscribeToOrderUpdates();
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final supabase = Supabase.instance.client;

      final orderResult = await supabase
          .from('orders')
          .select('''
            *,
            tables!inner(table_number)
          ''')
          .eq('id', widget.orderId)
          .single();

      final itemsResult = await supabase
          .from('order_items')
          .select('*')
          .eq('order_id', widget.orderId)
          .order('created_at');

      setState(() {
        _order = orderResult;
        _orderItems = List<Map<String, dynamic>>.from(itemsResult);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading order: $e')),
        );
      }
    }
  }

  void _subscribeToOrderUpdates() {
    final supabase = Supabase.instance.client;

    _orderSubscription = supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', widget.orderId)
        .listen((data) {
          if (data.isNotEmpty) {
            setState(() => _order = data.first);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.orderStatus)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.orderStatus)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(l10n.orderNotFound),
            ],
          ),
        ),
      );
    }

    final status = _order!['status'] as String;
    final tableNumber = _order!['tables']?['table_number'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderStatus),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.go('/menu/${widget.restaurantSlug}/${widget.tableId}'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.order} #${_order!['order_number']}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Chip(
                          label: Text(tableNumber),
                          avatar: const Icon(Icons.table_restaurant, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(_order!['created_at']),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Order status tracker
            _OrderStatusTracker(
              currentStatus: status,
              l10n: l10n,
            ),

            const SizedBox(height: 24),

            // Status message
            _StatusMessageCard(
              status: status,
              l10n: l10n,
            ),

            const SizedBox(height: 24),

            // Order items
            Text(
              l10n.orderItems,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...(_orderItems.map((item) => _OrderItemTile(item: item))),

            const SizedBox(height: 24),

            // Order summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: l10n.subtotal,
                      value:
                          '\$${double.parse(_order!['subtotal'].toString()).toStringAsFixed(2)}',
                    ),
                    _SummaryRow(
                      label: l10n.tax,
                      value:
                          '\$${double.parse(_order!['tax'].toString()).toStringAsFixed(2)}',
                    ),
                    const Divider(),
                    _SummaryRow(
                      label: l10n.total,
                      value:
                          '\$${double.parse(_order!['total'].toString()).toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          _order!['payment_status'] == 'paid'
                              ? Icons.check_circle
                              : Icons.pending,
                          size: 16,
                          color: _order!['payment_status'] == 'paid'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _order!['payment_status'] == 'paid'
                              ? l10n.paid
                              : l10n.payAtCounter,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _order!['payment_status'] == 'paid'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // New order button
            if (status == 'served' || status == 'completed')
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go(
                    '/menu/${widget.restaurantSlug}/${widget.tableId}',
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newOrder),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime).toLocal();
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _OrderStatusTracker extends StatelessWidget {
  final String currentStatus;
  final AppLocalizations l10n;

  const _OrderStatusTracker({
    required this.currentStatus,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = ['pending', 'confirmed', 'preparing', 'ready', 'served'];
    final currentIndex = statuses.indexOf(currentStatus);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: List.generate(statuses.length, (index) {
                final isCompleted = index <= currentIndex;
                final isCurrent = index == currentIndex;

                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          border: isCurrent
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: Icon(
                          _getStatusIcon(statuses[index]),
                          size: 16,
                          color: isCompleted
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (index < statuses.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index < currentIndex
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: statuses.map((status) {
                return Expanded(
                  child: Text(
                    _getStatusLabel(status, l10n),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: status == currentStatus
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: status == currentStatus
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.done_all;
      case 'served':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  String _getStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'pending':
        return l10n.pending;
      case 'confirmed':
        return l10n.confirmed;
      case 'preparing':
        return l10n.preparing;
      case 'ready':
        return l10n.ready;
      case 'served':
        return l10n.served;
      default:
        return status;
    }
  }
}

class _StatusMessageCard extends StatelessWidget {
  final String status;
  final AppLocalizations l10n;

  const _StatusMessageCard({
    required this.status,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String message;
    IconData icon;
    Color color;

    switch (status) {
      case 'pending':
        message = l10n.orderPendingMessage;
        icon = Icons.hourglass_top;
        color = Colors.orange;
        break;
      case 'confirmed':
        message = l10n.orderConfirmedMessage;
        icon = Icons.thumb_up;
        color = Colors.blue;
        break;
      case 'preparing':
        message = l10n.orderPreparingMessage;
        icon = Icons.restaurant;
        color = Colors.purple;
        break;
      case 'ready':
        message = l10n.orderReadyMessage;
        icon = Icons.notifications_active;
        color = Colors.green;
        break;
      case 'served':
      case 'completed':
        message = l10n.orderServedMessage;
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'cancelled':
        message = l10n.orderCancelledMessage;
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        message = '';
        icon = Icons.help;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            '${item['quantity']}x',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(item['item_name'] ?? ''),
        subtitle: item['special_requests']?.isNotEmpty == true
            ? Text(
                item['special_requests'],
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              )
            : null,
        trailing: Text(
          '\$${double.parse(item['total_price'].toString()).toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
