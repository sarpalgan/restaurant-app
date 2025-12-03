import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';

/// Service for translating menu content using Google Gemini API
class TranslationService {
  final Dio _dio;

  TranslationService() : _dio = Dio();

  /// Check if translation service is configured
  bool get isConfigured => AppConfig.geminiApiKey.isNotEmpty;

  /// Translate a menu item's name and description to all supported languages
  /// Returns a map of language code -> {name: String, description: String?}
  Future<Map<String, Map<String, String?>>> translateMenuItem({
    required String name,
    String? description,
    required String sourceLanguage,
  }) async {
    if (!isConfigured) {
      debugPrint('Translation service not configured - Gemini API key missing');
      return {};
    }

    try {
      // Get target languages (all except source)
      final targetLanguages = AppConfig.supportedLanguages
          .where((lang) => lang != sourceLanguage)
          .toList();

      if (targetLanguages.isEmpty) return {};

      final prompt = _buildTranslationPrompt(
        name: name,
        description: description,
        sourceLanguage: sourceLanguage,
        targetLanguages: targetLanguages,
      );

      debugPrint('Sending translation request to Gemini API...');

      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
        queryParameters: {'key': AppConfig.geminiApiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
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
            'maxOutputTokens': 4096,
            'responseMimeType': 'application/json',
          },
        },
      );

      debugPrint('Translation response received');
      return _parseTranslationResponse(response.data);
    } catch (e) {
      debugPrint('Translation error: $e');
      return {};
    }
  }

  /// Translate a variant name to all supported languages
  /// Returns a map of language code -> translated name
  Future<Map<String, String>> translateVariantName({
    required String name,
    required String sourceLanguage,
  }) async {
    if (!isConfigured) {
      debugPrint('Translation service not configured - Gemini API key missing');
      return {};
    }

    try {
      final targetLanguages = AppConfig.supportedLanguages
          .where((lang) => lang != sourceLanguage)
          .toList();

      if (targetLanguages.isEmpty) return {};

      final prompt = _buildVariantTranslationPrompt(
        name: name,
        sourceLanguage: sourceLanguage,
        targetLanguages: targetLanguages,
      );

      debugPrint('Sending variant translation request to Gemini API...');

      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
        queryParameters: {'key': AppConfig.geminiApiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
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
            'maxOutputTokens': 2048,
            'responseMimeType': 'application/json',
          },
        },
      );

      debugPrint('Variant translation response received');
      return _parseVariantTranslationResponse(response.data);
    } catch (e) {
      debugPrint('Variant translation error: $e');
      return {};
    }
  }

  String _buildTranslationPrompt({
    required String name,
    String? description,
    required String sourceLanguage,
    required List<String> targetLanguages,
  }) {
    final sourceLangName = AppConfig.languageNames[sourceLanguage] ?? sourceLanguage;
    final targetLangsStr = targetLanguages.join(', ');

    return '''
You are an expert translator for restaurant menus. Translate the following menu item from $sourceLangName to these languages: $targetLangsStr.

Menu Item:
- Name: "$name"
${description != null ? '- Description: "$description"' : '- Description: null'}

Return the translations as a JSON object with this exact structure:
{
  "translations": {
${targetLanguages.map((lang) => '''    "$lang": {
      "name": "translated name in $lang",
      "description": ${description != null ? '"translated description in $lang or null if empty"' : 'null'}
    }''').join(',\n')}
  }
}

Important:
- Keep food names culturally appropriate
- Translate the description only if it was provided (not null)
- Use proper grammar and food terminology for each language
- For well-known dish names (like "Pizza", "Sushi", etc.), keep them recognizable
''';
  }

  String _buildVariantTranslationPrompt({
    required String name,
    required String sourceLanguage,
    required List<String> targetLanguages,
  }) {
    final sourceLangName = AppConfig.languageNames[sourceLanguage] ?? sourceLanguage;
    final targetLangsStr = targetLanguages.join(', ');

    return '''
You are an expert translator for restaurant menus. Translate the following menu item variant/size name from $sourceLangName to these languages: $targetLangsStr.

Variant Name: "$name"

This is typically a size option like "Small", "Medium", "Large", "Regular", "Family Size", or quantity like "2 pieces", "5 pieces", etc.

Return the translations as a JSON object with this exact structure:
{
  "translations": {
${targetLanguages.map((lang) => '    "$lang": "translated name in $lang"').join(',\n')}
  }
}

Important:
- Use standard size/quantity terminology for each language
- Keep it concise and natural sounding
''';
  }

  Map<String, Map<String, String?>> _parseTranslationResponse(Map<String, dynamic> response) {
    try {
      final content = response['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (content == null) return {};

      final data = jsonDecode(content) as Map<String, dynamic>;
      final translations = data['translations'] as Map<String, dynamic>?;
      if (translations == null) return {};

      final result = <String, Map<String, String?>>{};
      for (final entry in translations.entries) {
        final langData = entry.value as Map<String, dynamic>;
        result[entry.key] = {
          'name': langData['name'] as String?,
          'description': langData['description'] as String?,
        };
      }
      return result;
    } catch (e) {
      debugPrint('Error parsing translation response: $e');
      return {};
    }
  }

  Map<String, String> _parseVariantTranslationResponse(Map<String, dynamic> response) {
    try {
      final content = response['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (content == null) return {};

      final data = jsonDecode(content) as Map<String, dynamic>;
      final translations = data['translations'] as Map<String, dynamic>?;
      if (translations == null) return {};

      return translations.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      debugPrint('Error parsing variant translation response: $e');
      return {};
    }
  }
}

/// Provider for TranslationService
final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
});
