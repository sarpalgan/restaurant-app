import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/pending_ai_menu_result.dart';
import 'ai_menu_service.dart';
import 'notification_service.dart';

/// Service for managing background AI menu analysis
/// 
/// This allows users to start menu analysis and continue using the app
/// while the AI processes the images. A notification is shown when complete.
class BackgroundAIMenuService {
  static final BackgroundAIMenuService _instance = BackgroundAIMenuService._internal();
  factory BackgroundAIMenuService() => _instance;
  BackgroundAIMenuService._internal();

  final NotificationService _notifications = NotificationService();
  final AIMenuService _aiMenuService = AIMenuService();
  
  // Active jobs tracking
  final Map<String, _AIMenuJob> _activeJobs = {};
  final _jobController = StreamController<Map<String, _AIMenuJob>>.broadcast();
  
  // Callback to update provider (set by the provider)
  void Function(PendingAIMenuResult)? onResultReady;
  
  static const int _baseNotificationId = 3000;
  int _notificationCounter = 0;

  /// Stream of all active jobs
  Stream<Map<String, _AIMenuJob>> get jobsStream => _jobController.stream;
  
  /// Get all active jobs
  Map<String, _AIMenuJob> get activeJobs => Map.unmodifiable(_activeJobs);

  /// Check if there's an active job for a restaurant
  bool hasActiveJob(String restaurantId) {
    return _activeJobs.values.any(
      (job) => job.restaurantId == restaurantId && 
               (job.status == _AIMenuJobStatus.pending || 
                job.status == _AIMenuJobStatus.processing)
    );
  }

  /// Get the active job for a restaurant
  _AIMenuJob? getActiveJob(String restaurantId) {
    try {
      return _activeJobs.values.firstWhere(
        (job) => job.restaurantId == restaurantId &&
                 (job.status == _AIMenuJobStatus.pending ||
                  job.status == _AIMenuJobStatus.processing)
      );
    } catch (e) {
      return null;
    }
  }

  /// Get active job count
  int get activeJobCount => _activeJobs.values.where(
    (job) => job.status == _AIMenuJobStatus.pending || 
             job.status == _AIMenuJobStatus.processing
  ).length;

  /// Start an AI menu analysis job
  /// 
  /// This will:
  /// 1. Create a job and start processing in background
  /// 2. Continue even if the UI is navigated away
  /// 3. Show notifications for progress and completion
  /// 4. Store the result for later viewing/import
  /// 
  /// Returns the job ID
  Future<String> startAnalysisJob({
    required String restaurantId,
    required List<Uint8List> images,
    required int imageCount,
  }) async {
    await _notifications.initialize();
    
    final jobId = '${restaurantId}_${DateTime.now().millisecondsSinceEpoch}';
    final notificationId = _baseNotificationId + (_notificationCounter++ % 100);
    
    final job = _AIMenuJob(
      id: jobId,
      restaurantId: restaurantId,
      imageCount: imageCount,
      status: _AIMenuJobStatus.pending,
      createdAt: DateTime.now(),
    );
    
    _activeJobs[jobId] = job;
    _jobController.add(_activeJobs);
    
    // Show initial notification
    await _notifications.showProgress(
      id: notificationId,
      title: 'Analyzing Menu',
      body: 'Processing $imageCount image${imageCount > 1 ? "s" : ""}...',
      progress: 10,
      maxProgress: 100,
    );
    
    // Start the analysis in background (don't await)
    _processJob(jobId, notificationId, images);
    
    return jobId;
  }

  Future<void> _processJob(
    String jobId, 
    int notificationId, 
    List<Uint8List> images,
  ) async {
    final job = _activeJobs[jobId];
    if (job == null) return;
    
    // Update status to processing
    _activeJobs[jobId] = job.copyWith(status: _AIMenuJobStatus.processing);
    _jobController.add(_activeJobs);
    
    String lastProgressMessage = 'Analyzing menu...';
    
    try {
      // Analyze the menu images
      final result = await _aiMenuService.analyzeMenuImages(
        images: images,
        onProgress: (status, progress) async {
          lastProgressMessage = status;
          final progressInt = (progress * 100).round();
          await _notifications.showProgress(
            id: notificationId,
            title: 'Analyzing Menu',
            body: status,
            progress: progressInt.clamp(10, 95),
            maxProgress: 100,
          );
        },
      );
      
      // Create pending result
      final pendingResult = PendingAIMenuResult.fromAnalysisResult(
        id: jobId,
        restaurantId: job.restaurantId,
        analysisResult: result,
      );
      
      // Update job as completed
      _activeJobs[jobId] = job.copyWith(
        status: _AIMenuJobStatus.completed,
        result: pendingResult,
        completedAt: DateTime.now(),
      );
      _jobController.add(_activeJobs);
      
      // Notify provider (if callback is set)
      onResultReady?.call(pendingResult);
      
      // Cancel progress notification and show success
      await _notifications.cancel(notificationId);
      await _notifications.showAIMenuComplete(
        title: 'Menu Analysis Complete! ✓',
        body: 'Found ${result.totalCategories} categories and ${result.totalItems} items. Tap to view.',
        payload: 'ai_menu_complete:$jobId',
      );
      
      debugPrint('AI Menu analysis completed: ${result.totalCategories} categories, ${result.totalItems} items');
    } catch (e) {
      debugPrint('AI Menu analysis failed: $e');
      
      // Create failed pending result
      final failedResult = PendingAIMenuResult.failed(
        id: jobId,
        restaurantId: job.restaurantId,
        error: e.toString(),
      );
      
      // Update job as failed
      _activeJobs[jobId] = job.copyWith(
        status: _AIMenuJobStatus.failed,
        error: e.toString(),
        result: failedResult,
        completedAt: DateTime.now(),
      );
      _jobController.add(_activeJobs);
      
      // Notify provider (if callback is set)
      onResultReady?.call(failedResult);
      
      // Cancel progress notification and show error
      await _notifications.cancel(notificationId);
      await _notifications.showAIMenuComplete(
        title: 'Menu Analysis Failed',
        body: _shortenError(e.toString()),
        payload: 'ai_menu_error:$jobId',
      );
    }
    
    // Clean up completed/failed jobs after a delay
    Future.delayed(const Duration(minutes: 10), () {
      if (_activeJobs.containsKey(jobId)) {
        _activeJobs.remove(jobId);
        _jobController.add(_activeJobs);
      }
    });
  }
  
  String _shortenError(String error) {
    if (error.length > 50) {
      return '${error.substring(0, 47)}...';
    }
    return error;
  }

  /// Cancel all jobs for a restaurant
  void cancelJobs(String restaurantId) {
    final jobsToCancel = _activeJobs.values
        .where((job) => job.restaurantId == restaurantId)
        .toList();
    
    for (final job in jobsToCancel) {
      _activeJobs.remove(job.id);
    }
    _jobController.add(_activeJobs);
  }

  /// Clear a specific job
  void clearJob(String jobId) {
    _activeJobs.remove(jobId);
    _jobController.add(_activeJobs);
  }

  /// Dispose
  void dispose() {
    _jobController.close();
  }
}

/// Internal job status
enum _AIMenuJobStatus {
  pending,
  processing,
  completed,
  failed,
}

/// Internal job representation
class _AIMenuJob {
  final String id;
  final String restaurantId;
  final int imageCount;
  final _AIMenuJobStatus status;
  final String? error;
  final PendingAIMenuResult? result;
  final DateTime createdAt;
  final DateTime? completedAt;

  const _AIMenuJob({
    required this.id,
    required this.restaurantId,
    required this.imageCount,
    required this.status,
    this.error,
    this.result,
    required this.createdAt,
    this.completedAt,
  });

  _AIMenuJob copyWith({
    _AIMenuJobStatus? status,
    String? error,
    PendingAIMenuResult? result,
    DateTime? completedAt,
  }) {
    return _AIMenuJob(
      id: id,
      restaurantId: restaurantId,
      imageCount: imageCount,
      status: status ?? this.status,
      error: error ?? this.error,
      result: result ?? this.result,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Provider for the background AI menu service
final backgroundAIMenuServiceProvider = Provider<BackgroundAIMenuService>((ref) {
  return BackgroundAIMenuService();
});

/// Provider to check if there's an active job for a restaurant
final hasActiveAIMenuJobProvider = Provider.family<bool, String>((ref, restaurantId) {
  final service = ref.watch(backgroundAIMenuServiceProvider);
  return service.hasActiveJob(restaurantId);
});

/// Provider for active job count
final activeAIMenuJobCountProvider = Provider<int>((ref) {
  final service = ref.watch(backgroundAIMenuServiceProvider);
  return service.activeJobCount;
});
