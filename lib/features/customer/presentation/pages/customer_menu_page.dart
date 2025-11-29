import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerMenuPage extends ConsumerStatefulWidget {
  final String restaurantSlug;
  final String tableId;

  const CustomerMenuPage({
    super.key,
    required this.restaurantSlug,
    required this.tableId,
  });

  @override
  ConsumerState<CustomerMenuPage> createState() => _CustomerMenuPageState();
}

class _CustomerMenuPageState extends ConsumerState<CustomerMenuPage> {
  String _selectedCategory = 'all';
  String _selectedLanguage = 'en';
  final List<_CartItem> _cart = [];
  bool _isLoading = true;

  final List<_Language> _languages = [
    _Language(code: 'en', name: 'English', flag: '🇺🇸'),
    _Language(code: 'es', name: 'Español', flag: '🇪🇸'),
    _Language(code: 'it', name: 'Italiano', flag: '🇮🇹'),
    _Language(code: 'tr', name: 'Türkçe', flag: '🇹🇷'),
    _Language(code: 'ru', name: 'Русский', flag: '🇷🇺'),
    _Language(code: 'zh', name: '中文', flag: '🇨🇳'),
    _Language(code: 'de', name: 'Deutsch', flag: '🇩🇪'),
    _Language(code: 'fr', name: 'Français', flag: '🇫🇷'),
  ];

  // Mock data
  final List<_Category> _categories = [
    _Category(id: '1', name: 'Appetizers', icon: Icons.restaurant),
    _Category(id: '2', name: 'Main Courses', icon: Icons.dinner_dining),
    _Category(id: '3', name: 'Desserts', icon: Icons.cake),
    _Category(id: '4', name: 'Beverages', icon: Icons.local_bar),
  ];

  final List<_MenuItem> _menuItems = [
    _MenuItem(
      id: '1',
      name: 'Grilled Salmon',
      description: 'Fresh Atlantic salmon with herbs and lemon butter sauce',
      price: 24.99,
      categoryId: '2',
      imageUrl: null,
      hasVideo: true,
    ),
    _MenuItem(
      id: '2',
      name: 'Caesar Salad',
      description: 'Crisp romaine lettuce with parmesan and croutons',
      price: 12.99,
      categoryId: '1',
      imageUrl: null,
      hasVideo: false,
    ),
    _MenuItem(
      id: '3',
      name: 'Tiramisu',
      description: 'Classic Italian coffee-flavored dessert',
      price: 8.99,
      categoryId: '3',
      imageUrl: null,
      hasVideo: true,
    ),
    _MenuItem(
      id: '4',
      name: 'Sparkling Water',
      description: 'Premium Italian sparkling water',
      price: 4.99,
      categoryId: '4',
      imageUrl: null,
      hasVideo: false,
    ),
    _MenuItem(
      id: '5',
      name: 'Margherita Pizza',
      description: 'Traditional pizza with fresh mozzarella and basil',
      price: 18.99,
      categoryId: '2',
      imageUrl: null,
      hasVideo: true,
    ),
    _MenuItem(
      id: '6',
      name: 'Bruschetta',
      description: 'Toasted bread topped with tomatoes, garlic, and basil',
      price: 9.99,
      categoryId: '1',
      imageUrl: null,
      hasVideo: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    // TODO: Load menu from Supabase
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  List<_MenuItem> get _filteredItems {
    if (_selectedCategory == 'all') return _menuItems;
    return _menuItems.where((item) => item.categoryId == _selectedCategory).toList();
  }

  int get _cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  
  double get _cartTotal => _cart.fold(
    0.0, 
    (sum, item) => sum + (item.menuItem.price * item.quantity),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.primaryColor),
              const SizedBox(height: 16),
              Text(
                'Loading menu...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Restaurant'),
            Text(
              'Table ${widget.tableId.replaceAll('table-', '')}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          // Language selector
          PopupMenuButton<String>(
            initialValue: _selectedLanguage,
            onSelected: (value) {
              setState(() => _selectedLanguage = value);
            },
            icon: Text(
              _languages.firstWhere((l) => l.code == _selectedLanguage).flag,
              style: const TextStyle(fontSize: 24),
            ),
            itemBuilder: (context) => _languages
                .map((lang) => PopupMenuItem(
                      value: lang.code,
                      child: Row(
                        children: [
                          Text(lang.flag, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(lang.name),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            height: 56,
            color: theme.primaryColor.withOpacity(0.05),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildCategoryChip(theme, 'all', 'All', null),
                ..._categories.map((cat) => _buildCategoryChip(
                  theme,
                  cat.id,
                  cat.name,
                  cat.icon,
                )),
              ],
            ),
          ),
          
          // Menu items
          Expanded(
            child: isWideScreen
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) => 
                        _buildMenuItemCard(theme, _filteredItems[index]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) => 
                        _buildMenuItemCard(theme, _filteredItems[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: FilledButton(
                  onPressed: _showCart,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('$_cartItemCount'),
                      ),
                      const SizedBox(width: 12),
                      const Text('View Cart'),
                      const Spacer(),
                      Text('\$${_cartTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCategoryChip(
    ThemeData theme,
    String id,
    String name,
    IconData? icon,
  ) {
    final isSelected = _selectedCategory == id;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = id);
        },
        avatar: icon != null
            ? Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : theme.primaryColor,
              )
            : null,
        label: Text(name),
        selectedColor: theme.primaryColor,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(ThemeData theme, _MenuItem item) {
    final cartItem = _cart.where((c) => c.menuItem.id == item.id).firstOrNull;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showItemDetails(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Video
              GestureDetector(
                onTap: item.hasVideo ? () => _playVideo(item) : null,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.restaurant,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                      if (item.hasVideo)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (cartItem != null)
                          Container(
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () => _updateQuantity(item, -1),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                  color: theme.primaryColor,
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () => _updateQuantity(item, 1),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                  color: theme.primaryColor,
                                ),
                              ],
                            ),
                          )
                        else
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: theme.primaryColor,
                            ),
                            onPressed: () => _addToCart(item),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(_MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ItemDetailsSheet(
        item: item,
        onAddToCart: (quantity, notes) {
          Navigator.pop(context);
          _addToCart(item, quantity: quantity, notes: notes);
        },
        onPlayVideo: item.hasVideo ? () => _playVideo(item) : null,
      ),
    );
  }

  void _playVideo(_MenuItem item) {
    // TODO: Play video in full screen
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white.withOpacity(0.5),
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Video: ${item.name}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '(Video player placeholder)',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(_MenuItem item, {int quantity = 1, String? notes}) {
    setState(() {
      final existingIndex = _cart.indexWhere((c) => c.menuItem.id == item.id);
      if (existingIndex >= 0) {
        _cart[existingIndex] = _CartItem(
          menuItem: item,
          quantity: _cart[existingIndex].quantity + quantity,
          notes: notes ?? _cart[existingIndex].notes,
        );
      } else {
        _cart.add(_CartItem(menuItem: item, quantity: quantity, notes: notes));
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _updateQuantity(_MenuItem item, int delta) {
    setState(() {
      final index = _cart.indexWhere((c) => c.menuItem.id == item.id);
      if (index >= 0) {
        final newQuantity = _cart[index].quantity + delta;
        if (newQuantity <= 0) {
          _cart.removeAt(index);
        } else {
          _cart[index] = _CartItem(
            menuItem: item,
            quantity: newQuantity,
            notes: _cart[index].notes,
          );
        }
      }
    });
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CartSheet(
        cart: _cart,
        tableId: widget.tableId,
        onUpdateQuantity: (item, delta) {
          _updateQuantity(item, delta);
          if (_cart.isEmpty) Navigator.pop(context);
        },
        onPlaceOrder: _placeOrder,
      ),
    );
  }

  void _placeOrder() {
    Navigator.pop(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Placing order...'),
          ],
        ),
      ),
    );

    // Simulate order placement
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading
      
      setState(() => _cart.clear());
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
          title: const Text('Order Placed!'),
          content: const Text(
            'Your order has been sent to the kitchen. '
            'We\'ll notify you when it\'s ready.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}

class _ItemDetailsSheet extends StatefulWidget {
  final _MenuItem item;
  final Function(int quantity, String? notes) onAddToCart;
  final VoidCallback? onPlayVideo;

  const _ItemDetailsSheet({
    required this.item,
    required this.onAddToCart,
    this.onPlayVideo,
  });

  @override
  State<_ItemDetailsSheet> createState() => _ItemDetailsSheetState();
}

class _ItemDetailsSheetState extends State<_ItemDetailsSheet> {
  int _quantity = 1;
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
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
                // Image/Video
                GestureDetector(
                  onTap: widget.onPlayVideo,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.restaurant,
                            color: Colors.grey[400],
                            size: 64,
                          ),
                        ),
                        if (widget.item.hasVideo)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$${widget.item.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  widget.item.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Notes
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Special instructions',
                    hintText: 'e.g., no onions, extra sauce',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                
                // Quantity selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      iconSize: 32,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_quantity',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _quantity++),
                      iconSize: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Add to cart button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: FilledButton(
                onPressed: () {
                  widget.onAddToCart(
                    _quantity,
                    _notesController.text.isNotEmpty
                        ? _notesController.text
                        : null,
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(
                  'Add to Cart - \$${(widget.item.price * _quantity).toStringAsFixed(2)}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSheet extends StatelessWidget {
  final List<_CartItem> cart;
  final String tableId;
  final Function(_MenuItem item, int delta) onUpdateQuantity;
  final VoidCallback onPlaceOrder;

  const _CartSheet({
    required this.cart,
    required this.tableId,
    required this.onUpdateQuantity,
    required this.onPlaceOrder,
  });

  double get _subtotal => cart.fold(
    0.0,
    (sum, item) => sum + (item.menuItem.price * item.quantity),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Order',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Table ${tableId.replaceAll('table-', '')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.menuItem.name,
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
                            Text(
                              '\$${item.menuItem.price.toStringAsFixed(2)} each',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: () => onUpdateQuantity(item.menuItem, -1),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => onUpdateQuantity(item.menuItem, 1),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${(item.menuItem.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('\$${_subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_subtotal.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: onPlaceOrder,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text('Place Order'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Language {
  final String code;
  final String name;
  final String flag;

  _Language({required this.code, required this.name, required this.flag});
}

class _Category {
  final String id;
  final String name;
  final IconData icon;

  _Category({required this.id, required this.name, required this.icon});
}

class _MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String? imageUrl;
  final bool hasVideo;

  _MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.imageUrl,
    required this.hasVideo,
  });
}

class _CartItem {
  final _MenuItem menuItem;
  final int quantity;
  final String? notes;

  _CartItem({
    required this.menuItem,
    required this.quantity,
    this.notes,
  });
}
