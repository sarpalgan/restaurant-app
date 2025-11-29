import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';

/// Service for generating AI videos using Kie.ai Veo 3.1 API
/// Falls back to mock mode when API key is not configured
class VideoGenerationService {
  static const String _baseUrl = 'https://api.kie.ai/api/v1/veo';
  
  // Sample food videos for demo mode
  static const List<String> _mockVideos = [
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
  ];
  
  bool get _useMockMode {
    final apiKey = AppConfig.kieApiKey;
    return apiKey.isEmpty;
  }
  
  /// Generate a video from an image
  /// 
  /// [imageUrl] - URL of the source image
  /// [prompt] - Optional text prompt to guide video generation
  /// [model] - 'veo3' for higher quality or 'veo3_fast' for faster generation
  /// [duration] - Duration in seconds (5-10)
  /// [aspectRatio] - '16:9', '9:16', or '1:1'
  Future<VideoGenerationResult> generateVideoFromImage({
    required String imageUrl,
    String? prompt,
    String model = 'veo3',
    int duration = 5,
    String aspectRatio = '16:9',
  }) async {
    // Use mock mode if API key not configured
    if (_useMockMode) {
      debugPrint('VideoGenerationService: Using mock mode (API key not configured)');
      final mockTaskId = 'mock_${DateTime.now().millisecondsSinceEpoch}';
      return VideoGenerationResult(
        taskId: mockTaskId,
        status: 'processing',
      );
    }

    final apiKey = AppConfig.kieApiKey;
    final response = await http.post(
      Uri.parse('$_baseUrl/generate'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'image_url': imageUrl,
        'prompt': prompt ?? 'Create a captivating short video showcasing this delicious dish with subtle motion and appetizing presentation',
        'model': model,
        'duration': duration,
        'aspect_ratio': aspectRatio,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return VideoGenerationResult(
        taskId: data['task_id'],
        status: 'processing',
      );
    } else {
      throw Exception('Failed to start video generation: ${response.body}');
    }
  }

  /// Check the status of a video generation task
  Future<VideoGenerationStatus> checkStatus(String taskId) async {
    // Mock mode - simulate progress and return a sample video
    if (taskId.startsWith('mock_')) {
      final createdAt = int.tryParse(taskId.split('_').last) ?? 0;
      final elapsed = DateTime.now().millisecondsSinceEpoch - createdAt;
      final progress = (elapsed / 3000).clamp(0.0, 1.0); // 3 seconds to complete
      
      if (progress >= 1.0) {
        final randomVideo = _mockVideos[Random().nextInt(_mockVideos.length)];
        return VideoGenerationStatus(
          taskId: taskId,
          status: 'completed',
          progress: 1.0,
          videoUrl: randomVideo,
          error: null,
        );
      }
      
      return VideoGenerationStatus(
        taskId: taskId,
        status: 'processing',
        progress: progress,
        videoUrl: null,
        error: null,
      );
    }

    final apiKey = AppConfig.kieApiKey;
    final response = await http.get(
      Uri.parse('$_baseUrl/status/$taskId'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return VideoGenerationStatus(
        taskId: taskId,
        status: data['status'],
        progress: data['progress']?.toDouble() ?? 0,
        videoUrl: data['video_url'],
        error: data['error'],
      );
    } else {
      throw Exception('Failed to check video status: ${response.body}');
    }
  }

  /// Generate video and poll for completion
  /// Returns the final video URL when complete
  Future<String> generateVideoAndWait({
    required String imageUrl,
    String? prompt,
    String model = 'veo3',
    Duration timeout = const Duration(minutes: 5),
    Function(double progress)? onProgress,
  }) async {
    final result = await generateVideoFromImage(
      imageUrl: imageUrl,
      prompt: prompt,
      model: model,
    );

    final startTime = DateTime.now();
    
    while (DateTime.now().difference(startTime) < timeout) {
      await Future.delayed(const Duration(milliseconds: 500)); // Faster polling for mock
      
      final status = await checkStatus(result.taskId);
      
      if (onProgress != null) {
        onProgress(status.progress);
      }
      
      if (status.status == 'completed' && status.videoUrl != null) {
        return status.videoUrl!;
      }
      
      if (status.status == 'failed') {
        throw Exception('Video generation failed: ${status.error}');
      }
    }
    
    throw Exception('Video generation timed out');
  }
}

class VideoGenerationResult {
  final String taskId;
  final String status;

  VideoGenerationResult({
    required this.taskId,
    required this.status,
  });
}

class VideoGenerationStatus {
  final String taskId;
  final String status;
  final double progress;
  final String? videoUrl;
  final String? error;

  VideoGenerationStatus({
    required this.taskId,
    required this.status,
    required this.progress,
    this.videoUrl,
    this.error,
  });

  bool get isComplete => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isProcessing => status == 'processing';
}
