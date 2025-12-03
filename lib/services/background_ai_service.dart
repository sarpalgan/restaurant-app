import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';
import 'ai_menu_service.dart';
import 'notification_service.dart';

/// Message sent to the background isolate
class AIAnalysisRequest {
  final List<Uint8List> images;
  final String apiKey;
  final List<String> supportedLanguages;

  AIAnalysisRequest({
    required this.images,
    required this.apiKey,
    required this.supportedLanguages,
  });

  Map<String, dynamic> toJson() => {
    'images': images.map((e) => base64Encode(e)).toList(),
    'apiKey': apiKey,
    'supportedLanguages': supportedLanguages,
  };

  factory AIAnalysisRequest.fromJson(Map<String, dynamic> json) {
    return AIAnalysisRequest(
      images: (json['images'] as List).map((e) => base64Decode(e as String)).toList(),
      apiKey: json['apiKey'] as String,
      supportedLanguages: List<String>.from(json['supportedLanguages']),
    );
  }
}

/// Result from background processing
class AIAnalysisBackgroundResult {
  final bool success;
  final MenuAnalysisResult? result;
  final String? error;
  final double progress;
  final String? statusMessage;

  AIAnalysisBackgroundResult({
    required this.success,
    this.result,
    this.error,
    this.progress = 0,
    this.statusMessage,
  });
}

/// Service for running AI analysis in the background
class BackgroundAIService {
  static final BackgroundAIService _instance = BackgroundAIService._internal();
  factory BackgroundAIService() => _instance;
  BackgroundAIService._internal();

  final NotificationService _notifications = NotificationService();
  
  // Active analysis tracking
  Isolate? _activeIsolate;
  ReceivePort? _receivePort;
  StreamController<AIAnalysisBackgroundResult>? _resultController;
  bool _isProcessing = false;
  
  static const int _progressNotificationId = 1001;
  static const Duration _timeout = Duration(minutes: 12);

  bool get isProcessing => _isProcessing;

  /// Start background AI analysis
  /// Returns a stream of progress updates and the final result
  Stream<AIAnalysisBackgroundResult> analyzeInBackground({
    required List<Uint8List> images,
  }) {
    // Cancel any existing analysis
    cancelAnalysis();

    _isProcessing = true;
    _resultController = StreamController<AIAnalysisBackgroundResult>.broadcast();

    // Start the analysis
    _startBackgroundAnalysis(images);

    return _resultController!.stream;
  }

  Future<void> _startBackgroundAnalysis(List<Uint8List> images) async {
    await _notifications.initialize();

    // Show initial progress notification
    await _notifications.showProgress(
      id: _progressNotificationId,
      title: 'Analyzing Menu',
      body: 'Preparing images...',
      progress: 10,
      maxProgress: 100,
    );

    _resultController?.add(AIAnalysisBackgroundResult(
      success: true,
      progress: 0.1,
      statusMessage: 'Preparing images...',
    ));

    try {
      // Run the actual analysis (with timeout)
      final result = await _runAnalysisWithTimeout(images);
      
      // Cancel progress notification
      await _notifications.cancel(_progressNotificationId);
      
      if (result != null) {
        // Show success notification
        await _notifications.showAIMenuComplete(
          title: 'Menu Analysis Complete! ✓',
          body: 'Found ${result.totalItems} items in ${result.totalCategories} categories',
          payload: 'ai_menu_complete',
        );

        _resultController?.add(AIAnalysisBackgroundResult(
          success: true,
          result: result,
          progress: 1.0,
          statusMessage: 'Complete!',
        ));
      }
    } catch (e) {
      // Cancel progress notification
      await _notifications.cancel(_progressNotificationId);
      
      // Show error notification
      await _notifications.showAIMenuComplete(
        title: 'Menu Analysis Failed',
        body: e.toString().length > 100 ? '${e.toString().substring(0, 100)}...' : e.toString(),
        payload: 'ai_menu_error',
      );

      _resultController?.add(AIAnalysisBackgroundResult(
        success: false,
        error: e.toString(),
        progress: 0,
        statusMessage: 'Error: $e',
      ));
    } finally {
      _isProcessing = false;
      _resultController?.close();
    }
  }

  Future<MenuAnalysisResult?> _runAnalysisWithTimeout(List<Uint8List> images) async {
    final aiService = AIMenuService();
    
    // Create a completer for the result
    final completer = Completer<MenuAnalysisResult>();
    
    // Set up timeout
    final timer = Timer(_timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('Analysis timed out after 5 minutes', _timeout),
        );
      }
    });

    try {
      final result = await aiService.analyzeMenuImages(
        images: images,
        onProgress: (status, progress) async {
          // Update progress notification
          await _notifications.showProgress(
            id: _progressNotificationId,
            title: 'Analyzing Menu',
            body: status,
            progress: (progress * 100).toInt(),
            maxProgress: 100,
          );

          _resultController?.add(AIAnalysisBackgroundResult(
            success: true,
            progress: progress,
            statusMessage: status,
          ));
        },
      );

      if (!completer.isCompleted) {
        completer.complete(result);
      }
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    } finally {
      timer.cancel();
    }

    return completer.future;
  }

  /// Cancel any ongoing analysis
  void cancelAnalysis() {
    _activeIsolate?.kill(priority: Isolate.immediate);
    _activeIsolate = null;
    _receivePort?.close();
    _receivePort = null;
    _isProcessing = false;
    _notifications.cancel(_progressNotificationId);
  }

  /// Dispose resources
  void dispose() {
    cancelAnalysis();
    _resultController?.close();
  }
}

/// Extension to handle background processing with notifications
extension AIMenuServiceBackground on AIMenuService {
  /// Analyze with background support and notifications
  Future<MenuAnalysisResult> analyzeWithNotifications({
    required List<Uint8List> images,
    Function(String status, double progress)? onProgress,
  }) async {
    final notifications = NotificationService();
    await notifications.initialize();
    
    const progressId = 1001;
    
    try {
      // Show initial notification
      await notifications.showProgress(
        id: progressId,
        title: 'Analyzing Menu',
        body: 'Starting analysis...',
        progress: 0,
        maxProgress: 100,
      );

      final result = await analyzeMenuImages(
        images: images,
        onProgress: (status, progress) async {
          // Update notification
          await notifications.showProgress(
            id: progressId,
            title: 'Analyzing Menu',
            body: status,
            progress: (progress * 100).toInt(),
            maxProgress: 100,
          );
          
          // Also call the original callback
          onProgress?.call(status, progress);
        },
      );

      // Cancel progress and show complete
      await notifications.cancel(progressId);
      await notifications.showAIMenuComplete(
        title: 'Menu Analysis Complete! ✓',
        body: 'Found ${result.totalItems} items in ${result.totalCategories} categories',
      );

      return result;
    } catch (e) {
      await notifications.cancel(progressId);
      await notifications.showAIMenuComplete(
        title: 'Menu Analysis Failed',
        body: e.toString(),
      );
      rethrow;
    }
  }
}
