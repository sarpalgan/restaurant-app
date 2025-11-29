import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/app_config.dart';
import '../../../../main.dart';
import '../../../../services/ai_menu_service.dart';
import '../../../../services/menu_service.dart';
import '../../../../services/menu_template_service.dart';
import '../../../../services/restaurant_service.dart';

class AIMenuCreatorPage extends ConsumerStatefulWidget {
  const AIMenuCreatorPage({super.key});

  @override
  ConsumerState<AIMenuCreatorPage> createState() => _AIMenuCreatorPageState();
}

class _AIMenuCreatorPageState extends ConsumerState<AIMenuCreatorPage> {
  final List<Uint8List> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  
  bool _isAnalyzing = false;
  String _currentStatus = '';
  double _progress = 0.0;
  MenuAnalysisResult? _analysisResult;
  
  // Track which items are selected for import
  final Set<int> _selectedItems = {};
  bool _selectAll = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Menu Creator'),
        actions: [
          if (_analysisResult != null)
            TextButton.icon(
              onPressed: _selectedItems.isNotEmpty ? _importSelectedItems : null,
              icon: const Icon(Icons.check),
              label: Text('Import (${_selectedItems.length})'),
            ),
        ],
      ),
      body: _analysisResult != null
          ? _buildResultsView(theme)
          : _buildUploadView(theme),
    );
  }

  Widget _buildUploadView(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI-Powered Menu Creation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Upload photos of your menu and let AI do the rest!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Features list
                _buildFeatureItem(Icons.language, 'Auto-detects menu language'),
                const SizedBox(height: 8),
                _buildFeatureItem(Icons.translate, 'Translates to 8 languages'),
                const SizedBox(height: 8),
                _buildFeatureItem(Icons.category, 'Creates categories automatically'),
                const SizedBox(height: 8),
                _buildFeatureItem(Icons.attach_money, 'Extracts prices'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Image Upload Section
          Text(
            'Upload Menu Photos',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can upload multiple photos. The AI will combine all items from all pages.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Image Grid
          if (_selectedImages.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _selectedImages.length) {
                  return _buildAddMoreButton();
                }
                return _buildImageTile(index);
              },
            ),
            const SizedBox(height: 8),
            Text(
              '${_selectedImages.length} photo(s) selected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            // Empty state with upload options
            _buildEmptyUploadArea(),
          ],

          const SizedBox(height: 24),

          // Demo Mode Warning
          if (!AppConfig.isGeminiConfigured)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Demo Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Using sample data. Add your Gemini API key for real AI analysis.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Analyze Button
          if (_isAnalyzing)
            _buildProgressCard(theme)
          else if (_selectedImages.isNotEmpty)
            FilledButton.icon(
              onPressed: _analyzeImages,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analyze Menu'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyUploadArea() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
          // style: BorderStyle.dashed, // Dashed not supported, using solid
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _showUploadOptions,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap to upload menu photos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supports JPG, PNG • Multiple photos allowed',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return InkWell(
      onTap: _showUploadOptions,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.grey[600], size: 32),
            const SizedBox(height: 4),
            Text(
              'Add More',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            _selectedImages[index],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentStatus,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Please wait while AI analyzes your menu...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_progress * 100).toInt()}%',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(ThemeData theme) {
    final result = _analysisResult!;

    return Column(
      children: [
        // Summary Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Analysis Complete!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Found ${result.totalItems} items in ${result.totalCategories} categories',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _startOver,
                child: const Text('Start Over'),
              ),
            ],
          ),
        ),

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              // Show English translation
                              if (category.translatedNames['en'] != null &&
                                  category.translatedNames['en'] != category.name)
                                Text(
                                  category.translatedNames['en']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.primaryColor.withOpacity(0.7),
                                  ),
                                ),
                            ],
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

                    return _buildItemCard(theme, item, itemIndex, isSelected);
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
                            '${_selectedItems.length} of ${result.totalItems} items selected',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'With translations in 8 languages',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/admin/menu/saved'),
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: const Text('Saved'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectedItems.isNotEmpty ? _saveMenuForLater : null,
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
                        onPressed: _selectedItems.isNotEmpty ? _importSelectedItems : null,
                        icon: const Icon(Icons.check),
                        label: const Text('Use Now'),
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
            _selectAll = _selectedItems.length == _analysisResult!.items.length;
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
                    // Original Name
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // English translation if different
                    if (item.translatedNames['en'] != null &&
                        item.translatedNames['en'] != item.name)
                      Text(
                        item.translatedNames['en']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (item.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Translations preview
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: AppConfig.supportedLanguages.take(4).map((lang) {
                        final hasTranslation = item.translatedNames[lang] != null;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: hasTranslation
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppConfig.languageFlags[lang] ?? '',
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                hasTranslation ? Icons.check : Icons.pending,
                                size: 10,
                                color: hasTranslation
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Price
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select multiple photos'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              subtitle: const Text('Use camera to capture menu'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      
      for (final image in images) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImages.add(bytes);
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting images: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImages.add(bytes);
        });
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _analyzeImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _currentStatus = 'Starting...';
      _progress = 0.0;
    });

    try {
      final aiService = ref.read(aiMenuServiceProvider);
      final result = await aiService.analyzeMenuImages(
        images: _selectedImages,
        onProgress: (status, progress) {
          if (mounted) {
            setState(() {
              _currentStatus = status;
              _progress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _analysisResult = result;
          // Select all items by default
          _selectedItems.addAll(
            List.generate(result.items.length, (i) => i),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing menu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startOver() {
    setState(() {
      _selectedImages.clear();
      _analysisResult = null;
      _selectedItems.clear();
      _selectAll = true;
    });
  }

  Future<void> _saveMenuForLater() async {
    if (_analysisResult == null || _selectedItems.isEmpty) return;

    final nameController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Menu Name *',
                hintText: 'e.g., Summer Menu 2025',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'e.g., Seasonal dishes for summer',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'description': descController.text.trim(),
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Saving menu...'),
          ],
        ),
      ),
    );

    try {
      final templateService = ref.read(menuTemplateServiceProvider);
      final restaurantService = ref.read(restaurantServiceProvider);

      // Get or create restaurant
      var restaurant = await ref.read(currentRestaurantProvider.future);
      if (restaurant == null) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          throw Exception('You must be logged in.');
        }
        final emailPrefix = user.email?.split('@').first ?? 'restaurant';
        final slug = '${emailPrefix.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}-${DateTime.now().millisecondsSinceEpoch}';
        restaurant = await restaurantService.createRestaurant(
          name: '$emailPrefix\'s Restaurant',
          slug: slug,
        );
        ref.invalidate(currentRestaurantProvider);
      }

      await templateService.saveTemplate(
        restaurantId: restaurant.id,
        name: result['name'] ?? 'Untitled Menu',
        description: (result['description'] ?? '').isEmpty ? null : result['description'],
        analysisResult: _analysisResult!,
        selectedItems: _selectedItems,
      );

      // Refresh templates
      ref.invalidate(menuTemplatesProvider(restaurant.id));

      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu "${result['name']}" saved!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Saved',
              textColor: Colors.white,
              onPressed: () => context.push('/admin/menu/saved'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving menu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importSelectedItems() async {
    if (_analysisResult == null || _selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will import ${_selectedItems.length} menu items with translations in 8 languages.',
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Categories will be created automatically.',
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
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete & Import'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Replacing menu...'),
          ],
        ),
      ),
    );

    try {
      final menuService = ref.read(menuServiceProvider);
      final restaurantService = ref.read(restaurantServiceProvider);
      
      // Fetch the restaurant properly using async
      var restaurant = await ref.read(currentRestaurantProvider.future);
      
      // If no restaurant exists, create one automatically
      if (restaurant == null) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          throw Exception('You must be logged in to import menu items.');
        }
        
        // Generate a slug from email
        final emailPrefix = user.email?.split('@').first ?? 'restaurant';
        final slug = '${emailPrefix.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}-${DateTime.now().millisecondsSinceEpoch}';
        
        // Create restaurant automatically
        restaurant = await restaurantService.createRestaurant(
          name: '$emailPrefix\'s Restaurant',
          slug: slug,
        );
        
        // Invalidate the provider so it picks up the new restaurant
        ref.invalidate(currentRestaurantProvider);
      }
      
      final restaurantId = restaurant.id;

      // Step 1: Delete all existing categories (this will cascade delete items)
      final existingCategories = await ref.read(menuCategoriesProvider(restaurantId).future);
      for (final category in existingCategories) {
        await menuService.deleteCategory(category.id);
      }

      final result = _analysisResult!;
      final createdCategories = <String, String>{}; // name -> id
      int displayOrder = 0;

      // Step 2: Create new categories
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

        // Add translations (skip 'en' as it's already added by createCategory)
        for (final entry in category.translatedNames.entries) {
          if (entry.key == 'en') continue; // Already added
          await menuService.addCategoryTranslation(
            categoryId: createdCategory.id,
            languageCode: entry.key,
            name: entry.value,
          );
        }
      }

      // Step 3: Create new items
      final itemDisplayOrders = <String, int>{};
      for (final index in _selectedItems) {
        final item = result.items[index];
        final categoryId = createdCategories[item.category];
        
        if (categoryId == null) continue;

        // Track display order per category
        itemDisplayOrders[categoryId] = (itemDisplayOrders[categoryId] ?? 0) + 1;

        final createdItem = await menuService.createItem(
          categoryId: categoryId,
          restaurantId: restaurantId,
          name: item.translatedNames['en'] ?? item.name,
          description: item.translatedDescriptions['en'] ?? item.description,
          price: item.price,
          sortOrder: itemDisplayOrders[categoryId],
        );

        // Add translations (skip 'en' as it's already added by createItem)
        for (final lang in AppConfig.supportedLanguages) {
          if (lang == 'en') continue; // Already added
          final translatedName = item.translatedNames[lang];
          final translatedDesc = item.translatedDescriptions[lang];
          
          if (translatedName != null) {
            await menuService.addItemTranslation(
              itemId: createdItem.id,
              languageCode: lang,
              name: translatedName,
              description: translatedDesc,
            );
          }
        }
      }

      // Invalidate the menu providers to refresh data
      ref.invalidate(menuCategoriesProvider(restaurantId));
      ref.invalidate(allMenuItemsProvider(restaurantId));

      if (mounted) {
        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully replaced menu with ${_selectedItems.length} items!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to menu
        context.go('/admin/menu');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing items: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
