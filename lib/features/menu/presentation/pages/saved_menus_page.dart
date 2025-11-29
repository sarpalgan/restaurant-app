import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/menu_template.dart';
import '../../../../services/menu_template_service.dart';
import '../../../../services/menu_service.dart';
import '../../../../services/restaurant_service.dart';
import '../../../../services/cleanup_service.dart';

class SavedMenusPage extends ConsumerStatefulWidget {
  const SavedMenusPage({super.key});

  @override
  ConsumerState<SavedMenusPage> createState() => _SavedMenusPageState();
}

class _SavedMenusPageState extends ConsumerState<SavedMenusPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check for duplicates after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDuplicates();
    });
  }

  Future<void> _checkDuplicates() async {
    final cleanupService = ref.read(cleanupServiceProvider);
    final duplicates = await cleanupService.getDuplicateRestaurants();
    
    if (duplicates.length > 1 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${duplicates.length} duplicate restaurants. Please fix.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Fix Now',
            textColor: Colors.white,
            onPressed: () => _showCleanupDialog(duplicates),
          ),
        ),
      );
    }
  }

  Future<void> _showCleanupDialog(List<Map<String, dynamic>> duplicates) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fix Duplicate Restaurants'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('We found ${duplicates.length} restaurants linked to your account.'),
            const SizedBox(height: 16),
            const Text(
              'This likely happened due to a previous error. We can merge all data (menus, templates, etc.) into the most recent restaurant and delete the duplicates.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Keeping: ${duplicates.first['name']} (Created: ${_formatDate(DateTime.parse(duplicates.first['created_at']))})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Deleting: ${duplicates.length - 1} older duplicates',
              style: const TextStyle(color: Colors.red),
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
            child: const Text('Merge & Fix'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final cleanupService = ref.read(cleanupServiceProvider);
      final ids = duplicates.map((d) => d['id'] as String).toList();
      
      await cleanupService.mergeRestaurants(ids);
      
      // Refresh everything
      ref.invalidate(currentRestaurantProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restaurants merged successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error merging: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurantAsync = ref.watch(currentRestaurantProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Menus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Menu with AI',
            onPressed: () => context.push('/admin/menu/ai-creator'),
          ),
        ],
      ),
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (restaurant) {
          if (restaurant == null) {
            return const Center(
              child: Text('No restaurant found. Please set up your restaurant first.'),
            );
          }

          final templatesAsync = ref.watch(menuTemplatesProvider(restaurant.id));

          return templatesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (templates) {
              if (templates.isEmpty) {
                return _buildEmptyState(theme);
              }

              return Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      return _buildTemplateCard(theme, templates[index], restaurant.id);
                    },
                  ),
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Menus',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create menus using AI and save them here for future use.\nYou can switch between different menus anytime.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/admin/menu/ai-creator'),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Create Menu with AI'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(ThemeData theme, MenuTemplate template, String restaurantId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: template.isActive
            ? BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showTemplateDetails(theme, template, restaurantId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                template.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (template.isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (template.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            template.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleMenuAction(action, template, restaurantId),
                    itemBuilder: (context) => [
                      if (!template.isActive)
                        const PopupMenuItem(
                          value: 'activate',
                          child: ListTile(
                            leading: Icon(Icons.play_arrow, color: Colors.green),
                            title: Text('Use This Menu'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'rename',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Rename'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy),
                          title: Text('Duplicate'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.restaurant_menu,
                    '${template.itemCount} items',
                    Colors.blue,
                  ),
                  _buildInfoChip(
                    Icons.category,
                    '${template.categoryCount} categories',
                    Colors.purple,
                  ),
                  if (template.detectedLanguageName != null)
                    _buildInfoChip(
                      Icons.language,
                      template.detectedLanguageName!,
                      Colors.orange,
                    ),
                  if (template.currency != null)
                    _buildInfoChip(
                      Icons.attach_money,
                      template.currency!,
                      Colors.green,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Created ${_formatDate(template.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} min ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showTemplateDetails(ThemeData theme, MenuTemplate template, String restaurantId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          final items = template.templateData['items'] as List? ?? [];
          final categories = template.templateData['categories'] as List? ?? [];

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            template.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!template.isActive)
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _activateTemplate(template, restaurantId);
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Use This Menu'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, catIndex) {
                    final category = categories[catIndex];
                    final catName = category['name'] as String;
                    final catItems = items
                        .where((i) => i['category'] == catName)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            catName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        ...catItems.map((item) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item['name'] ?? ''),
                              subtitle: item['description'] != null
                                  ? Text(
                                      item['description'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: Text(
                                '${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            )),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleMenuAction(String action, MenuTemplate template, String restaurantId) {
    switch (action) {
      case 'activate':
        _activateTemplate(template, restaurantId);
        break;
      case 'rename':
        _renameTemplate(template);
        break;
      case 'duplicate':
        _duplicateTemplate(template);
        break;
      case 'delete':
        _deleteTemplate(template, restaurantId);
        break;
    }
  }

  Future<void> _activateTemplate(MenuTemplate template, String restaurantId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to switch to "${template.name}"?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This will replace your current menu with this saved menu.',
                      style: TextStyle(fontSize: 13),
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
            child: const Text('Switch'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final templateService = ref.read(menuTemplateServiceProvider);
      final menuService = ref.read(menuServiceProvider);

      await templateService.activateTemplate(
        templateId: template.id,
        restaurantId: restaurantId,
        menuService: menuService,
      );

      // Refresh providers
      ref.invalidate(menuTemplatesProvider(restaurantId));
      ref.invalidate(menuCategoriesProvider(restaurantId));
      ref.invalidate(allMenuItemsProvider(restaurantId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to "${template.name}"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _renameTemplate(MenuTemplate template) async {
    final controller = TextEditingController(text: template.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Menu'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Menu Name',
            hintText: 'Enter a new name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || newName == template.name) return;

    try {
      final templateService = ref.read(menuTemplateServiceProvider);
      await templateService.updateTemplate(id: template.id, name: newName);
      ref.invalidate(menuTemplatesProvider(template.restaurantId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu renamed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _duplicateTemplate(MenuTemplate template) async {
    final controller = TextEditingController(text: '${template.name} (Copy)');
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Menu'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'New Menu Name',
            hintText: 'Enter a name for the copy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Duplicate'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;

    try {
      final templateService = ref.read(menuTemplateServiceProvider);
      await templateService.duplicateTemplate(
        templateId: template.id,
        newName: newName,
      );
      ref.invalidate(menuTemplatesProvider(template.restaurantId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu duplicated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteTemplate(MenuTemplate template, String restaurantId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu'),
        content: Text('Are you sure you want to delete "${template.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final templateService = ref.read(menuTemplateServiceProvider);
      await templateService.deleteTemplate(template.id);
      ref.invalidate(menuTemplatesProvider(restaurantId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
