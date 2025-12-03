import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';

/// Represents a variant/option for a menu item (e.g., Small/Medium/Large)
class MenuItemVariant {
  final String name;
  final double price;
  final int sortOrder;
  final Map<String, String> translatedNames;

  MenuItemVariant({
    required this.name,
    required this.price,
    this.sortOrder = 0,
    Map<String, String>? translatedNames,
  }) : translatedNames = translatedNames ?? {};

  factory MenuItemVariant.fromJson(Map<String, dynamic> json) {
    return MenuItemVariant(
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sortOrder: json['sort_order'] as int? ?? 0,
      translatedNames: json['translated_names'] != null
          ? Map<String, String>.from(json['translated_names'])
          : {},
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'sort_order': sortOrder,
        'translated_names': translatedNames,
      };
}

/// Represents a detected menu item from AI analysis
class DetectedMenuItem {
  final String name;
  final String? description;
  final double price;
  final String category;
  final String originalLanguage;
  final Map<String, String> translatedNames;
  final Map<String, String?> translatedDescriptions;
  final List<MenuItemVariant> variants;
  final bool hasVariants;
  final int sortOrder;

  DetectedMenuItem({
    required this.name,
    this.description,
    required this.price,
    required this.category,
    required this.originalLanguage,
    Map<String, String>? translatedNames,
    Map<String, String?>? translatedDescriptions,
    List<MenuItemVariant>? variants,
    this.sortOrder = 0,
  })  : translatedNames = translatedNames ?? {},
        translatedDescriptions = translatedDescriptions ?? {},
        variants = variants ?? [],
        hasVariants = (variants ?? []).isNotEmpty;

  factory DetectedMenuItem.fromJson(Map<String, dynamic> json) {
    final variantsList = (json['variants'] as List?)
        ?.map((v) => MenuItemVariant.fromJson(v as Map<String, dynamic>))
        .toList() ?? [];
    
    return DetectedMenuItem(
      name: json['name'] ?? 'Unknown Item',
      description: json['description'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? 'Uncategorized',
      originalLanguage: json['original_language'] ?? 'en',
      translatedNames: json['translated_names'] != null
          ? Map<String, String>.from(json['translated_names'])
          : {},
      translatedDescriptions: json['translated_descriptions'] != null
          ? Map<String, String?>.from(json['translated_descriptions'])
          : {},
      variants: variantsList,
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'original_language': originalLanguage,
        'translated_names': translatedNames,
        'translated_descriptions': translatedDescriptions,
        'variants': variants.map((v) => v.toJson()).toList(),
        'sort_order': sortOrder,
      };
}

/// Represents a detected category from AI analysis
class DetectedCategory {
  final String name;
  final String originalLanguage;
  final Map<String, String> translatedNames;
  final int itemCount;
  final int sortOrder;

  DetectedCategory({
    required this.name,
    required this.originalLanguage,
    Map<String, String>? translatedNames,
    this.itemCount = 0,
    this.sortOrder = 0,
  }) : translatedNames = translatedNames ?? {};

  factory DetectedCategory.fromJson(Map<String, dynamic> json) {
    return DetectedCategory(
      name: json['name'] ?? 'Uncategorized',
      originalLanguage: json['original_language'] ?? 'en',
      translatedNames: json['translated_names'] != null
          ? Map<String, String>.from(json['translated_names'])
          : {},
      itemCount: json['item_count'] ?? 0,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}

/// Result of AI menu analysis
class MenuAnalysisResult {
  final String detectedLanguage;
  final String detectedLanguageName;
  final List<DetectedCategory> categories;
  final List<DetectedMenuItem> items;
  final String? currency;
  final String? restaurantName;

  MenuAnalysisResult({
    required this.detectedLanguage,
    required this.detectedLanguageName,
    required this.categories,
    required this.items,
    this.currency,
    this.restaurantName,
  });

  int get totalItems => items.length;
  int get totalCategories => categories.length;
}

/// Service for AI-powered menu creation using Google Gemini
class AIMenuService {
  final Dio _dio;
  
  AIMenuService() : _dio = Dio();

  /// Check if AI menu service is configured
  bool get isConfigured => AppConfig.geminiApiKey.isNotEmpty;

  /// Check if running in mock mode
  bool get _useMockMode => !isConfigured || !AppConfig.isGeminiConfigured;

  /// Analyze multiple menu images and extract menu items
  Future<MenuAnalysisResult> analyzeMenuImages({
    required List<Uint8List> images,
    Function(String status, double progress)? onProgress,
  }) async {
    if (_useMockMode) {
      return _getMockAnalysisResult(onProgress);
    }

    try {
      onProgress?.call('Preparing images...', 0.1);
      
      // Convert images to base64
      final imageContents = images.map((img) => {
        'type': 'image',
        'source': {
          'type': 'base64',
          'media_type': 'image/jpeg',
          'data': base64Encode(img),
        },
      }).toList();

      onProgress?.call('Analyzing menu with AI (this may take a minute)...', 0.3);

      // Build the prompt for Gemini
      final prompt = _buildAnalysisPrompt();
      debugPrint('Sending request to Gemini API for extraction...');

      // Call Gemini API - using gemini-3-pro-preview for vision capabilities
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-preview:generateContent',
        queryParameters: {'key': AppConfig.geminiApiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(seconds: 60),
        ),
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
                ...images.map((img) => {
                      'inlineData': {
                        'mimeType': 'image/jpeg',
                        'data': base64Encode(img),
                      }
                    }),
              ],
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'maxOutputTokens': 65536,
            'responseMimeType': 'application/json',
          },
        },
      );

      debugPrint('Response received from Gemini API');
      onProgress?.call('Processing results...', 0.6);

      // Parse the response
      final result = _parseGeminiResponse(response.data);
      debugPrint('Parsed ${result.items.length} items in ${result.categories.length} categories');
      
      onProgress?.call('Translating menu items...', 0.8);
      
      // Translate items using a separate model
      final translatedResult = await _translateAllItems(result, onProgress);
      
      onProgress?.call('Complete!', 1.0);
      
      return translatedResult;
    } catch (e) {
      debugPrint('AI Menu Analysis Error: $e');
      rethrow;
    }
  }

  String _buildAnalysisPrompt() {
    return '''
You are an expert at analyzing restaurant menu images. Analyze the provided menu image(s) and extract all menu items.

IMPORTANT: Preserve the EXACT ORDER of categories and items as they appear in the menu image, from top to bottom, left to right.

For each menu item, extract:
1. Name (in the original language shown)
2. Description (if available)
3. Price (as a number, without currency symbol) - use the base/lowest price if there are variants
4. Category (use the exact category name from the menu)
5. Variants/Options (if the item has size options like Small/Medium/Large, or quantity options like 2pc/5pc/10pc)

VARIANTS HANDLING:
- If an item has multiple size/quantity options with different prices (e.g., Pizza: Small 10, Medium 15, Large 20), create ONE item entry with variants array
- Each variant should have: name (e.g., "Small", "Medium", "Large" or "2 pieces", "5 pieces") and price
- The main item price should be the lowest/base price
- Common variant patterns: sizes (S/M/L, Small/Medium/Large), quantities (2pc/5pc/10pc), portions (Half/Full)

Also detect:
- The language of the menu
- The currency used (if identifiable)
- The restaurant name (if visible)

Return the data as a JSON object with this exact structure:
{
  "detected_language": "language code (e.g., en, es, tr, zh, de, fr, it, ru)",
  "detected_language_name": "Language Name (e.g., English, Spanish, Turkish)",
  "currency": "USD or EUR or TRY etc",
  "restaurant_name": "Name if visible, null otherwise",
  "categories": [
    {
      "name": "Category Name in original language",
      "original_language": "language code",
      "sort_order": 0
    }
  ],
  "items": [
    {
      "name": "Item name in original language",
      "description": "Description if available, null otherwise",
      "price": 12.99,
      "category": "Category name this item belongs to",
      "original_language": "language code",
      "sort_order": 0,
      "variants": [
        {"name": "Small", "price": 10.99, "sort_order": 0},
        {"name": "Medium", "price": 14.99, "sort_order": 1},
        {"name": "Large", "price": 18.99, "sort_order": 2}
      ]
    }
  ]
}

Important:
- Extract ALL visible menu items from ALL provided images
- Keep names and descriptions in their ORIGINAL language
- Prices should be numbers only (no currency symbols)
- PRESERVE THE EXACT ORDER - use sort_order starting from 0 for first category/item
- Categories should be ordered as they appear in the menu (top to bottom)
- Items within each category should be ordered as they appear (top to bottom)
- If an item appears in multiple images, include it only once
- If price is not visible, estimate based on similar items or use 0
- For items with variants, the "variants" array should contain all options with their prices
- Items WITHOUT variants should have an empty variants array: "variants": []
''';
  }

  Future<MenuAnalysisResult> _translateAllItems(
    MenuAnalysisResult extractionResult,
    Function(String status, double progress)? onProgress,
  ) async {
    try {
      // If no items to translate, return original result
      if (extractionResult.items.isEmpty) {
        return extractionResult;
      }

      final prompt = _buildTranslationPrompt(extractionResult);
      debugPrint('Sending request to Gemini API for translation...');

      // Call Gemini API - using gemini-2.5-flash-lite for faster text processing
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
        queryParameters: {'key': AppConfig.geminiApiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(seconds: 60),
        ),
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'maxOutputTokens': 65536,
            'responseMimeType': 'application/json',
          },
        },
      );

      debugPrint('Translation response received from Gemini API');
      onProgress?.call('Finalizing menu...', 0.9);

      return _parseTranslationResponse(response.data, extractionResult);
    } catch (e) {
      debugPrint('Translation Error: $e');
      // If translation fails, return the original result with original language only
      return extractionResult;
    }
  }

  String _buildTranslationPrompt(MenuAnalysisResult result) {
    final languages = AppConfig.supportedLanguages.join(', ');
    
    // Create a simplified representation of items for translation (including variants)
    final itemsJson = result.items.map((item) => {
      'name': item.name,
      'description': item.description,
      'category': item.category,
      'variants': item.variants.map((v) => {'name': v.name}).toList(),
    }).toList();

    final categoriesJson = result.categories.map((cat) => {
      'name': cat.name,
    }).toList();

    return '''
You are an expert translator for restaurant menus. 
Translate the following menu items, categories, and variants from "${result.detectedLanguageName}" to ALL of these languages: $languages.

Input Data:
Categories: ${jsonEncode(categoriesJson)}
Items: ${jsonEncode(itemsJson)}

Return the data as a JSON object with this exact structure:
{
  "categories": [
    {
      "name": "Original Category Name",
      "translated_names": {
        "en": "English translation",
        "es": "Spanish translation",
        "tr": "Turkish translation",
        "de": "German translation",
        "fr": "French translation",
        "it": "Italian translation",
        "ru": "Russian translation",
        "zh": "Chinese translation"
      }
    }
  ],
  "items": [
    {
      "name": "Original Item Name",
      "translated_names": {
        "en": "English translation",
        "es": "Spanish translation",
        "tr": "Turkish translation",
        "de": "German translation",
        "fr": "French translation",
        "it": "Italian translation",
        "ru": "Russian translation",
        "zh": "Chinese translation"
      },
      "translated_descriptions": {
        "en": "English description or null",
        "es": "Spanish description or null",
        "tr": "Turkish description or null",
        "de": "German description or null",
        "fr": "French description or null",
        "it": "Italian description or null",
        "ru": "Russian description or null",
        "zh": "Chinese description or null"
      },
      "variants": [
        {
          "name": "Original Variant Name",
          "translated_names": {
            "en": "English translation",
            "es": "Spanish translation",
            "tr": "Turkish translation",
            "de": "German translation",
            "fr": "French translation",
            "it": "Italian translation",
            "ru": "Russian translation",
            "zh": "Chinese translation"
          }
        }
      ]
    }
  ]
}

Important:
- Provide translations for ALL requested languages.
- Keep food names culturally appropriate.
- Maintain the exact order of items, categories, and variants.
- Translate variant names like "Small", "Medium", "Large", "2 pieces", etc. appropriately.
''';
  }

  MenuAnalysisResult _parseTranslationResponse(Map<String, dynamic> response, MenuAnalysisResult originalResult) {
    try {
      final content = response['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (content == null) throw Exception('No content in translation response');

      Map<String, dynamic> data;
      try {
        data = jsonDecode(content);
      } catch (e) {
        final repaired = _tryRepairJson(content);
        if (repaired != null) {
          data = repaired;
        } else {
          throw e;
        }
      }

      // Create maps for quick lookup
      final categoryTranslations = <String, Map<String, String>>{};
      if (data['categories'] != null) {
        for (var cat in data['categories']) {
          if (cat['name'] != null && cat['translated_names'] != null) {
            categoryTranslations[cat['name']] = Map<String, String>.from(cat['translated_names']);
          }
        }
      }

      final itemTranslations = <String, Map<String, String>>{};
      final itemDescTranslations = <String, Map<String, String?>>{};
      final itemVariantTranslations = <String, List<Map<String, dynamic>>>{};
      
      if (data['items'] != null) {
        for (var item in data['items']) {
          final name = item['name'];
          if (name != null) {
            if (item['translated_names'] != null) {
              itemTranslations[name] = Map<String, String>.from(item['translated_names']);
            }
            if (item['translated_descriptions'] != null) {
              itemDescTranslations[name] = Map<String, String?>.from(item['translated_descriptions']);
            }
            if (item['variants'] != null) {
              itemVariantTranslations[name] = List<Map<String, dynamic>>.from(item['variants']);
            }
          }
        }
      }

      // Update categories
      final updatedCategories = originalResult.categories.map((cat) {
        final translations = categoryTranslations[cat.name] ?? {};
        // Ensure original language is included
        translations[originalResult.detectedLanguage] = cat.name;
        
        return DetectedCategory(
          name: cat.name,
          originalLanguage: cat.originalLanguage,
          translatedNames: translations,
          itemCount: cat.itemCount,
          sortOrder: cat.sortOrder,
        );
      }).toList();

      // Update items
      final updatedItems = originalResult.items.map((item) {
        final nameTranslations = itemTranslations[item.name] ?? {};
        final descTranslations = itemDescTranslations[item.name] ?? {};
        final variantTransData = itemVariantTranslations[item.name] ?? [];
        
        // Ensure original language is included
        nameTranslations[originalResult.detectedLanguage] = item.name;
        if (item.description != null) {
          descTranslations[originalResult.detectedLanguage] = item.description;
        }

        // Update variant translations
        final updatedVariants = item.variants.map((variant) {
          // Find matching variant translation
          Map<String, String> variantNameTranslations = {};
          for (var vt in variantTransData) {
            if (vt['name'] == variant.name && vt['translated_names'] != null) {
              variantNameTranslations = Map<String, String>.from(vt['translated_names']);
              break;
            }
          }
          // Ensure original language is included
          variantNameTranslations[originalResult.detectedLanguage] = variant.name;
          
          return MenuItemVariant(
            name: variant.name,
            price: variant.price,
            sortOrder: variant.sortOrder,
            translatedNames: variantNameTranslations,
          );
        }).toList();

        return DetectedMenuItem(
          name: item.name,
          description: item.description,
          price: item.price,
          category: item.category,
          originalLanguage: item.originalLanguage,
          translatedNames: nameTranslations,
          translatedDescriptions: descTranslations,
          variants: updatedVariants,
          sortOrder: item.sortOrder,
        );
      }).toList();

      return MenuAnalysisResult(
        detectedLanguage: originalResult.detectedLanguage,
        detectedLanguageName: originalResult.detectedLanguageName,
        categories: updatedCategories,
        items: updatedItems,
        currency: originalResult.currency,
        restaurantName: originalResult.restaurantName,
      );
    } catch (e) {
      debugPrint('Error parsing translation response: $e');
      return originalResult;
    }
  }

  MenuAnalysisResult _parseGeminiResponse(Map<String, dynamic> response) {
    try {
      // Check for API errors first
      final error = response['error'];
      if (error != null) {
        throw Exception('Gemini API error: ${error['message'] ?? error}');
      }

      final content = response['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (content == null) {
        // Check if there's a finish reason that indicates truncation
        final finishReason = response['candidates']?[0]?['finishReason'];
        if (finishReason == 'MAX_TOKENS') {
          throw Exception('Response was truncated due to token limit. Please try with fewer menu items.');
        }
        throw Exception('No content in response');
      }

      // Try to parse the JSON, with repair attempt for truncated responses
      Map<String, dynamic> data;
      try {
        data = jsonDecode(content) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Initial JSON parse failed, attempting repair...');
        final repaired = _tryRepairJson(content);
        if (repaired != null) {
          data = repaired;
          debugPrint('JSON repair successful!');
        } else {
          rethrow;
        }
      }
      
      final categories = (data['categories'] as List?)
          ?.map((c) => DetectedCategory.fromJson(c))
          .toList() ?? [];
      
      final items = (data['items'] as List?)
          ?.map((i) => DetectedMenuItem.fromJson(i))
          .toList() ?? [];
      
      // Sort categories by sort_order to preserve menu ordering
      categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      
      // Sort items by sort_order to preserve menu ordering
      items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      
      // Update category item counts
      final updatedCategories = categories.map((cat) {
        final count = items.where((item) => item.category == cat.name).length;
        return DetectedCategory(
          name: cat.name,
          originalLanguage: cat.originalLanguage,
          translatedNames: cat.translatedNames,
          itemCount: count,
          sortOrder: cat.sortOrder,
        );
      }).toList();

      return MenuAnalysisResult(
        detectedLanguage: data['detected_language'] ?? 'en',
        detectedLanguageName: data['detected_language_name'] ?? 'English',
        categories: updatedCategories,
        items: items,
        currency: data['currency'],
        restaurantName: data['restaurant_name'],
      );
    } catch (e) {
      debugPrint('Error parsing Gemini response: $e');
      rethrow;
    }
  }
  
  /// Attempt to repair truncated JSON by closing unclosed structures
  Map<String, dynamic>? _tryRepairJson(String content) {
    try {
      var json = content.trim();
      
      // Count unclosed brackets
      int openBraces = 0;
      int openBrackets = 0;
      bool inString = false;
      bool escaped = false;
      
      for (int i = 0; i < json.length; i++) {
        final char = json[i];
        if (escaped) {
          escaped = false;
          continue;
        }
        if (char == '\\') {
          escaped = true;
          continue;
        }
        if (char == '"' && !escaped) {
          inString = !inString;
          continue;
        }
        if (!inString) {
          if (char == '{') openBraces++;
          if (char == '}') openBraces--;
          if (char == '[') openBrackets++;
          if (char == ']') openBrackets--;
        }
      }
      
      // If we're in a string, close it
      if (inString) {
        json += '"';
      }
      
      // Remove any incomplete last item (ends with comma or incomplete object)
      // Find the last complete item
      final lastCompleteItem = json.lastIndexOf('},');
      if (lastCompleteItem > 0 && openBraces > 0) {
        json = json.substring(0, lastCompleteItem + 1);
        // Recalculate brackets
        openBraces = 0;
        openBrackets = 0;
        inString = false;
        for (int i = 0; i < json.length; i++) {
          final char = json[i];
          if (escaped) {
            escaped = false;
            continue;
          }
          if (char == '\\') {
            escaped = true;
            continue;
          }
          if (char == '"' && !escaped) {
            inString = !inString;
            continue;
          }
          if (!inString) {
            if (char == '{') openBraces++;
            if (char == '}') openBraces--;
            if (char == '[') openBrackets++;
            if (char == ']') openBrackets--;
          }
        }
      }
      
      // Close unclosed brackets
      for (int i = 0; i < openBrackets; i++) {
        json += ']';
      }
      for (int i = 0; i < openBraces; i++) {
        json += '}';
      }
      
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('JSON repair failed: $e');
      return null;
    }
  }

  /// Generate mock analysis result for demo mode
  Future<MenuAnalysisResult> _getMockAnalysisResult(
    Function(String status, double progress)? onProgress,
  ) async {
    onProgress?.call('Preparing images...', 0.1);
    await Future.delayed(const Duration(milliseconds: 500));
    
    onProgress?.call('Analyzing menu with AI...', 0.3);
    await Future.delayed(const Duration(seconds: 1));
    
    onProgress?.call('Detecting items and prices...', 0.5);
    await Future.delayed(const Duration(milliseconds: 800));
    
    onProgress?.call('Translating to all languages...', 0.7);
    await Future.delayed(const Duration(milliseconds: 800));
    
    onProgress?.call('Complete!', 1.0);

    // Return mock data
    return MenuAnalysisResult(
      detectedLanguage: 'tr',
      detectedLanguageName: 'Turkish',
      currency: 'TRY',
      restaurantName: 'Demo Restaurant',
      categories: [
        DetectedCategory(
          name: 'Başlangıçlar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Başlangıçlar',
            'en': 'Appetizers',
            'es': 'Entrantes',
            'de': 'Vorspeisen',
            'fr': 'Entrées',
            'it': 'Antipasti',
            'ru': 'Закуски',
            'zh': '开胃菜',
          },
          itemCount: 3,
        ),
        DetectedCategory(
          name: 'Ana Yemekler',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Ana Yemekler',
            'en': 'Main Courses',
            'es': 'Platos Principales',
            'de': 'Hauptgerichte',
            'fr': 'Plats Principaux',
            'it': 'Piatti Principali',
            'ru': 'Основные блюда',
            'zh': '主菜',
          },
          itemCount: 4,
        ),
        DetectedCategory(
          name: 'Tatlılar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Tatlılar',
            'en': 'Desserts',
            'es': 'Postres',
            'de': 'Nachspeisen',
            'fr': 'Desserts',
            'it': 'Dolci',
            'ru': 'Десерты',
            'zh': '甜点',
          },
          itemCount: 2,
        ),
      ],
      items: [
        DetectedMenuItem(
          name: 'Mercimek Çorbası',
          description: 'Geleneksel Türk mercimek çorbası, taze ekmek ile servis edilir',
          price: 45.0,
          category: 'Başlangıçlar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Mercimek Çorbası',
            'en': 'Lentil Soup',
            'es': 'Sopa de Lentejas',
            'de': 'Linsensuppe',
            'fr': 'Soupe aux Lentilles',
            'it': 'Zuppa di Lenticchie',
            'ru': 'Чечевичный суп',
            'zh': '扁豆汤',
          },
          translatedDescriptions: {
            'tr': 'Geleneksel Türk mercimek çorbası, taze ekmek ile servis edilir',
            'en': 'Traditional Turkish lentil soup, served with fresh bread',
            'es': 'Sopa tradicional turca de lentejas, servida con pan fresco',
            'de': 'Traditionelle türkische Linsensuppe, serviert mit frischem Brot',
            'fr': 'Soupe aux lentilles traditionnelle turque, servie avec du pain frais',
            'it': 'Zuppa di lenticchie tradizionale turca, servita con pane fresco',
            'ru': 'Традиционный турецкий чечевичный суп, подается со свежим хлебом',
            'zh': '传统土耳其扁豆汤，配新鲜面包',
          },
        ),
        DetectedMenuItem(
          name: 'Humus',
          description: 'Nohut püresi, zeytinyağı ve baharatlar ile',
          price: 55.0,
          category: 'Başlangıçlar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Humus',
            'en': 'Hummus',
            'es': 'Hummus',
            'de': 'Hummus',
            'fr': 'Houmous',
            'it': 'Hummus',
            'ru': 'Хумус',
            'zh': '鹰嘴豆泥',
          },
          translatedDescriptions: {
            'tr': 'Nohut püresi, zeytinyağı ve baharatlar ile',
            'en': 'Chickpea puree with olive oil and spices',
            'es': 'Puré de garbanzos con aceite de oliva y especias',
            'de': 'Kichererbsenpüree mit Olivenöl und Gewürzen',
            'fr': 'Purée de pois chiches avec huile d\'olive et épices',
            'it': 'Purè di ceci con olio d\'oliva e spezie',
            'ru': 'Пюре из нута с оливковым маслом и специями',
            'zh': '鹰嘴豆泥配橄榄油和香料',
          },
        ),
        DetectedMenuItem(
          name: 'Sigara Böreği',
          description: 'Çıtır yufka içinde beyaz peynir, 4 adet',
          price: 65.0,
          category: 'Başlangıçlar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Sigara Böreği',
            'en': 'Cheese Rolls',
            'es': 'Rollitos de Queso',
            'de': 'Käserollen',
            'fr': 'Rouleaux au Fromage',
            'it': 'Involtini di Formaggio',
            'ru': 'Сырные рулетики',
            'zh': '芝士卷',
          },
          translatedDescriptions: {
            'tr': 'Çıtır yufka içinde beyaz peynir, 4 adet',
            'en': 'Crispy filo pastry with white cheese, 4 pieces',
            'es': 'Masa filo crujiente con queso blanco, 4 piezas',
            'de': 'Knuspriger Filoteig mit weißem Käse, 4 Stück',
            'fr': 'Pâte filo croustillante avec fromage blanc, 4 pièces',
            'it': 'Pasta fillo croccante con formaggio bianco, 4 pezzi',
            'ru': 'Хрустящее тесто фило с белым сыром, 4 штуки',
            'zh': '脆皮菲罗配白奶酪，4个',
          },
        ),
        DetectedMenuItem(
          name: 'Adana Kebap',
          description: 'Acılı kıyma kebabı, pilav ve salata ile',
          price: 180.0,
          category: 'Ana Yemekler',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Adana Kebap',
            'en': 'Adana Kebab',
            'es': 'Kebab Adana',
            'de': 'Adana Kebab',
            'fr': 'Kebab Adana',
            'it': 'Kebab Adana',
            'ru': 'Адана Кебаб',
            'zh': '阿达纳烤肉',
          },
          translatedDescriptions: {
            'tr': 'Acılı kıyma kebabı, pilav ve salata ile',
            'en': 'Spicy minced meat kebab, served with rice and salad',
            'es': 'Kebab de carne picada picante, servido con arroz y ensalada',
            'de': 'Würziger Hackfleisch-Kebab, serviert mit Reis und Salat',
            'fr': 'Kebab de viande hachée épicée, servi avec riz et salade',
            'it': 'Kebab di carne macinata piccante, servito con riso e insalata',
            'ru': 'Острый кебаб из рубленого мяса, подается с рисом и салатом',
            'zh': '辣味肉末烤肉，配米饭和沙拉',
          },
        ),
        DetectedMenuItem(
          name: 'Izgara Levrek',
          description: 'Taze levrek, ızgara sebzeler ile',
          price: 220.0,
          category: 'Ana Yemekler',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Izgara Levrek',
            'en': 'Grilled Sea Bass',
            'es': 'Lubina a la Parrilla',
            'de': 'Gegrillter Wolfsbarsch',
            'fr': 'Bar Grillé',
            'it': 'Branzino alla Griglia',
            'ru': 'Сибас на гриле',
            'zh': '烤鲈鱼',
          },
          translatedDescriptions: {
            'tr': 'Taze levrek, ızgara sebzeler ile',
            'en': 'Fresh sea bass with grilled vegetables',
            'es': 'Lubina fresca con verduras a la parrilla',
            'de': 'Frischer Wolfsbarsch mit gegrilltem Gemüse',
            'fr': 'Bar frais avec légumes grillés',
            'it': 'Branzino fresco con verdure grigliate',
            'ru': 'Свежий сибас с овощами на гриле',
            'zh': '新鲜鲈鱼配烤蔬菜',
          },
        ),
        DetectedMenuItem(
          name: 'Karışık Izgara',
          description: 'Kuzu pirzola, tavuk ve köfte, yanında pilav',
          price: 250.0,
          category: 'Ana Yemekler',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Karışık Izgara',
            'en': 'Mixed Grill',
            'es': 'Parrillada Mixta',
            'de': 'Gemischter Grill',
            'fr': 'Grillade Mixte',
            'it': 'Grigliata Mista',
            'ru': 'Ассорти на гриле',
            'zh': '烧烤拼盘',
          },
          translatedDescriptions: {
            'tr': 'Kuzu pirzola, tavuk ve köfte, yanında pilav',
            'en': 'Lamb chops, chicken and meatballs, served with rice',
            'es': 'Chuletas de cordero, pollo y albóndigas, servido con arroz',
            'de': 'Lammkoteletts, Hähnchen und Fleischbällchen, serviert mit Reis',
            'fr': 'Côtelettes d\'agneau, poulet et boulettes de viande, servi avec du riz',
            'it': 'Costolette di agnello, pollo e polpette, servito con riso',
            'ru': 'Бараньи отбивные, курица и фрикадельки, подается с рисом',
            'zh': '羊排、鸡肉和肉丸，配米饭',
          },
        ),
        DetectedMenuItem(
          name: 'Mantı',
          description: 'El yapımı Türk mantısı, yoğurt ve sos ile',
          price: 145.0,
          category: 'Ana Yemekler',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Mantı',
            'en': 'Turkish Dumplings',
            'es': 'Dumplings Turcos',
            'de': 'Türkische Maultaschen',
            'fr': 'Raviolis Turcs',
            'it': 'Ravioli Turchi',
            'ru': 'Турецкие пельмени',
            'zh': '土耳其饺子',
          },
          translatedDescriptions: {
            'tr': 'El yapımı Türk mantısı, yoğurt ve sos ile',
            'en': 'Handmade Turkish dumplings with yogurt and sauce',
            'es': 'Dumplings turcos hechos a mano con yogur y salsa',
            'de': 'Handgemachte türkische Maultaschen mit Joghurt und Soße',
            'fr': 'Raviolis turcs faits maison avec yaourt et sauce',
            'it': 'Ravioli turchi fatti a mano con yogurt e salsa',
            'ru': 'Домашние турецкие пельмени с йогуртом и соусом',
            'zh': '手工土耳其饺子配酸奶和酱汁',
          },
        ),
        DetectedMenuItem(
          name: 'Baklava',
          description: 'Antep fıstıklı geleneksel baklava, 4 dilim',
          price: 85.0,
          category: 'Tatlılar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Baklava',
            'en': 'Baklava',
            'es': 'Baklava',
            'de': 'Baklava',
            'fr': 'Baklava',
            'it': 'Baklava',
            'ru': 'Пахлава',
            'zh': '果仁蜜饼',
          },
          translatedDescriptions: {
            'tr': 'Antep fıstıklı geleneksel baklava, 4 dilim',
            'en': 'Traditional baklava with pistachios, 4 slices',
            'es': 'Baklava tradicional con pistachos, 4 porciones',
            'de': 'Traditionelles Baklava mit Pistazien, 4 Scheiben',
            'fr': 'Baklava traditionnel aux pistaches, 4 tranches',
            'it': 'Baklava tradizionale con pistacchi, 4 fette',
            'ru': 'Традиционная пахлава с фисташками, 4 кусочка',
            'zh': '传统开心果果仁蜜饼，4片',
          },
        ),
        DetectedMenuItem(
          name: 'Künefe',
          description: 'Sıcak peynirli künefe, kaymak ile servis edilir',
          price: 95.0,
          category: 'Tatlılar',
          originalLanguage: 'tr',
          translatedNames: {
            'tr': 'Künefe',
            'en': 'Künefe',
            'es': 'Künefe',
            'de': 'Künefe',
            'fr': 'Künefe',
            'it': 'Künefe',
            'ru': 'Кюнефе',
            'zh': '土耳其奶酪甜点',
          },
          translatedDescriptions: {
            'tr': 'Sıcak peynirli künefe, kaymak ile servis edilir',
            'en': 'Hot cheese pastry, served with clotted cream',
            'es': 'Pastel de queso caliente, servido con crema espesa',
            'de': 'Heißes Käsegebäck, serviert mit Sahne',
            'fr': 'Pâtisserie au fromage chaude, servie avec de la crème',
            'it': 'Dolce al formaggio caldo, servito con panna',
            'ru': 'Горячая сырная выпечка, подается со сливками',
            'zh': '热奶酪糕点，配凝脂奶油',
          },
        ),
      ],
    );
  }
}

// Provider for AIMenuService
final aiMenuServiceProvider = Provider<AIMenuService>((ref) {
  return AIMenuService();
});
