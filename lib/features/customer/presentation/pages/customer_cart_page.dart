import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';

class CustomerCartPage extends ConsumerWidget {
  final String restaurantSlug;
  final String tableId;

  const CustomerCartPage({
    super.key,
    required this.restaurantSlug,
    required this.tableId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context, l10n)
          : Column(
              children: [
                // Cart items list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartItemCard(
                        item: item,
                        onQuantityChanged: (newQuantity) {
                          if (newQuantity <= 0) {
                            cartNotifier.removeItem(item.menuItemId);
                          } else {
                            cartNotifier.updateQuantity(
                              item.menuItemId,
                              newQuantity,
                            );
                          }
                        },
                        onRemove: () {
                          cartNotifier.removeItem(item.menuItemId);
                        },
                        onSpecialRequestsChanged: (notes) {
                          cartNotifier.updateSpecialRequests(
                            item.menuItemId,
                            notes,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Order notes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: l10n.orderNotes,
                      hintText: l10n.orderNotesHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                    ),
                    maxLines: 2,
                    onChanged: (value) {
                      cartNotifier.setOrderNotes(value);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Order summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subtotal
                        _SummaryRow(
                          label: l10n.subtotal,
                          value: '\$${cart.subtotal.toStringAsFixed(2)}',
                        ),

                        // Tax (estimated 10%)
                        _SummaryRow(
                          label: l10n.tax,
                          value: '\$${cart.tax.toStringAsFixed(2)}',
                        ),

                        const Divider(),

                        // Total
                        _SummaryRow(
                          label: l10n.total,
                          value: '\$${cart.total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),

                        const SizedBox(height: 16),

                        // Place Order Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              _showOrderConfirmation(
                                context,
                                ref,
                                l10n,
                                cart.total,
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(l10n.placeOrder),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.cartEmpty,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cartEmptyDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.restaurant_menu),
            label: Text(l10n.browseMenu),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    double total,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.confirmOrder,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(l10n.confirmOrderDescription),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.total,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _placeOrder(context, ref, l10n);
                    },
                    child: Text(l10n.confirmAndOrder),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final cart = ref.read(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.placingOrder),
            ],
          ),
        ),
      ),
    );

    try {
      // Create order via service
      final orderId = await cartNotifier.placeOrder(
        restaurantSlug: restaurantSlug,
        tableId: tableId,
      );

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        // Clear cart and navigate to order status
        cartNotifier.clearCart();
        context.go('/menu/$restaurantSlug/$tableId/order/$orderId');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.orderFailed}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _CartItemCard extends StatefulWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final ValueChanged<String> onSpecialRequestsChanged;

  const _CartItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onSpecialRequestsChanged,
  });

  @override
  State<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<_CartItemCard> {
  bool _showNotes = false;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.item.specialRequests);
    _showNotes = widget.item.specialRequests?.isNotEmpty == true;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item image
                if (widget.item.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.item.imageUrl!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.restaurant),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.restaurant),
                  ),

                const SizedBox(width: 12),

                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.item.unitPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Remove button
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onRemove,
                  iconSize: 20,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Quantity controls and total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity selector
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            widget.onQuantityChanged(widget.item.quantity - 1),
                        iconSize: 18,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                      Text(
                        '${widget.item.quantity}',
                        style: theme.textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            widget.onQuantityChanged(widget.item.quantity + 1),
                        iconSize: 18,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ],
                  ),
                ),

                // Item total
                Text(
                  '\$${widget.item.totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Special requests toggle
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showNotes = !_showNotes;
                });
              },
              icon: Icon(
                _showNotes ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(l10n.specialRequests),
            ),

            // Special requests field
            if (_showNotes)
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: l10n.specialRequestsHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
                onChanged: widget.onSpecialRequestsChanged,
              ),
          ],
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
