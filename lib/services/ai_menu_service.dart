import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';

/// Represents a detected menu item from AI analysis
class DetectedMenuItem {
  final String name;
  final String? description;
  final double price;
  final String category;
  final String originalLanguage;
  final Map<String, String> translatedNames;
  final Map<String, String?> translatedDescriptions;

  DetectedMenuItem({
    required this.name,
    this.description,
    required this.price,
    required this.category,
    required this.originalLanguage,
    Map<String, String>? translatedNames,
    Map<String, String?>? translatedDescriptions,
  })  : translatedNames = translatedNames ?? {},
        translatedDescriptions = translatedDescriptions ?? {};

  factory DetectedMenuItem.fromJson(Map<String, dynamic> json) {
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
      };
}

/// Represents a detected category from AI analysis
class DetectedCategory {
  final String name;
  final String originalLanguage;
  final Map<String, String> translatedNames;
  final int itemCount;

  DetectedCategory({
    required this.name,
    required this.originalLanguage,
    Map<String, String>? translatedNames,
    this.itemCount = 0,
  }) : translatedNames = translatedNames ?? {};

  factory DetectedCategory.fromJson(Map<String, dynamic> json) {
    return DetectedCategory(
      name: json['name'] ?? 'Uncategorized',
      originalLanguage: json['original_language'] ?? 'en',
      translatedNames: json['translated_names'] != null
          ? Map<String, String>.from(json['translated_names'])
          : {},
      itemCount: json['item_count'] ?? 0,
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

      onProgress?.call('Analyzing menu with AI...', 0.3);

      // Build the prompt for Gemini
      final prompt = _buildAnalysisPrompt();

      // Call Gemini API
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
        queryParameters: {'key': AppConfig.geminiApiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
                ...images.map((img) => {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Encode(img),
                  }
                }),
              ],
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'maxOutputTokens': 8192,
            'responseMimeType': 'application/json',
          },
        },
      );

      onProgress?.call('Processing results...', 0.7);

      // Parse the response
      final result = _parseGeminiResponse(response.data);
      
      onProgress?.call('Translating to all languages...', 0.85);
      
      // Translate all items to supported languages
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

For each menu item, extract:
1. Name (in the original language shown)
2. Description (if available)
3. Price (as a number, without currency symbol)
4. Category (group similar items together, e.g., "Appetizers", "Main Courses", "Desserts", "Beverages")

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
      "original_language": "language code"
    }
  ],
  "items": [
    {
      "name": "Item name in original language",
      "description": "Description if available, null otherwise",
      "price": 12.99,
      "category": "Category name this item belongs to",
      "original_language": "language code"
    }
  ]
}

Important:
- Extract ALL visible menu items from ALL provided images
- Keep names and descriptions in their ORIGINAL language
- Prices should be numbers only (no currency symbols)
- Group items into logical categories
- If an item appears in multiple images, include it only once
- If price is not visible, estimate based on similar items or use 0
''';
  }

  MenuAnalysisResult _parseGeminiResponse(Map<String, dynamic> response) {
    try {
      final content = response['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (content == null) {
        throw Exception('No content in response');
      }

      // Parse the JSON response
      final data = jsonDecode(content) as Map<String, dynamic>;
      
      final categories = (data['categories'] as List?)
          ?.map((c) => DetectedCategory.fromJson(c))
          .toList() ?? [];
      
      final items = (data['items'] as List?)
          ?.map((i) => DetectedMenuItem.fromJson(i))
          .toList() ?? [];
      
      // Update category item counts
      final updatedCategories = categories.map((cat) {
        final count = items.where((item) => item.category == cat.name).length;
        return DetectedCategory(
          name: cat.name,
          originalLanguage: cat.originalLanguage,
          translatedNames: cat.translatedNames,
          itemCount: count,
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

  /// Translate all items and categories to all supported languages
  Future<MenuAnalysisResult> _translateAllItems(
    MenuAnalysisResult result,
    Function(String status, double progress)? onProgress,
  ) async {
    if (_useMockMode) {
      return result; // Mock already has translations
    }

    final targetLanguages = AppConfig.supportedLanguages
        .where((lang) => lang != result.detectedLanguage)
        .toList();

    if (targetLanguages.isEmpty) {
      return result;
    }

    try {
      // Build translation request
      final itemsToTranslate = result.items.map((item) => {
        'name': item.name,
        'description': item.description,
      }).toList();

      final categoriesToTranslate = result.categories.map((cat) => {
        'name': cat.name,
      }).toList();

      final translationPrompt = '''
Translate the following menu items and categories from ${result.detectedLanguageName} to these languages: ${targetLanguages.join(', ')}.

Categories to translate:
${jsonEncode(categoriesToTranslate)}

Menu items to translate:
${jsonEncode(itemsToTranslate)}

Return a JSON object with this structure:
{
  "categories": [
    {
      "original": "Original category name",
      "translations": {
        "en": "English translation",
        "es": "Spanish translation",
        ...
      }
    }
  ],
  "items": [
    {
      "original_name": "Original item name",
      "name_translations": {
        "en": "English name",
        "es": "Spanish name",
        ...
      },
      "description_translations": {
        "en": "English description or null",
        "es": "Spanish description or null",
        ...
      }
    }
  ]
}

Important:
- Keep food names culturally appropriate (don't over-translate food names that are internationally known)
- Maintain the same tone and style
- If a description is null, keep it null in translations
''';

      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
        queryParameters: {'key': AppConfig.geminiApiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'contents': [
            {
              'parts': [
                {'text': translationPrompt},
              ],
            }
          ],
          'generationConfig': {
            'temperature': 0.3,
            'maxOutputTokens': 8192,
            'responseMimeType': 'application/json',
          },
        },
      );

      final content = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (content == null) {
        return result;
      }

      final translations = jsonDecode(content) as Map<String, dynamic>;
      
      // Apply translations to categories
      final translatedCategories = result.categories.map((cat) {
        final catTranslation = (translations['categories'] as List?)?.firstWhere(
          (c) => c['original'] == cat.name,
          orElse: () => null,
        );
        
        final translatedNames = Map<String, String>.from(cat.translatedNames);
        translatedNames[result.detectedLanguage] = cat.name; // Add original
        
        if (catTranslation != null && catTranslation['translations'] != null) {
          translatedNames.addAll(Map<String, String>.from(catTranslation['translations']));
        }
        
        return DetectedCategory(
          name: cat.name,
          originalLanguage: cat.originalLanguage,
          translatedNames: translatedNames,
          itemCount: cat.itemCount,
        );
      }).toList();

      // Apply translations to items
      final translatedItems = result.items.map((item) {
        final itemTranslation = (translations['items'] as List?)?.firstWhere(
          (i) => i['original_name'] == item.name,
          orElse: () => null,
        );
        
        final translatedNames = Map<String, String>.from(item.translatedNames);
        translatedNames[result.detectedLanguage] = item.name; // Add original
        
        final translatedDescriptions = Map<String, String?>.from(item.translatedDescriptions);
        translatedDescriptions[result.detectedLanguage] = item.description; // Add original
        
        if (itemTranslation != null) {
          if (itemTranslation['name_translations'] != null) {
            translatedNames.addAll(Map<String, String>.from(itemTranslation['name_translations']));
          }
          if (itemTranslation['description_translations'] != null) {
            translatedDescriptions.addAll(Map<String, String?>.from(itemTranslation['description_translations']));
          }
        }
        
        return DetectedMenuItem(
          name: item.name,
          description: item.description,
          price: item.price,
          category: item.category,
          originalLanguage: item.originalLanguage,
          translatedNames: translatedNames,
          translatedDescriptions: translatedDescriptions,
        );
      }).toList();

      return MenuAnalysisResult(
        detectedLanguage: result.detectedLanguage,
        detectedLanguageName: result.detectedLanguageName,
        categories: translatedCategories,
        items: translatedItems,
        currency: result.currency,
        restaurantName: result.restaurantName,
      );
    } catch (e) {
      debugPrint('Translation error: $e');
      return result; // Return original if translation fails
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
