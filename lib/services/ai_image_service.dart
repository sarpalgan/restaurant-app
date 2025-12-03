import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';

/// Service for generating AI food images using Google Gemini
class AIImageService {
  final Dio _dio = Dio();

  bool get isConfigured => AppConfig.geminiApiKey.isNotEmpty;

  /// System prompt for food image generation
  static const String _systemPrompt = '''# Professional Food Photography AI Prompt

## Core Directive
Recreate the dish from the reference image with absolute fidelity to its original form, preserving the exact shape, texture, proportions, ingredient arrangement, and dish identity. The generated image must contain **only the dish and its original plate/vessel** — remove all other items, props, garnishes, utensils, backgrounds, or objects not part of the main dish.

---

## Subject Isolation
- Extract and preserve **only the food item and its original serving plate/bowl/vessel**
- Remove all secondary elements: side dishes, drinks, cutlery, napkins, garnishes not on the plate, hands, table items, or any other objects
- Maintain the exact plate/bowl design, color, shape, and material from the reference image
- Keep only garnishes and elements that are directly part of or touching the dish itself

---

## Camera & Composition (Non-Negotiable)
- **Angle**: Fixed 45-degree three-quarter view (eye-level to slightly elevated, never overhead or flat-lay)
- **Framing**: Medium-close shot with the dish occupying 60-70% of the frame
- **Centering**: Dish positioned in the exact center of the composition, horizontally and vertically balanced
- **Cropping**: Include full plate with even margins on all sides (approximately 15-20% negative space around the plate edge)
- **Orientation**: Square format (1:1 ratio) for maximum consistency
- **Focus**: Entire dish in sharp focus from front to back, no selective blur on the food itself

---

## Lighting Setup (Studio Standard)
- **Key Light**: Soft, diffused light from 45° front-left, creating gentle dimensionality
- **Fill Light**: Subtle fill from the right to open shadows (70% intensity of key)
- **Backlight**: Optional faint rim light to separate dish from background
- **Shadows**: Minimal, soft-edged shadows directly beneath the plate
- **Color Temperature**: Neutral 5500K daylight balance, no warm or cool color casts
- **Reflections**: Eliminate harsh specular highlights; use only soft, natural-looking sheens on glossy surfaces

---

## Background & Surface
- **Surface**: Clean, pure white matte tabletop with no texture or pattern visible
- **Backdrop**: Seamless pure-white studio backdrop (infinity curve style), softly out of focus
- **Vignette**: Extremely subtle natural light fall-off at edges (do not create artificial darkening)
- **Depth**: Background should appear 2-3 feet behind the subject with minimal detail
- **Cleanliness**: Zero visible props, textures, patterns, or environmental elements

---

## Realism & Quality Standards
- **Rendering Style**: Photorealistic, not illustrated or stylized
- **Resolution**: High-resolution output (minimum 2048px) with tack-sharp detail
- **Texture Accuracy**: Preserve exact surface qualities — crispy, creamy, juicy, charred, etc. — as shown in reference
- **Color Fidelity**: Match the reference dish's true colors; apply only minimal color correction for natural white balance
- **Enhancement Level**: Subtle beautification only — make appetizing without altering reality (no HDR, no over-saturation, no fake steam)
- **Food Physics**: Liquids, sauces, and textures must behave naturally (no floating elements, impossible stacking, or gravity defiance)

---

## Absolute Restrictions
- **Do not** change, add, or remove any ingredients from the dish
- **Do not** alter the dish's identity, cooking style, or preparation method
- **Do not** change the angle from the specified 45° three-quarter view
- **Do not** include overhead/flat-lay perspective
- **Do not** introduce new props, garnishes, or decorative elements
- **Do not** keep any objects from the reference image except the dish and its original plate
- **Do not** use dramatic lighting, moody tones, or artistic filters
- **Do not** apply vintage, film, or stylistic post-processing effects

---

## Consistency Checklist
Before finalizing, verify:
- [ ] Only dish + original plate visible, all other items removed
- [ ] 45° angle maintained
- [ ] Dish centered with even margins
- [ ] Square 1:1 crop ratio
- [ ] Pure white, clean background
- [ ] Soft, even studio lighting
- [ ] Photorealistic texture and color
- [ ] No visual distractions or secondary objects

---

**Output Goal**: A consistent, clean, professional studio photograph that looks like it was shot in a controlled commercial photography environment — reproducible, centered, and focused entirely on showcasing the dish with editorial-quality realism.
''';

  /// Generate an AI-enhanced food image
  /// 
  /// [referenceImageBase64] - The original image as base64 data URI
  /// [dishName] - Name of the dish
  /// [description] - Description/ingredients of the dish
  /// 
  /// Returns a base64 data URI of the generated image, or null if failed
  Future<String?> generateFoodImage({
    required String referenceImageBase64,
    required String dishName,
    String? description,
  }) async {
    if (!isConfigured) {
      debugPrint('AI Image Service not configured - Gemini API key missing');
      return null;
    }

    try {
      // Extract base64 data and mime type from data URI
      final parts = referenceImageBase64.split(',');
      if (parts.length != 2) {
        debugPrint('Invalid base64 data URI format');
        return null;
      }
      
      final mimeMatch = RegExp(r'data:([^;]+);base64').firstMatch(parts[0]);
      final mimeType = mimeMatch?.group(1) ?? 'image/jpeg';
      final base64Data = parts[1];

      // Build the user prompt
      final userPrompt = _buildUserPrompt(dishName, description);

      debugPrint('Sending image generation request to Gemini API...');

      final uri = Uri.https(
        'generativelanguage.googleapis.com',
        '/v1beta/models/gemini-3-pro-image-preview:generateContent',
        {'key': AppConfig.geminiApiKey},
      );

      final response = await _dio.postUri(
        uri,
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'inlineData': {
                    'mimeType': mimeType,
                    'data': base64Data,
                  },
                },
                {
                  'text': userPrompt,
                },
              ],
            },
          ],
          'generationConfig': {
            'responseModalities': ['TEXT', 'IMAGE'],
            'imageConfig': {
              'aspectRatio': '1:1',
              'imageSize': '1K',
            },
          },
          'systemInstruction': {
            'parts': [
              {'text': _systemPrompt},
            ],
          },
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      debugPrint('Response received from Gemini API');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return _parseImageResponse(data);
      } else {
        debugPrint('Gemini API error: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('AI Image generation failed: $e');
      return null;
    }
  }

  /// Build the user prompt with dish name and description
  String _buildUserPrompt(String dishName, String? description) {
    final buffer = StringBuffer();
    buffer.writeln('Dish name: **$dishName**');
    if (description != null && description.isNotEmpty) {
      buffer.writeln('Description: **{$description}**');
    }
    return buffer.toString();
  }

  /// Parse the Gemini response to extract the generated image
  String? _parseImageResponse(Map<String, dynamic> data) {
    try {
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        debugPrint('No candidates in response');
        return null;
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      if (content == null) {
        debugPrint('No content in candidate');
        return null;
      }

      final parts = content['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        debugPrint('No parts in content');
        return null;
      }

      // Look for inline data (image) in the response parts
      for (final part in parts) {
        final partMap = part as Map<String, dynamic>;
        if (partMap.containsKey('inlineData')) {
          final inlineData = partMap['inlineData'] as Map<String, dynamic>;
          final mimeType = inlineData['mimeType'] as String? ?? 'image/png';
          final imageData = inlineData['data'] as String?;
          
          if (imageData != null && imageData.isNotEmpty) {
            // Return as data URI
            return 'data:$mimeType;base64,$imageData';
          }
        }
      }

      debugPrint('No image data found in response parts');
      return null;
    } catch (e) {
      debugPrint('Error parsing image response: $e');
      return null;
    }
  }

  /// Decode a base64 data URI to bytes (for preview)
  Uint8List? decodeBase64DataUri(String dataUri) {
    try {
      final base64String = dataUri.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
      return null;
    }
  }
}

/// Provider for AIImageService
final aiImageServiceProvider = Provider<AIImageService>((ref) {
  return AIImageService();
});

/// State for AI image generation
class AIImageGenerationState {
  final bool isGenerating;
  final String? error;
  final List<String> generatedImages; // List of base64 data URIs
  final int? selectedIndex;

  const AIImageGenerationState({
    this.isGenerating = false,
    this.error,
    this.generatedImages = const [],
    this.selectedIndex,
  });

  AIImageGenerationState copyWith({
    bool? isGenerating,
    String? error,
    List<String>? generatedImages,
    int? selectedIndex,
  }) {
    return AIImageGenerationState(
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
      generatedImages: generatedImages ?? this.generatedImages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  bool get hasGeneratedImages => generatedImages.isNotEmpty;
  String? get selectedImage => 
      selectedIndex != null && selectedIndex! < generatedImages.length
          ? generatedImages[selectedIndex!]
          : null;
}

/// Notifier for managing AI image generation state
class AIImageGenerationNotifier extends StateNotifier<AIImageGenerationState> {
  final AIImageService _service;

  AIImageGenerationNotifier(this._service) : super(const AIImageGenerationState());

  /// Generate a new AI image
  Future<bool> generateImage({
    required String referenceImageBase64,
    required String dishName,
    String? description,
  }) async {
    state = state.copyWith(isGenerating: true, error: null);

    final result = await _service.generateFoodImage(
      referenceImageBase64: referenceImageBase64,
      dishName: dishName,
      description: description,
    );

    if (result != null) {
      final newImages = [...state.generatedImages, result];
      state = state.copyWith(
        isGenerating: false,
        generatedImages: newImages,
        selectedIndex: newImages.length - 1, // Select the newly generated image
      );
      return true;
    } else {
      state = state.copyWith(
        isGenerating: false,
        error: 'Failed to generate image. Please try again.',
      );
      return false;
    }
  }

  /// Select a generated image by index
  void selectImage(int index) {
    if (index >= 0 && index < state.generatedImages.length) {
      state = state.copyWith(selectedIndex: index);
    }
  }

  /// Clear all generated images
  void clearImages() {
    state = const AIImageGenerationState();
  }

  /// Remove a generated image by index
  void removeImage(int index) {
    if (index >= 0 && index < state.generatedImages.length) {
      final newImages = [...state.generatedImages]..removeAt(index);
      int? newSelectedIndex = state.selectedIndex;
      
      if (newImages.isEmpty) {
        newSelectedIndex = null;
      } else if (state.selectedIndex != null && state.selectedIndex! >= index) {
        newSelectedIndex = (state.selectedIndex! - 1).clamp(0, newImages.length - 1);
      }
      
      state = state.copyWith(
        generatedImages: newImages,
        selectedIndex: newSelectedIndex,
      );
    }
  }

  /// Initialize with existing AI images from the database
  void initializeWithExistingImages(List<String> images, int? selectedIndex) {
    state = AIImageGenerationState(
      generatedImages: images,
      selectedIndex: selectedIndex ?? (images.isNotEmpty ? 0 : null),
    );
  }
}

/// Provider for AI image generation state (scoped per menu item edit)
final aiImageGenerationProvider = StateNotifierProvider.autoDispose<
    AIImageGenerationNotifier, AIImageGenerationState>((ref) {
  return AIImageGenerationNotifier(ref.watch(aiImageServiceProvider));
});
