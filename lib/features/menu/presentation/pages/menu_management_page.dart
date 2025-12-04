import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/menu.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/background_ai_image_service.dart';
import '../../../../services/image_service.dart';
import '../../../../services/language_service.dart';
import '../../../../services/menu_service.dart';
import '../../../../services/notification_service.dart';
import '../../../../services/restaurant_service.dart';
import '../../../../services/translation_service.dart';

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
  late final ProviderContainer _container;
  StreamSubscription<String>? _notificationSubscription;
  bool _isReorderMode = false;

  @override
  void initState() {
    super.initState();
    _container = ProviderScope.containerOf(context, listen: false);
    _setupNotificationListener();
    _checkPendingNotification();
  }
  
  void _setupNotificationListener() {
    _notificationSubscription = NotificationService.onNotificationTap.listen((payload) {
      _handleNotificationPayload(payload);
    });
  }
  
  void _checkPendingNotification() {
    // Check if app was launched from notification
    if (NotificationService.pendingPayload != null) {
      final payload = NotificationService.pendingPayload!;
      NotificationService.pendingPayload = null;
      // Delay to allow the widget tree to build
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _handleNotificationPayload(payload);
        }
      });
    }
  }
  
  void _handleNotificationPayload(String payload) {
    debugPrint('Handling notification payload: $payload');
    
    // Parse payload format: ai_image_complete:menuItemId:categoryId
    if (payload.startsWith('ai_image_complete:')) {
      final parts = payload.split(':');
      if (parts.length >= 3) {
        final menuItemId = parts[1];
        final categoryId = parts[2];
        _openEditItemFromNotification(menuItemId, categoryId);
      }
    }
    // Parse payload format: ai_menu_complete:resultId
    else if (payload.startsWith('ai_menu_complete:')) {
      final parts = payload.split(':');
      if (parts.length >= 2) {
        final resultId = parts[1];
        context.push('/admin/menu/ai-result/$resultId');
      }
    }
    // Parse payload format: ai_menu_error:resultId
    else if (payload.startsWith('ai_menu_error:')) {
      final parts = payload.split(':');
      if (parts.length >= 2) {
        final resultId = parts[1];
        context.push('/admin/menu/ai-result/$resultId');
      }
    }
  }
  
  Future<void> _openEditItemFromNotification(String menuItemId, String categoryId) async {
    debugPrint('Opening edit item from notification: $menuItemId, category: $categoryId');
    
    try {
      // Refresh the menu items for this category first
      ref.invalidate(menuItemsProvider(categoryId));
      
      // Wait a bit for the data to load
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Fetch the menu item
      final menuService = ref.read(menuServiceProvider);
      final item = await menuService.getItemById(menuItemId);
      
      if (item != null && mounted) {
        // Show the edit sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => _EditItemSheet(
            item: item,
            categoryId: categoryId,
          ),
        );
      } else {
        debugPrint('Could not find menu item: $menuItemId');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not find the menu item'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error opening edit item from notification: $e');
    }
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
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

    // If in reorder mode, show the reorder UI
    if (_isReorderMode) {
      return _buildReorderUI(theme, restaurantId, categories, l10n);
    }

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
                    Text('Reorder Menu'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'fix_order',
                child: Row(
                  children: [
                    Icon(Icons.sort, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Fix Sort Orders'),
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
        setState(() {
          _isReorderMode = true;
        });
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
      case 'fix_order':
        _fixSortOrders(restaurantId);
        break;
    }
  }

  Future<void> _fixSortOrders(String restaurantId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fix Sort Orders'),
        content: const Text(
          'This will renumber all categories and items based on their current order. '
          'Use this if your menu appears in the wrong order after migration or import.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Fix Order'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Show loading overlay
    late final OverlayEntry loadingOverlay;
    loadingOverlay = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black54,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Fixing sort orders...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(loadingOverlay);

    try {
      final menuService = ref.read(menuServiceProvider);
      await menuService.fixSortOrders(restaurantId);

      // Refresh data
      ref.invalidate(menuCategoriesProvider(restaurantId));
      
      // Also invalidate items for all categories
      final categories = await ref.read(menuCategoriesProvider(restaurantId).future);
      for (final cat in categories) {
        ref.invalidate(menuItemsProvider(cat.id));
      }

      loadingOverlay.remove();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sort orders fixed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      loadingOverlay.remove();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _showLanguageSelector() {
    // Use the built-in helper from language_service
    showAppLanguageBottomSheet(context, ref);
  }

  Widget _buildReorderUI(ThemeData theme, String restaurantId, List<MenuCategory> categories, AppLocalizations l10n) {
    return _ReorderableMenuList(
      categories: categories,
      restaurantId: restaurantId,
      onCancel: () => setState(() => _isReorderMode = false),
      onSave: () async {
        // Refresh all data after saving
        ref.invalidate(menuCategoriesProvider(restaurantId));
        for (final category in categories) {
          ref.invalidate(menuItemsProvider(category.id));
        }
        setState(() => _isReorderMode = false);
      },
      menuService: ref.read(menuServiceProvider),
    );
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
                final translationService = ref.read(translationServiceProvider);
                final currentLang = ref.read(appLocaleProvider).languageCode;
                try {
                  // Create the item first
                  final createdItem = await menuService.createItem(
                    categoryId: selectedCategoryId,
                    restaurantId: _restaurantId!,
                    name: nameController.text,
                    price: price,
                    description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  );
                  
                  // Add translation for current language
                  await menuService.addItemTranslation(
                    itemId: createdItem.id,
                    languageCode: currentLang,
                    name: nameController.text,
                    description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  );
                  
                  ref.invalidate(menuItemsProvider(selectedCategoryId));
                  if (ctx.mounted) Navigator.pop(ctx);
                  
                  // Translate in background (don't await)
                  _translateNewItem(
                    container: _container,
                    translationService: translationService,
                    menuService: menuService,
                    itemId: createdItem.id,
                    name: nameController.text,
                    description: descriptionController.text.isEmpty ? null : descriptionController.text,
                    sourceLanguage: currentLang,
                    categoryId: selectedCategoryId,
                  );
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
  
  /// Translate a newly created item to all supported languages in the background
  Future<void> _translateNewItem({
    required ProviderContainer container,
    required TranslationService translationService,
    required MenuService menuService,
    required String itemId,
    required String name,
    String? description,
    required String sourceLanguage,
    required String categoryId,
  }) async {
    try {
      debugPrint('Starting background translation for item: $name');
      final translations = await translationService.translateMenuItem(
        name: name,
        description: description,
        sourceLanguage: sourceLanguage,
      );
      
      if (translations.isNotEmpty) {
        await menuService.saveItemTranslations(
          itemId: itemId,
          translations: translations,
        );
        debugPrint('Translations saved for item: $name');
        // Refresh the menu items list to show updated translations
        container.invalidate(menuItemsProvider(categoryId));
      }
    } catch (e) {
      debugPrint('Background translation failed: $e');
      // Silently fail - the item was created, translations just won't be available
    }
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

  void _showItemDetails(BuildContext parentContext, WidgetRef ref, MenuItem item) {
    final currentLang = ref.read(appLocaleProvider).languageCode;
    final translation = item.translations[currentLang] ?? item.translations['en'];
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => DraggableScrollableSheet(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.variants.isNotEmpty)
                          Text(
                            'from',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                            ),
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
                  ],
                ),
                if (translation?.description != null) ...[
                  const SizedBox(height: 8),
                  Text(translation!.description!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                ],
                // Show variants if available
                if (item.variants.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Options',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...item.variants.map((variant) {
                    final variantName = variant.translations[currentLang]?.name ?? 
                                       variant.translations['en']?.name ?? 'Option';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              variantName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${variant.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          // Use Future.delayed to ensure the bottom sheet is fully closed
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (parentContext.mounted) {
                              _showEditDialog(parentContext, ref, item);
                            }
                          });
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
                          if (sheetContext.mounted) Navigator.pop(sheetContext);
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

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, MenuItem item) async {
    // Fetch fresh data from the database to get the latest AI-generated images
    final menuService = ref.read(menuServiceProvider);
    final freshItem = await menuService.getItemById(item.id);
    
    if (!context.mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditItemSheet(
        item: freshItem ?? item,  // Use fresh data if available, otherwise fall back
        categoryId: category.id,
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
              _MenuItemImage(imageUrl: item.imageUrl),
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
                    // Show variants if available
                    if (item.variants.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: item.variants.map((variant) {
                          final variantName = variant.translations[currentLang]?.name ?? 
                                             variant.translations['en']?.name ?? 'Option';
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.orange.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  variantName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '\$${variant.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Show price with "from" if variants exist
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.variants.isNotEmpty)
                              Text(
                                'from',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.primaryColor.withOpacity(0.7),
                                ),
                              ),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

class _MenuItemImage extends ConsumerWidget {
  final String? imageUrl;

  const _MenuItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.watch(imageServiceProvider);
    final placeholder = Center(child: Icon(Icons.restaurant, color: Colors.grey[400], size: 32));

    Widget buildPlaceholder() => Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: placeholder,
        );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return buildPlaceholder();
    }

    if (imageService.isBase64DataUri(imageUrl)) {
      final bytes = imageService.decodeBase64DataUri(imageUrl!);
      if (bytes == null) {
        return buildPlaceholder();
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
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

// ============================================================
// EDIT ITEM SHEET - Full screen bottom sheet for editing items
// ============================================================

class _EditItemSheet extends ConsumerStatefulWidget {
  final MenuItem item;
  final String categoryId;

  const _EditItemSheet({
    required this.item,
    required this.categoryId,
  });

  @override
  ConsumerState<_EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends ConsumerState<_EditItemSheet> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late final ProviderContainer _container;
  
  // Store original values to detect changes
  late String _originalName;
  late String _originalDescription;
  
  // Image state
  String? _currentImageUrl;
  String? _originalUploadedImage; // Keep track of the original uploaded image
  XFile? _newImageFile;
  bool _isUploadingImage = false;
  bool _imageDeleted = false;
  bool _showImageOverlay = false; // Toggle for image action buttons overlay
  
  // AI-generated images state
  List<String> _aiGeneratedImages = [];
  int _selectedAiImageIndex = 0;
  bool _isGeneratingAiImage = false;
  
  // List of variants (mutable for add/delete)
  late List<_VariantEditData> _variants;
  
  // Track deleted variant IDs
  final List<String> _deletedVariantIds = [];
  
  // Track new variants (not yet in database)
  final List<_VariantEditData> _newVariants = [];
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _container = ProviderScope.containerOf(context, listen: false);
    final currentLang = ref.read(appLocaleProvider).languageCode;
    final translation = widget.item.translations[currentLang] ?? widget.item.translations['en'];
    
    _originalName = translation?.name ?? '';
    _originalDescription = translation?.description ?? '';
    
    _nameController = TextEditingController(text: _originalName);
    _priceController = TextEditingController(text: widget.item.price.toString());
    _descriptionController = TextEditingController(text: _originalDescription);
    
    // Initialize AI-generated images (these are separate from original)
    _aiGeneratedImages = List<String>.from(widget.item.aiGeneratedImages);
    _selectedAiImageIndex = widget.item.selectedAiImageIndex;
    
    // Load the original image from the dedicated field
    // If originalImageUrl exists, use it. Otherwise, fall back to imageUrl if it's not an AI image.
    if (widget.item.originalImageUrl != null && widget.item.originalImageUrl!.isNotEmpty) {
      _originalUploadedImage = widget.item.originalImageUrl;
    } else if (widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty) {
      // Legacy support: if there's no originalImageUrl but imageUrl exists and is NOT an AI image
      if (!_aiGeneratedImages.contains(widget.item.imageUrl)) {
        _originalUploadedImage = widget.item.imageUrl;
      }
    }
    
    // Set the current display image (imageUrl stores what's shown in menu)
    _currentImageUrl = widget.item.imageUrl;
    
    // Initialize variants
    _variants = widget.item.variants.map((v) {
      final variantTranslation = v.translations[currentLang] ?? v.translations['en'];
      return _VariantEditData(
        id: v.id,
        nameController: TextEditingController(text: variantTranslation?.name ?? ''),
        priceController: TextEditingController(text: v.price.toString()),
        isNew: false,
      );
    }).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    for (final v in _variants) {
      v.nameController.dispose();
      v.priceController.dispose();
    }
    super.dispose();
  }

  void _addVariant() {
    setState(() {
      final newVariant = _VariantEditData(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        nameController: TextEditingController(),
        priceController: TextEditingController(text: '0'),
        isNew: true,
      );
      _variants.add(newVariant);
      _newVariants.add(newVariant);
    });
  }

  void _deleteVariant(int index) {
    final variant = _variants[index];
    setState(() {
      _variants.removeAt(index);
      if (!variant.isNew) {
        _deletedVariantIds.add(variant.id);
      } else {
        _newVariants.remove(variant);
      }
      variant.nameController.dispose();
      variant.priceController.dispose();
    });
  }

  /// Show image source selection dialog
  Future<void> _showImagePicker() async {
    final imageService = ref.read(imageServiceProvider);
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    
    if (source == null) return;
    
    setState(() => _isUploadingImage = true);
    
    try {
      XFile? pickedFile;
      if (source == ImageSource.gallery) {
        pickedFile = await imageService.pickImageFromGallery();
      } else {
        pickedFile = await imageService.pickImageFromCamera();
      }
      
      if (pickedFile != null) {
        // Convert to base64 and set as original image
        final base64Image = await imageService.convertToBase64DataUri(pickedFile);
        if (mounted && base64Image.isNotEmpty) {
          // Update local state immediately
          setState(() {
            _originalUploadedImage = base64Image;
            _currentImageUrl = base64Image; // Auto-select the new original
            _newImageFile = null;
            _imageDeleted = false;
          });
          
          // *** AUTO-SAVE: Immediately save to database ***
          try {
            final menuService = ref.read(menuServiceProvider);
            await menuService.updateItem(
              id: widget.item.id,
              originalImageUrl: base64Image,
              imageUrl: base64Image, // Also set as main image initially
            );
            
            // Refresh the menu items list
            ref.invalidate(menuItemsProvider(widget.categoryId));
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Original image uploaded and saved!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            debugPrint('Error saving original image: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Image displayed but save failed: $e'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  /// Generate AI Image using Gemini
  Future<void> _generateAIImage() async {
    // Must have an original image to generate from
    if (_originalUploadedImage == null || _originalUploadedImage!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an original image first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // ALWAYS use English name and description for AI prompts for consistency
    final englishTranslation = widget.item.translations['en'];
    final dishNameEnglish = englishTranslation?.name ?? _nameController.text.trim();
    final descriptionEnglish = englishTranslation?.description ?? _descriptionController.text.trim();
    
    if (dishNameEnglish.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a dish name first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() => _isGeneratingAiImage = true);
    
    try {
      // Use BackgroundAIImageService for auto-save and background processing
      final backgroundService = ref.read(backgroundAIImageServiceProvider);
      
      // Start background job - this will continue even if user closes the sheet
      final jobId = await backgroundService.startGenerationJob(
        menuItemId: widget.item.id,
        categoryId: widget.categoryId,
        dishNameEnglish: dishNameEnglish,
        descriptionEnglish: descriptionEnglish.isEmpty ? null : descriptionEnglish,
        referenceImageBase64: _originalUploadedImage!,
      );
      
      debugPrint('Started AI image generation job: $jobId');
      
      // Show notification that generation started
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI image generation started. You can close this - it will continue in background.'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 4),
          ),
        );
      }
      
      // Listen for completion in background
      _listenForImageGeneration(jobId);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting AI image generation: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isGeneratingAiImage = false);
      }
    }
  }
  
  /// Listen for AI image generation completion and update UI
  void _listenForImageGeneration(String jobId) {
    final backgroundService = ref.read(backgroundAIImageServiceProvider);
    
    // Listen to the jobs stream for updates
    backgroundService.jobsStream.listen((jobs) {
      final job = jobs[jobId];
      if (job == null) return;
      
      if (job.status == AIImageJobStatus.completed && mounted) {
        // Image was generated and auto-saved to database
        // Reload the item to get the updated AI images
        _reloadItemData();
        
        setState(() => _isGeneratingAiImage = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI image generated and saved!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (job.status == AIImageJobStatus.failed && mounted) {
        setState(() => _isGeneratingAiImage = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI image failed: ${job.error ?? "Unknown error"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
  
  /// Reload item data from database to get updated AI images
  Future<void> _reloadItemData() async {
    try {
      // Invalidate the menu items provider to refresh the data
      ref.invalidate(menuItemsProvider(widget.categoryId));
      
      // Get the updated item
      final updatedItems = await ref.read(menuItemsProvider(widget.categoryId).future);
      final updatedItem = updatedItems.firstWhere(
        (item) => item.id == widget.item.id,
        orElse: () => widget.item,
      );
      
      // Update local state with new AI images
      if (mounted) {
        setState(() {
          _aiGeneratedImages = List<String>.from(updatedItem.aiGeneratedImages);
          _selectedAiImageIndex = updatedItem.selectedAiImageIndex;
          if (_aiGeneratedImages.isNotEmpty) {
            _currentImageUrl = _aiGeneratedImages[_selectedAiImageIndex.clamp(0, _aiGeneratedImages.length - 1)];
          }
        });
      }
    } catch (e) {
      debugPrint('Error reloading item data: $e');
    }
  }
  
  /// Show confirmation dialog before generating AI image
  Future<void> _showAIGenerateConfirmation() async {
    // Must have an original image
    if (_originalUploadedImage == null || _originalUploadedImage!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an original image first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Get current language name for display
    final dishName = _nameController.text.trim();
    if (dishName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a dish name first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Get English translations for AI (always use English for consistency)
    final englishTranslation = widget.item.translations['en'];
    final dishNameEnglish = englishTranslation?.name ?? dishName;
    final descriptionEnglish = englishTranslation?.description ?? _descriptionController.text.trim();
    
    final theme = Theme.of(context);
    final imageService = ref.read(imageServiceProvider);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.purple),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Generate AI Image',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reference image preview
              Text(
                'Reference Image:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Builder(
                    builder: (context) {
                      final bytes = imageService.decodeBase64DataUri(_originalUploadedImage!);
                      if (bytes != null) {
                        return Image.memory(
                          bytes,
                          height: 150,
                          width: 280,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        );
                      }
                      return Container(
                        height: 150,
                        width: 280,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Dish name (English for AI)
              Text(
                'Dish Name (English for AI):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dishNameEnglish,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description (English for AI)
              Text(
                'Description (English for AI):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  descriptionEnglish.isEmpty ? '(No description provided)' : descriptionEnglish,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: descriptionEnglish.isEmpty ? FontStyle.italic : FontStyle.normal,
                    color: descriptionEnglish.isEmpty ? Colors.grey : null,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Background processing note
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.cloud_sync, size: 18, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Image will be generated in background and auto-saved. You can close this window - you\'ll get a notification when done.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Warning note
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.amber[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'To change these details, close this dialog and edit the fields above first.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Generate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      _generateAIImage();
    }
  }
  
  /// Delete an AI-generated image
  void _deleteAiImage(int index) {
    if (index < 0 || index >= _aiGeneratedImages.length) return;
    
    final deletedImageUrl = _aiGeneratedImages[index];
    
    setState(() {
      _aiGeneratedImages.removeAt(index);
      
      // If the deleted image was currently selected, clear selection
      if (_currentImageUrl == deletedImageUrl) {
        _currentImageUrl = null;
        _selectedAiImageIndex = -1;
      } else if (index <= _selectedAiImageIndex && _selectedAiImageIndex > 0) {
        _selectedAiImageIndex = _selectedAiImageIndex - 1;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI Image #${index + 1} deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  /// Select an image from the gallery (sets it as active immediately)
  void _selectImage(String? imageUrl) {
    setState(() {
      if (imageUrl == null) {
        // Unselect - clear current image
        _currentImageUrl = null;
        _selectedAiImageIndex = -1;
      } else if (imageUrl == _originalUploadedImage) {
        // Selected original image
        _currentImageUrl = imageUrl;
        _selectedAiImageIndex = -1; // -1 means original is selected
      } else {
        // Selected an AI image
        _currentImageUrl = imageUrl;
        _selectedAiImageIndex = _aiGeneratedImages.indexOf(imageUrl);
      }
      _newImageFile = null;
      _imageDeleted = false;
    });
  }
  
  /// Check if an image is currently selected
  bool _isImageSelected(String imageUrl) {
    return _currentImageUrl == imageUrl;
  }
  
  /// Confirm and delete the original image
  void _confirmDeleteOriginalImage() {
    if (_originalUploadedImage == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Delete Original Image?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete the original image? '
          'This will also remove the ability to generate new AI images until you upload a new photo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (_isImageSelected(_originalUploadedImage!)) {
                  _currentImageUrl = null;
                }
                _originalUploadedImage = null;
                _newImageFile = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  /// Confirm and delete an AI-generated image
  void _confirmDeleteAiImage(int index) {
    if (index < 0 || index >= _aiGeneratedImages.length) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Delete AI Image?'),
          ],
        ),
        content: Text('Are you sure you want to delete AI Image #${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAiImage(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  /// Show full-screen preview of an image
  void _showImagePreviewDialog(String imageBase64, {String? title}) {
    final imageService = ref.read(imageServiceProvider);
    final bytes = imageService.decodeBase64DataUri(imageBase64);
    
    if (bytes == null) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Image
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.memory(
                  bytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
            // Title
            if (title != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_isSaving) return;
    
    setState(() => _isSaving = true);
    
    try {
      final menuService = ref.read(menuServiceProvider);
      final imageService = ref.read(imageServiceProvider);
      final translationService = ref.read(translationServiceProvider);
      final currentLang = ref.read(appLocaleProvider).languageCode;
      
      // Check if name or description changed
      final nameChanged = _nameController.text != _originalName;
      final descChanged = _descriptionController.text != _originalDescription;
      final needsTranslation = nameChanged || descChanged;
      
      // Handle image changes - convert to base64 for database storage
      String? newImageUrl = _currentImageUrl;
      
      if (_newImageFile != null) {
        // Convert image to base64 data URI
        setState(() => _isUploadingImage = true);
        newImageUrl = await imageService.convertToBase64DataUri(_newImageFile!);
        setState(() => _isUploadingImage = false);
      } else if (_imageDeleted) {
        // Clear the image
        newImageUrl = null;
      }
      
      // Determine if we need to update the image_url
      final bool shouldUpdateImage = _newImageFile != null || _imageDeleted || 
          (_currentImageUrl != widget.item.imageUrl);
      
      // Determine if we need to update the original_image_url
      final bool shouldUpdateOriginalImage = _originalUploadedImage != widget.item.originalImageUrl;
      
      // Update main item with AI images
      final price = double.tryParse(_priceController.text) ?? widget.item.price;
      await menuService.updateItem(
        id: widget.item.id,
        name: _nameController.text,
        price: price,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        languageCode: currentLang,
        imageUrl: shouldUpdateImage ? (_currentImageUrl ?? newImageUrl) : null,
        clearImageUrl: _imageDeleted && _currentImageUrl == null,
        originalImageUrl: shouldUpdateOriginalImage ? _originalUploadedImage : null,
        clearOriginalImageUrl: shouldUpdateOriginalImage && _originalUploadedImage == null,
        aiGeneratedImages: _aiGeneratedImages,
        selectedAiImageIndex: _selectedAiImageIndex,
      );

      // Delete removed variants
      for (final variantId in _deletedVariantIds) {
        await menuService.deleteVariant(variantId);
      }

      // Track new variant IDs for translation
      final newVariantIds = <String, String>{}; // variantId -> name
      
      // Update existing variants and create new ones
      for (final variant in _variants) {
        final variantPrice = double.tryParse(variant.priceController.text) ?? 0;
        
        if (variant.isNew) {
          // Create new variant and track for translation
          final variantId = await menuService.createVariant(
            itemId: widget.item.id,
            name: variant.nameController.text,
            price: variantPrice,
            sortOrder: _variants.indexOf(variant),
          );
          // Also save translation for current language
          await menuService.addVariantTranslation(
            variantId: variantId,
            languageCode: currentLang,
            name: variant.nameController.text,
          );
          newVariantIds[variantId] = variant.nameController.text;
        } else {
          // Update existing variant
          await menuService.updateVariant(
            variantId: variant.id,
            price: variantPrice,
            name: variant.nameController.text,
            languageCode: currentLang,
          );
        }
      }

      ref.invalidate(menuItemsProvider(widget.categoryId));
      if (mounted) Navigator.pop(context);
      
      // Translate in background if needed
      if (needsTranslation) {
        _translateEditedItem(
          container: _container,
          translationService: translationService,
          menuService: menuService,
          itemId: widget.item.id,
          name: _nameController.text,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          sourceLanguage: currentLang,
          categoryId: widget.categoryId,
        );
      }
      
      // Translate new variants in background
      for (final entry in newVariantIds.entries) {
        _translateNewVariant(
          container: _container,
          translationService: translationService,
          menuService: menuService,
          variantId: entry.key,
          name: entry.value,
          sourceLanguage: currentLang,
          categoryId: widget.categoryId,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
  
  /// Translate an edited item to all supported languages in the background
  Future<void> _translateEditedItem({
    required ProviderContainer container,
    required TranslationService translationService,
    required MenuService menuService,
    required String itemId,
    required String name,
    String? description,
    required String sourceLanguage,
    required String categoryId,
  }) async {
    try {
      debugPrint('Starting background translation for edited item: $name');
      final translations = await translationService.translateMenuItem(
        name: name,
        description: description,
        sourceLanguage: sourceLanguage,
      );
      
      if (translations.isNotEmpty) {
        await menuService.saveItemTranslations(
          itemId: itemId,
          translations: translations,
        );
        debugPrint('Translations saved for edited item: $name');
        container.invalidate(menuItemsProvider(categoryId));
      }
    } catch (e) {
      debugPrint('Background translation failed for edited item: $e');
    }
  }
  
  /// Translate a new variant to all supported languages in the background
  Future<void> _translateNewVariant({
    required ProviderContainer container,
    required TranslationService translationService,
    required MenuService menuService,
    required String variantId,
    required String name,
    required String sourceLanguage,
    required String categoryId,
  }) async {
    try {
      debugPrint('Starting background translation for new variant: $name');
      final translations = await translationService.translateVariantName(
        name: name,
        sourceLanguage: sourceLanguage,
      );
      
      if (translations.isNotEmpty) {
        await menuService.saveVariantTranslations(
          variantId: variantId,
          translations: translations,
        );
        debugPrint('Translations saved for new variant: $name');
        container.invalidate(menuItemsProvider(categoryId));
      }
    } catch (e) {
      debugPrint('Background translation failed for new variant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasVariants = _variants.isNotEmpty;
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // Hide image overlay when tapping outside
        if (_showImageOverlay) {
          setState(() => _showImageOverlay = false);
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Edit Item',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.restaurant_menu),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Price field (only if no variants)
                  if (!hasVariants) ...[
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Description field
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Options section
                  Row(
                    children: [
                      Icon(Icons.tune, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Options / Sizes',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _addVariant,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  if (_variants.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey[500]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No options. Tap "Add" to create size or variant options like Small, Medium, Large.',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(_variants.length, (index) {
                      final variant = _variants[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Drag handle (visual only for now)
                              Icon(Icons.drag_indicator, color: Colors.grey[400], size: 20),
                              const SizedBox(width: 8),
                              
                              // Name field
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: variant.nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Option name',
                                    isDense: true,
                                    filled: true,
                                    fillColor: theme.scaffoldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 8),
                              
                              // Price field
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: variant.priceController,
                                  decoration: InputDecoration(
                                    hintText: 'Price',
                                    prefixText: '\$ ',
                                    isDense: true,
                                    filled: true,
                                    fillColor: theme.scaffoldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                              
                              const SizedBox(width: 4),
                              
                              // Delete button
                              IconButton(
                                onPressed: () => _deleteVariant(index),
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red[400],
                                iconSize: 22,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  
                  const SizedBox(height: 24),
                  
                  // ============ ORIGINAL IMAGE SECTION ============
                  Row(
                    children: [
                      Icon(Icons.photo, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Original Image',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Tap to select • Upload or change your original photo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Original image card
                  GestureDetector(
                    onTap: () {
                      if (_originalUploadedImage != null) {
                        // Toggle selection
                        _selectImage(_isImageSelected(_originalUploadedImage!) ? null : _originalUploadedImage);
                      }
                    },
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isImageSelected(_originalUploadedImage ?? '') 
                              ? Colors.blue 
                              : Colors.grey.withOpacity(0.3),
                          width: _isImageSelected(_originalUploadedImage ?? '') ? 3 : 1,
                        ),
                        boxShadow: _isImageSelected(_originalUploadedImage ?? '') ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ] : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _originalUploadedImage != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Image
                                  Builder(
                                    builder: (context) {
                                      final imageService = ref.read(imageServiceProvider);
                                      final bytes = imageService.decodeBase64DataUri(_originalUploadedImage!);
                                      if (bytes != null) {
                                        return Image.memory(
                                          bytes,
                                          key: ValueKey(_originalUploadedImage.hashCode),
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                        );
                                      }
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                  
                                  // Selected indicator
                                  if (_isImageSelected(_originalUploadedImage!))
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  
                                  // Delete button (top right)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _confirmDeleteOriginalImage(),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.85),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Change button (bottom left)
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: GestureDetector(
                                      onTap: _isUploadingImage ? null : () {
                                        _showImagePicker();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.85),
                                          shape: BoxShape.circle,
                                        ),
                                        child: _isUploadingImage
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Fullscreen button (bottom right)
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _showImagePreviewDialog(
                                        _originalUploadedImage!,
                                        title: 'Original Image',
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: _isUploadingImage ? null : () {
                                  _showImagePicker();
                                },
                                child: Container(
                                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                  child: Center(
                                    child: _isUploadingImage
                                        ? const CircularProgressIndicator()
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.add_photo_alternate,
                                                size: 32,
                                                color: Colors.blue.withOpacity(0.7),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Upload',
                                                style: TextStyle(
                                                  color: Colors.blue.withOpacity(0.7),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  
                  // Friendly reminder if no original image
                  if (_originalUploadedImage == null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.purple.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Upload an original photo to unlock AI image generation!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // ============ AI GENERATED IMAGES SECTION ============
                  // Show this section if there are AI images OR if there's an original (to show Create New button)
                  if (_aiGeneratedImages.isNotEmpty || _originalUploadedImage != null) ...[
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text(
                          'AI Generated Images',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        // Create New AI Image button (only if original exists)
                        if (_originalUploadedImage != null)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isGeneratingAiImage ? null : _showAIGenerateConfirmation,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.purple.withOpacity(0.3),
                                  ),
                                ),
                                child: _isGeneratingAiImage
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.purple,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate,
                                            size: 18,
                                            color: Colors.purple,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'New',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      _aiGeneratedImages.isEmpty 
                          ? 'Tap "New" to generate AI images from your original photo'
                          : 'Tap to select • Scroll for more',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Horizontal scrollable AI images gallery (only show if there are AI images)
                    if (_aiGeneratedImages.isNotEmpty)
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _aiGeneratedImages.length,
                          itemBuilder: (context, index) {
                            final imageUrl = _aiGeneratedImages[index];
                            final isSelected = _isImageSelected(imageUrl);
                            final imageService = ref.read(imageServiceProvider);
                            final bytes = imageService.decodeBase64DataUri(imageUrl);
                            
                            return GestureDetector(
                              onTap: () {
                                // Toggle selection
                                _selectImage(isSelected ? null : imageUrl);
                              },
                              child: Container(
                              width: 120,
                              margin: EdgeInsets.only(right: index < _aiGeneratedImages.length - 1 ? 12 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.purple : Colors.grey.withOpacity(0.3),
                                  width: isSelected ? 3 : 1,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ] : null,
                              ),
                              child: Stack(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: bytes != null
                                        ? Image.memory(
                                            bytes,
                                            key: ValueKey(imageUrl.hashCode),
                                            width: 120,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.broken_image),
                                          ),
                                  ),
                                  
                                  // Selected indicator
                                  if (isSelected)
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  
                                  // Delete button (top right)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _confirmDeleteAiImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.85),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Fullscreen button (bottom right)
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _showImagePreviewDialog(
                                        imageUrl,
                                        title: 'AI Generated Image #${index + 1}',
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // AI label (bottom left)
                                  Positioned(
                                    bottom: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.85),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'AI #${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 100), // Space for button
                ],
              ),
            ),
          ),
          
          // Save button
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
              ],
            ),
          ),
          
          // AI Generation loading overlay
          if (_isGeneratingAiImage)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated icon
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 2 * 3.14159,
                            child: child,
                          );
                        },
                        onEnd: () {
                          // Restart animation
                          if (_isGeneratingAiImage && mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.purple,
                            size: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Generating AI Image...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Using AI to create a professional food photo based on your image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This may take 10-30 seconds',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Helper class to manage variant editing state
class _VariantEditData {
  final String id;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final bool isNew;

  _VariantEditData({
    required this.id,
    required this.nameController,
    required this.priceController,
    required this.isNew,
  });
}

// Reorderable menu list widget for drag-and-drop reordering
class _ReorderableMenuList extends ConsumerStatefulWidget {
  final List<MenuCategory> categories;
  final String restaurantId;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;
  final MenuService menuService;

  const _ReorderableMenuList({
    required this.categories,
    required this.restaurantId,
    required this.onCancel,
    required this.onSave,
    required this.menuService,
  });

  @override
  ConsumerState<_ReorderableMenuList> createState() => _ReorderableMenuListState();
}

class _ReorderableMenuListState extends ConsumerState<_ReorderableMenuList> {
  late List<MenuCategory> _categories;
  Map<String, List<MenuItem>> _itemsByCategory = {};
  Set<String> _modifiedCategories = {};
  Set<String> _modifiedItemCategories = {};
  String? _expandedCategoryId;
  bool _isSaving = false;
  bool _isLoadingItems = false;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categories);
    _loadAllItems();
  }

  Future<void> _loadAllItems() async {
    setState(() => _isLoadingItems = true);
    
    for (final category in _categories) {
      final items = await ref.read(menuItemsProvider(category.id).future);
      _itemsByCategory[category.id] = List.from(items);
    }
    
    if (mounted) {
      setState(() => _isLoadingItems = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = ref.watch(appLocaleProvider).languageCode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onCancel,
        ),
        title: const Text('Reorder Menu'),
        actions: [
          if (_modifiedCategories.isNotEmpty || _modifiedItemCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Unsaved changes',
                    style: TextStyle(color: Colors.orange[700], fontSize: 12),
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: _isSaving ? null : _saveAllChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _isLoadingItems
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Instructions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Hold and drag to reorder categories. Tap a category to reorder its items.',
                          style: TextStyle(color: Colors.blue[700], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                // Categories list
                Expanded(
                  child: _categories.isEmpty
                      ? Center(
                          child: Text('No categories to reorder', style: TextStyle(color: Colors.grey[600])),
                        )
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _categories.length,
                          onReorder: _onReorderCategories,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final catName = category.translations[lang]?.name ??
                                category.translations['en']?.name ??
                                'Category';
                            final isExpanded = _expandedCategoryId == category.id;
                            final items = _itemsByCategory[category.id] ?? [];

                            return Card(
                              key: ValueKey(category.id),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: ReorderableDragStartListener(
                                      index: index,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.drag_handle, color: Colors.grey),
                                      ),
                                    ),
                                    title: Text(
                                      catName,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text('${items.length} items'),
                                    trailing: IconButton(
                                      icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                                      onPressed: () {
                                        setState(() {
                                          _expandedCategoryId = isExpanded ? null : category.id;
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _expandedCategoryId = isExpanded ? null : category.id;
                                      });
                                    },
                                  ),
                                  if (isExpanded)
                                    _buildItemsList(category.id, items, lang, theme),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildItemsList(String categoryId, List<MenuItem> items, String lang, ThemeData theme) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No items in this category',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: items.length * 72.0 + 16,
      ),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        onReorder: (oldIndex, newIndex) => _onReorderItems(categoryId, oldIndex, newIndex),
        itemBuilder: (context, index) {
          final item = items[index];
          final itemName = item.translations[lang]?.name ??
              item.translations['en']?.name ??
              'Item';

          return Container(
            key: ValueKey(item.id),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              dense: true,
              leading: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_indicator, color: Colors.grey, size: 20),
              ),
              title: Text(itemName, style: const TextStyle(fontSize: 14)),
              trailing: Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onReorderCategories(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, item);
      _modifiedCategories = _categories.map((c) => c.id).toSet();
    });
  }

  void _onReorderItems(String categoryId, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final items = _itemsByCategory[categoryId]!;
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      _modifiedItemCategories.add(categoryId);
    });
  }

  Future<void> _saveAllChanges() async {
    setState(() => _isSaving = true);

    try {
      // Save category order if modified
      if (_modifiedCategories.isNotEmpty) {
        for (int i = 0; i < _categories.length; i++) {
          await widget.menuService.updateCategory(
            id: _categories[i].id,
            sortOrder: i,
          );
        }
      }

      // Save item order for modified categories
      for (final categoryId in _modifiedItemCategories) {
        final items = _itemsByCategory[categoryId]!;
        for (int i = 0; i < items.length; i++) {
          await widget.menuService.updateItem(
            id: items[i].id,
            sortOrder: i,
          );
        }
      }

      // Notify parent to refresh data
      await widget.onSave();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving changes: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
