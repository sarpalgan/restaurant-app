import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/pending_ai_menu_result.dart';
import '../../../../main.dart';
import '../../../../providers/pending_ai_menu_provider.dart';
import '../../../../services/ai_menu_service.dart';
import '../../../../services/menu_service.dart';
import '../../../../services/menu_template_service.dart';
import '../../../../services/restaurant_service.dart';

/// Page to view and import AI menu analysis results from background processing
class AIMenuResultPage extends ConsumerStatefulWidget {
  final String resultId;

  const AIMenuResultPage({
    super.key,
    required this.resultId,
  });

  @override
  ConsumerState<AIMenuResultPage> createState() => _AIMenuResultPageState();
}

class _AIMenuResultPageState extends ConsumerState<AIMenuResultPage> {
  // Track which items are selected for import
  final Set<int> _selectedItems = {};
  bool _selectAll = true;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    // Select all items by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final result = ref.read(pendingAIMenuResultByIdProvider(widget.resultId));
      if (result != null) {
        setState(() {
          _selectedItems.addAll(List.generate(result.items.length, (i) => i));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(pendingAIMenuResultByIdProvider(widget.resultId));
    final theme = Theme.of(context);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Menu Result')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('Result not found or expired'),
            ],
          ),
        ),
      );
    }

    if (result.status == AIMenuResultStatus.failed) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Menu Result')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Analysis Failed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  result.errorMessage ?? 'An unknown error occurred',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.go('/admin/menu/ai-creator'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentLang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Menu Result'),
        actions: [
          if (result.status == AIMenuResultStatus.completed ||
              result.status == AIMenuResultStatus.pending)
            TextButton.icon(
              onPressed: _selectedItems.isNotEmpty && !_isImporting
                  ? () => _importSelectedItems(result)
                  : null,
              icon: const Icon(Icons.check),
              label: Text('Import (${_selectedItems.length})'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Status Banner
          _buildStatusBanner(result, theme),

          // Detection Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfoChip(
                      icon: Icons.language,
                      label: result.detectedLanguageName,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    if (result.currency != null)
                      _buildInfoChip(
                        icon: Icons.attach_money,
                        label: result.currency!,
                        color: Colors.green,
                      ),
                  ],
                ),
                // Select All Toggle
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Select All'),
                    const SizedBox(width: 8),
                    Switch(
                      value: _selectAll,
                      onChanged: (value) {
                        setState(() {
                          _selectAll = value;
                          if (value) {
                            _selectedItems.addAll(
                              List.generate(result.items.length, (i) => i),
                            );
                          } else {
                            _selectedItems.clear();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: result.categories.length,
              itemBuilder: (context, catIndex) {
                final category = result.categories[catIndex];
                final categoryItems = result.items
                    .where((item) => item.category == category.name)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category.translatedNames[currentLang] ?? category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${categoryItems.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category Items
                    ...categoryItems.map((item) {
                      final itemIndex = result.items.indexOf(item);
                      final isSelected = _selectedItems.contains(itemIndex);

                      return _buildItemCard(
                        theme,
                        item,
                        itemIndex,
                        isSelected,
                        currentLang,
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_selectedItems.length} of ${result.items.length} items selected',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'With translations in multiple languages',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _selectedItems.isNotEmpty && !_isImporting
                              ? () => _saveMenuForLater(result)
                              : null,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save for Later'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _selectedItems.isNotEmpty && !_isImporting
                              ? () => _importSelectedItems(result)
                              : null,
                          icon: _isImporting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check),
                          label: Text(_isImporting ? 'Importing...' : 'Use Now'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(PendingAIMenuResult result, ThemeData theme) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String title;
    String subtitle;

    switch (result.status) {
      case AIMenuResultStatus.completed:
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = Icons.check_circle;
        title = 'Analysis Complete!';
        subtitle = 'Found ${result.items.length} items in ${result.categories.length} categories';
        break;
      case AIMenuResultStatus.imported:
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        icon = Icons.done_all;
        title = 'Already Imported';
        subtitle = 'This menu has been imported to your restaurant';
        break;
      case AIMenuResultStatus.saved:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        icon = Icons.bookmark;
        title = 'Saved as Template';
        subtitle = 'This menu has been saved for later use';
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        icon = Icons.pending;
        title = 'Processing';
        subtitle = 'Menu analysis is in progress...';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: bgColor,
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          if (result.status == AIMenuResultStatus.imported ||
              result.status == AIMenuResultStatus.saved)
            TextButton(
              onPressed: _dismissResult,
              child: const Text('Dismiss'),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    ThemeData theme,
    DetectedMenuItem item,
    int index,
    bool isSelected,
    String currentLang,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedItems.remove(index);
            } else {
              _selectedItems.add(index);
            }
            final result = ref.read(pendingAIMenuResultByIdProvider(widget.resultId));
            _selectAll = result != null && _selectedItems.length == result.items.length;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Selection Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.primaryColor
                      : Colors.grey.withOpacity(0.2),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name in current interface language
                    Text(
                      item.translatedNames[currentLang] ?? item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.translatedDescriptions[currentLang] ??
                            item.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.variants.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${item.variants.length} variants',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Price
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dismissResult() {
    ref.read(pendingAIMenuResultsProvider.notifier).removeResult(widget.resultId);
    context.pop();
  }

  Future<void> _saveMenuForLater(PendingAIMenuResult result) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Saving menu template...'),
          ],
        ),
      ),
    );

    try {
      final restaurantService = ref.read(restaurantServiceProvider);
      final templateService = ref.read(menuTemplateServiceProvider);
      
      var restaurant = await ref.read(currentRestaurantProvider.future);
      
      if (restaurant == null) {
        final user = supabase.auth.currentUser;
        if (user == null) throw Exception('Not logged in');
        
        final emailPrefix = user.email?.split('@').first ?? 'restaurant';
        final slug = '${emailPrefix.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}-${DateTime.now().millisecondsSinceEpoch}';
        
        restaurant = await restaurantService.createRestaurant(
          name: '$emailPrefix\'s Restaurant',
          slug: slug,
        );
        ref.invalidate(currentRestaurantProvider);
      }

      // Convert PendingAIMenuResult to menu template data
      final templateName = result.restaurantName ?? 'AI Menu ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
      
      await templateService.saveTemplateFromPendingResult(
        restaurantId: restaurant.id,
        name: templateName,
        description: 'Created with AI Menu Creator (Background)',
        result: result,
        selectedItems: _selectedItems,
      );

      // Mark as saved
      await ref.read(pendingAIMenuResultsProvider.notifier).markSaved(widget.resultId);

      if (mounted) {
        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu saved as template!'),
            backgroundColor: Colors.green,
          ),
        );
        
        context.go('/admin/menu/saved');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importSelectedItems(PendingAIMenuResult result) async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will import ${_selectedItems.length} menu items with translations.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Warning: This will DELETE your current menu and replace it with the imported items.',
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete & Import'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isImporting = true);

    try {
      final menuService = ref.read(menuServiceProvider);
      final restaurantService = ref.read(restaurantServiceProvider);
      final templateService = ref.read(menuTemplateServiceProvider);
      
      var restaurant = await ref.read(currentRestaurantProvider.future);
      
      if (restaurant == null) {
        final user = supabase.auth.currentUser;
        if (user == null) throw Exception('Not logged in');
        
        final emailPrefix = user.email?.split('@').first ?? 'restaurant';
        final slug = '${emailPrefix.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}-${DateTime.now().millisecondsSinceEpoch}';
        
        restaurant = await restaurantService.createRestaurant(
          name: '$emailPrefix\'s Restaurant',
          slug: slug,
        );
        ref.invalidate(currentRestaurantProvider);
      }
      
      final restaurantId = restaurant.id;

      // Save as template first
      final templateName = result.restaurantName ?? 'AI Menu ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
      await templateService.saveAndActivateTemplateFromPendingResult(
        restaurantId: restaurantId,
        name: templateName,
        description: 'Created with AI Menu Creator (Background)',
        result: result,
        selectedItems: _selectedItems,
      );

      // Delete existing categories
      final existingCategories = await ref.read(menuCategoriesProvider(restaurantId).future);
      for (final category in existingCategories) {
        await menuService.deleteCategory(category.id);
      }

      final createdCategories = <String, String>{};
      int displayOrder = 0;

      // Create categories
      for (final category in result.categories) {
        final hasSelectedItems = result.items
            .where((item) => item.category == category.name)
            .any((item) => _selectedItems.contains(result.items.indexOf(item)));

        if (!hasSelectedItems) continue;

        final createdCategory = await menuService.createCategory(
          restaurantId: restaurantId,
          name: category.translatedNames['en'] ?? category.name,
          description: null,
          sortOrder: displayOrder++,
        );
        createdCategories[category.name] = createdCategory.id;

        // Add translations
        for (final entry in category.translatedNames.entries) {
          if (entry.key == 'en') continue;
          await menuService.addCategoryTranslation(
            categoryId: createdCategory.id,
            languageCode: entry.key,
            name: entry.value,
          );
        }
      }

      // Create items
      final sortedSelectedItems = _selectedItems.toList()..sort();
      final itemDisplayOrders = <String, int>{};
      
      for (final index in sortedSelectedItems) {
        final item = result.items[index];
        final categoryId = createdCategories[item.category];
        
        if (categoryId == null) continue;

        final itemSortOrder = itemDisplayOrders[categoryId] ?? 0;
        itemDisplayOrders[categoryId] = itemSortOrder + 1;

        final createdItem = await menuService.createItem(
          categoryId: categoryId,
          restaurantId: restaurantId,
          name: item.translatedNames['en'] ?? item.name,
          description: item.translatedDescriptions['en'] ?? item.description,
          price: item.variants.isNotEmpty ? item.variants.first.price : item.price,
          sortOrder: itemSortOrder,
        );

        // Add translations
        for (final entry in item.translatedNames.entries) {
          if (entry.key == 'en') continue;
          await menuService.addItemTranslation(
            itemId: createdItem.id,
            languageCode: entry.key,
            name: entry.value,
            description: item.translatedDescriptions[entry.key],
          );
        }

        // Add variants
        for (final variant in item.variants) {
          final variantId = await menuService.createVariant(
            itemId: createdItem.id,
            name: variant.translatedNames['en'] ?? variant.name,
            price: variant.price,
            sortOrder: variant.sortOrder,
          );
          
          // Add variant translations
          for (final entry in variant.translatedNames.entries) {
            if (entry.key == 'en') continue;
            await menuService.addVariantTranslation(
              variantId: variantId,
              languageCode: entry.key,
              name: entry.value,
            );
          }
        }
      }

      // Mark as imported
      await ref.read(pendingAIMenuResultsProvider.notifier).markImported(widget.resultId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imported ${_selectedItems.length} items successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to menu management
        context.go('/admin/menu');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImporting = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
