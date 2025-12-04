import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ai_image_service.dart';
import 'menu_service.dart';
import 'notification_service.dart';

/// Represents an AI image generation job
class AIImageJob {
  final String id;
  final String menuItemId;
  final String dishName;
  final String? description;
  final String referenceImageBase64;
  final AIImageJobStatus status;
  final String? error;
  final String? generatedImageBase64;
  final DateTime createdAt;
  final DateTime? completedAt;

  const AIImageJob({
    required this.id,
    required this.menuItemId,
    required this.dishName,
    this.description,
    required this.referenceImageBase64,
    required this.status,
    this.error,
    this.generatedImageBase64,
    required this.createdAt,
    this.completedAt,
  });

  AIImageJob copyWith({
    AIImageJobStatus? status,
    String? error,
    String? generatedImageBase64,
    DateTime? completedAt,
  }) {
    return AIImageJob(
      id: id,
      menuItemId: menuItemId,
      dishName: dishName,
      description: description,
      referenceImageBase64: referenceImageBase64,
      status: status ?? this.status,
      error: error ?? this.error,
      generatedImageBase64: generatedImageBase64 ?? this.generatedImageBase64,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

enum AIImageJobStatus {
  pending,
  processing,
  completed,
  failed,
}

/// Service for managing background AI image generation with auto-save
class BackgroundAIImageService {
  static final BackgroundAIImageService _instance = BackgroundAIImageService._internal();
  factory BackgroundAIImageService() => _instance;
  BackgroundAIImageService._internal();

  final NotificationService _notifications = NotificationService();
  final AIImageService _aiService = AIImageService();
  final MenuService _menuService = MenuService();
  
  // Active jobs tracking
  final Map<String, AIImageJob> _activeJobs = {};
  final _jobController = StreamController<Map<String, AIImageJob>>.broadcast();
  
  static const int _baseNotificationId = 2000;
  int _notificationCounter = 0;

  /// Stream of all active jobs
  Stream<Map<String, AIImageJob>> get jobsStream => _jobController.stream;
  
  /// Get all active jobs
  Map<String, AIImageJob> get activeJobs => Map.unmodifiable(_activeJobs);

  /// Check if a specific menu item has an active job
  bool hasActiveJob(String menuItemId) {
    return _activeJobs.values.any(
      (job) => job.menuItemId == menuItemId && 
               (job.status == AIImageJobStatus.pending || 
                job.status == AIImageJobStatus.processing)
    );
  }

  /// Get the active job for a menu item
  AIImageJob? getActiveJob(String menuItemId) {
    try {
      return _activeJobs.values.firstWhere(
        (job) => job.menuItemId == menuItemId &&
                 (job.status == AIImageJobStatus.pending ||
                  job.status == AIImageJobStatus.processing)
      );
    } catch (e) {
      return null;
    }
  }

  /// Start an AI image generation job
  /// 
  /// This will:
  /// 1. Create a job and start processing
  /// 2. Continue even if the UI is closed
  /// 3. Show notifications for progress
  /// 4. Auto-save the generated image to the database
  /// 
  /// [menuItemId] - The menu item to generate image for
  /// [dishNameEnglish] - The dish name in ENGLISH (always use English for AI)
  /// [descriptionEnglish] - The description in ENGLISH (always use English for AI)
  /// [referenceImageBase64] - The original image as base64 data URI
  Future<String> startGenerationJob({
    required String menuItemId,
    required String dishNameEnglish,
    String? descriptionEnglish,
    required String referenceImageBase64,
  }) async {
    await _notifications.initialize();
    
    final jobId = '${menuItemId}_${DateTime.now().millisecondsSinceEpoch}';
    final notificationId = _baseNotificationId + (_notificationCounter++ % 100);
    
    final job = AIImageJob(
      id: jobId,
      menuItemId: menuItemId,
      dishName: dishNameEnglish,
      description: descriptionEnglish,
      referenceImageBase64: referenceImageBase64,
      status: AIImageJobStatus.pending,
      createdAt: DateTime.now(),
    );
    
    _activeJobs[jobId] = job;
    _jobController.add(_activeJobs);
    
    // Show initial notification
    await _notifications.showProgress(
      id: notificationId,
      title: 'Generating AI Image',
      body: 'Processing "$dishNameEnglish"...',
      progress: 20,
      maxProgress: 100,
    );
    
    // Start the generation in background (don't await)
    _processJob(jobId, notificationId);
    
    return jobId;
  }

  Future<void> _processJob(String jobId, int notificationId) async {
    final job = _activeJobs[jobId];
    if (job == null) return;
    
    // Update status to processing
    _activeJobs[jobId] = job.copyWith(status: AIImageJobStatus.processing);
    _jobController.add(_activeJobs);
    
    try {
      // Update notification
      await _notifications.showProgress(
        id: notificationId,
        title: 'Generating AI Image',
        body: 'Creating professional photo of "${job.dishName}"...',
        progress: 50,
        maxProgress: 100,
      );
      
      // Generate the image using AI service
      final generatedImage = await _aiService.generateFoodImage(
        referenceImageBase64: job.referenceImageBase64,
        dishName: job.dishName,
        description: job.description,
      );
      
      if (generatedImage != null) {
        // Update notification
        await _notifications.showProgress(
          id: notificationId,
          title: 'Saving AI Image',
          body: 'Saving "${job.dishName}" to database...',
          progress: 90,
          maxProgress: 100,
        );
        
        // *** AUTO-SAVE: Immediately save to database ***
        await _menuService.addAiGeneratedImage(
          itemId: job.menuItemId,
          imageBase64: generatedImage,
        );
        
        // Update job as completed
        _activeJobs[jobId] = job.copyWith(
          status: AIImageJobStatus.completed,
          generatedImageBase64: generatedImage,
          completedAt: DateTime.now(),
        );
        _jobController.add(_activeJobs);
        
        // Cancel progress notification and show success
        await _notifications.cancel(notificationId);
        await _notifications.showAIImageComplete(
          title: 'AI Image Ready! ✓',
          body: '"${job.dishName}" - Professional photo saved',
          payload: 'ai_image_complete:${job.menuItemId}',
        );
        
        debugPrint('AI Image generated and saved for ${job.menuItemId}');
      } else {
        throw Exception('Failed to generate image - no result returned');
      }
    } catch (e) {
      debugPrint('AI Image generation failed: $e');
      
      // Update job as failed
      _activeJobs[jobId] = job.copyWith(
        status: AIImageJobStatus.failed,
        error: e.toString(),
        completedAt: DateTime.now(),
      );
      _jobController.add(_activeJobs);
      
      // Cancel progress notification and show error
      await _notifications.cancel(notificationId);
      await _notifications.showAIImageComplete(
        title: 'AI Image Failed',
        body: '"${job.dishName}" - ${_shortenError(e.toString())}',
        payload: 'ai_image_error:${job.menuItemId}',
      );
    }
    
    // Clean up completed/failed jobs after a delay
    Future.delayed(const Duration(minutes: 5), () {
      _activeJobs.remove(jobId);
      _jobController.add(_activeJobs);
    });
  }

  String _shortenError(String error) {
    if (error.length > 50) {
      return '${error.substring(0, 50)}...';
    }
    return error;
  }

  /// Cancel an active job
  void cancelJob(String jobId) {
    final job = _activeJobs[jobId];
    if (job != null && 
        (job.status == AIImageJobStatus.pending || 
         job.status == AIImageJobStatus.processing)) {
      _activeJobs[jobId] = job.copyWith(
        status: AIImageJobStatus.failed,
        error: 'Cancelled by user',
        completedAt: DateTime.now(),
      );
      _jobController.add(_activeJobs);
    }
  }

  /// Dispose resources
  void dispose() {
    _jobController.close();
  }
}

/// Provider for BackgroundAIImageService
final backgroundAIImageServiceProvider = Provider<BackgroundAIImageService>((ref) {
  return BackgroundAIImageService();
});

/// Provider for watching active jobs for a specific menu item
final activeAIImageJobProvider = StreamProvider.family<AIImageJob?, String>((ref, menuItemId) {
  final service = ref.watch(backgroundAIImageServiceProvider);
  
  return service.jobsStream.map((jobs) {
    try {
      return jobs.values.firstWhere(
        (job) => job.menuItemId == menuItemId &&
                 (job.status == AIImageJobStatus.pending ||
                  job.status == AIImageJobStatus.processing)
      );
    } catch (e) {
      return null;
    }
  });
});

/// Provider for checking if generation is in progress for a menu item
final isGeneratingAIImageProvider = Provider.family<bool, String>((ref, menuItemId) {
  final service = ref.watch(backgroundAIImageServiceProvider);
  return service.hasActiveJob(menuItemId);
});
