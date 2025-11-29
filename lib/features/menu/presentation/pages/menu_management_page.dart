import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/models/menu.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/language_service.dart';
import '../../../../services/menu_service.dart';
import '../../../../services/restaurant_service.dart';

class MenuManagementPage extends ConsumerStatefulWidget {
  const MenuManagementPage({super.key});

  @override
  ConsumerState<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends ConsumerState<MenuManagementPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _lastCategoryCount = 0;
  String? _restaurantId;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _initTabController(int length) {
    // Only recreate if length actually changed
    if (length != _lastCategoryCount) {
      _tabController?.dispose();
      _tabController = null;
      _lastCategoryCount = length;
    }
    
    if (_tabController == null && length > 0) {
      _tabController = TabController(length: length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurantAsync = ref.watch(currentRestaurantProvider);

    return restaurantAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (restaurant) {
        if (restaurant == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No restaurant found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(currentRestaurantProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        _restaurantId = restaurant.id;
        final categoriesAsync = ref.watch(menuCategoriesProvider(restaurant.id));

        return categoriesAsync.when(
          loading: () => Scaffold(
            appBar: AppBar(title: const Text('Menu')),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.menu)),
            body: Center(child: Text('Error loading menu: $error')),
          ),
          data: (categories) => _buildMainContent(theme, restaurant.id, categories),
        );
      },
    );
  }

  Widget _buildMainContent(ThemeData theme, String restaurantId, List<MenuCategory> categories) {
    _initTabController(categories.length);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'AI Menu Creator',
            onPressed: () => context.push(Routes.adminAiMenuCreator),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, restaurantId),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'ai_creator',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('AI Menu Creator'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'add_category',
                child: Row(
                  children: [
                    Icon(Icons.category),
                    SizedBox(width: 8),
                    Text('Add Category'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reorder',
                child: Row(
                  children: [
                    Icon(Icons.reorder),
                    SizedBox(width: 8),
                    Text('Reorder Categories'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'saved_menus',
                child: Row(
                  children: [
                    Icon(Icons.bookmark, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Saved Menus'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'change_language',
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Change Language'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Refresh Menu'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: categories.isEmpty
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: categories.map((cat) {
                  final lang = ref.watch(appLocaleProvider).languageCode;
                  final name = cat.translations[lang]?.name ?? cat.translations['en']?.name ?? 'Category';
                  return Tab(
                    child: Row(
                      children: [
                        Text(name),
                        const SizedBox(width: 8),
                        _CategoryItemCount(categoryId: cat.id),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
      body: categories.isEmpty
          ? _buildEmptyState(theme)
          : TabBarView(
              controller: _tabController,
              children: categories
                  .map((cat) => _MenuItemsList(
                        category: cat,
                        restaurantId: restaurantId,
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(categories),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  void _handleMenuAction(String value, String restaurantId) {
    switch (value) {
      case 'ai_creator':
        context.push(Routes.adminAiMenuCreator);
        break;
      case 'add_category':
        _showAddCategoryDialog();
        break;
      case 'reorder':
        break;
      case 'saved_menus':
        context.push(Routes.adminSavedMenus);
        break;
      case 'refresh':
        ref.invalidate(menuCategoriesProvider(restaurantId));
        break;
      case 'language':
        _showLanguageSelector();
        break;
    }
  }
  
  void _showLanguageSelector() {
    // Use the built-in helper from language_service
    showAppLanguageBottomSheet(context, ref);
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No menu items yet',
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your menu using AI or add items manually',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push(Routes.adminAiMenuCreator),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Create with AI'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Category Manually'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: _MenuSearchDelegate(ref: ref, restaurantId: _restaurantId ?? ''),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g., Appetizers, Main Courses',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              final menuService = ref.read(menuServiceProvider);
              try {
                await menuService.createCategory(
                  restaurantId: _restaurantId!,
                  name: nameController.text,
                );
                ref.invalidate(menuCategoriesProvider(_restaurantId!));
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(List<MenuCategory> categories) {
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a category first')),
      );
      return;
    }

    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategoryId = categories.first.id;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories.map((cat) {
                    final name = cat.translations['en']?.name ?? 'Category';
                    return DropdownMenuItem(value: cat.id, child: Text(name));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => selectedCategoryId = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'e.g., Margherita Pizza',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price', prefixText: '\$ '),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || priceController.text.isEmpty) return;
                final price = double.tryParse(priceController.text);
                if (price == null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Invalid price')),
                  );
                  return;
                }
                final menuService = ref.read(menuServiceProvider);
                try {
                  await menuService.createItem(
                    categoryId: selectedCategoryId,
                    restaurantId: _restaurantId!,
                    name: nameController.text,
                    price: price,
                    description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  );
                  ref.invalidate(menuItemsProvider(selectedCategoryId));
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItemCount extends ConsumerWidget {
  final String categoryId;
  const _CategoryItemCount({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(menuItemsProvider(categoryId));
    final theme = Theme.of(context);

    return itemsAsync.when(
      loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      error: (_, __) => const SizedBox(),
      data: (items) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('${items.length}', style: TextStyle(fontSize: 12, color: theme.primaryColor)),
      ),
    );
  }
}

class _MenuItemsList extends ConsumerWidget {
  final MenuCategory category;
  final String restaurantId;

  const _MenuItemsList({required this.category, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(menuItemsProvider(category.id));
    final theme = Theme.of(context);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No items in this category', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _MenuItemCard(
            item: items[index],
            theme: theme,
            onTap: () => _showItemDetails(context, ref, items[index]),
            onToggleAvailability: () async {
              final menuService = ref.read(menuServiceProvider);
              await menuService.toggleItemAvailability(items[index].id, !items[index].isAvailable);
              ref.invalidate(menuItemsProvider(category.id));
            },
            onDelete: () => _confirmDelete(context, ref, items[index]),
          ),
        );
      },
    );
  }

  void _showItemDetails(BuildContext context, WidgetRef ref, MenuItem item) {
    final currentLang = ref.read(appLocaleProvider).languageCode;
    final translation = item.translations[currentLang] ?? item.translations['en'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(translation?.name ?? 'Unnamed Item', style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (translation?.description != null) ...[
                  const SizedBox(height: 8),
                  Text(translation!.description!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditDialog(context, ref, item);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final menuService = ref.read(menuServiceProvider);
                          await menuService.toggleItemAvailability(item.id, !item.isAvailable);
                          ref.invalidate(menuItemsProvider(category.id));
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: Icon(item.isAvailable ? Icons.visibility_off : Icons.visibility),
                        label: Text(item.isAvailable ? 'Unavailable' : 'Available'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, MenuItem item) {
    final translation = item.translations['en'];
    final nameController = TextEditingController(text: translation?.name ?? '');
    final priceController = TextEditingController(text: item.price.toString());
    final descriptionController = TextEditingController(text: translation?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price', prefixText: '\$ '),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final price = double.tryParse(priceController.text);
              if (price == null) return;
              final menuService = ref.read(menuServiceProvider);
              await menuService.updateItem(
                id: item.id,
                name: nameController.text,
                price: price,
                description: descriptionController.text.isEmpty ? null : descriptionController.text,
              );
              ref.invalidate(menuItemsProvider(category.id));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MenuItem item) {
    final currentLang = ref.read(appLocaleProvider).languageCode;
    final translation = item.translations[currentLang] ?? item.translations['en'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${translation?.name ?? 'this item'}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final menuService = ref.read(menuServiceProvider);
              await menuService.deleteItem(item.id);
              ref.invalidate(menuItemsProvider(category.id));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends ConsumerWidget {
  final MenuItem item;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onToggleAvailability;
  final VoidCallback onDelete;

  const _MenuItemCard({
    required this.item,
    required this.theme,
    required this.onTap,
    required this.onToggleAvailability,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(appLocaleProvider).languageCode;
    final translation = item.translations[currentLang] ?? item.translations['en'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: item.imageUrl != null
                      ? DecorationImage(image: NetworkImage(item.imageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: item.imageUrl == null
                    ? Center(child: Icon(Icons.restaurant, color: Colors.grey[400], size: 32))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            translation?.name ?? 'Unnamed Item',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (!item.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Unavailable',
                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                    if (translation?.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        translation!.description!,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(item.isAvailable ? Icons.visibility : Icons.visibility_off, size: 20),
                              onPressed: onToggleAvailability,
                              tooltip: item.isAvailable ? 'Mark unavailable' : 'Mark available',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: onDelete,
                              color: Colors.red,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
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
}

class _MenuSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  final String restaurantId;

  _MenuSearchDelegate({required this.ref, required this.restaurantId});

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    if (query.isEmpty) return const Center(child: Text('Search for menu items...'));

    final itemsAsync = ref.watch(allMenuItemsProvider(restaurantId));

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (items) {
        final filtered = items.where((item) {
          final name = item.translations['en']?.name.toLowerCase() ?? '';
          final desc = item.translations['en']?.description?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) || desc.contains(query.toLowerCase());
        }).toList();

        if (filtered.isEmpty) return Center(child: Text('No results for "$query"'));

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            final translation = item.translations['en'];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.restaurant)),
              title: Text(translation?.name ?? 'Unnamed'),
              subtitle: Text(translation?.description ?? ''),
              trailing: Text('\$${item.price.toStringAsFixed(2)}'),
              onTap: () => close(context, item.id),
            );
          },
        );
      },
    );
  }
}
