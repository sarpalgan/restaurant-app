import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Service for handling menu item image picking and base64 encoding
/// Images are stored as base64 data URIs directly in the database
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
  }

  /// Pick an image from the camera
  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
  }

  /// Convert an XFile to a base64 data URI string
  /// Returns a data URI like: data:image/jpeg;base64,/9j/4AAQSkZJRg...
  Future<String> convertToBase64DataUri(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64String = base64Encode(bytes);
    final mimeType = _getMimeType(imageFile.path);
    return 'data:$mimeType;base64,$base64String';
  }

  /// Check if a string is a base64 data URI
  bool isBase64DataUri(String? url) {
    if (url == null) return false;
    return url.startsWith('data:image/');
  }

  /// Get the MIME type from file extension
  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  /// Decode a base64 data URI to bytes (for display)
  Uint8List? decodeBase64DataUri(String dataUri) {
    try {
      // Extract the base64 part after the comma
      final base64String = dataUri.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
      return null;
    }
  }
}

/// Provider for ImageService
final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});
