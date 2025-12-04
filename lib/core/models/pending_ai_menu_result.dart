import '../../services/ai_menu_service.dart';

/// Pending AI menu generation result
class PendingAIMenuResult {
  final String id;
  final String restaurantId;
  final DateTime createdAt;
  final MenuAnalysisResult result;
  final List<int> selectedItemIndices;
  final AIMenuResultStatus status;
  final String? errorMessage;

  const PendingAIMenuResult({
    required this.id,
    required this.restaurantId,
    required this.createdAt,
    required this.result,
    this.selectedItemIndices = const [],
    this.status = AIMenuResultStatus.pending,
    this.errorMessage,
  });

  /// Convenience getters to access result data
  String get detectedLanguage => result.detectedLanguage;
  String get detectedLanguageName => result.detectedLanguageName;
  String? get currency => result.currency;
  String? get restaurantName => result.restaurantName;
  List<DetectedCategory> get categories => result.categories;
  List<DetectedMenuItem> get items => result.items;

  PendingAIMenuResult copyWith({
    String? id,
    String? restaurantId,
    DateTime? createdAt,
    MenuAnalysisResult? result,
    List<int>? selectedItemIndices,
    AIMenuResultStatus? status,
    String? errorMessage,
  }) {
    return PendingAIMenuResult(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      createdAt: createdAt ?? this.createdAt,
      result: result ?? this.result,
      selectedItemIndices: selectedItemIndices ?? this.selectedItemIndices,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'createdAt': createdAt.toIso8601String(),
      'result': _resultToJson(result),
      'selectedItemIndices': selectedItemIndices,
      'status': status.name,
      'errorMessage': errorMessage,
    };
  }

  static Map<String, dynamic> _resultToJson(MenuAnalysisResult result) {
    return {
      'detectedLanguage': result.detectedLanguage,
      'detectedLanguageName': result.detectedLanguageName,
      'currency': result.currency,
      'restaurantName': result.restaurantName,
      'categories': result.categories.map((c) => {
        'name': c.name,
        'originalLanguage': c.originalLanguage,
        'translatedNames': c.translatedNames,
        'itemCount': c.itemCount,
        'sortOrder': c.sortOrder,
      }).toList(),
      'items': result.items.map((item) => item.toJson()).toList(),
    };
  }

  factory PendingAIMenuResult.fromJson(Map<String, dynamic> json) {
    return PendingAIMenuResult(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      result: _resultFromJson(json['result'] as Map<String, dynamic>),
      selectedItemIndices: (json['selectedItemIndices'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
      status: AIMenuResultStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AIMenuResultStatus.pending,
      ),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  static MenuAnalysisResult _resultFromJson(Map<String, dynamic> json) {
    final categories = (json['categories'] as List<dynamic>).map((c) {
      final catJson = c as Map<String, dynamic>;
      return DetectedCategory(
        name: catJson['name'] as String,
        originalLanguage: catJson['originalLanguage'] as String? ?? 'en',
        translatedNames: Map<String, String>.from(catJson['translatedNames'] as Map? ?? {}),
        itemCount: catJson['itemCount'] as int? ?? 0,
        sortOrder: catJson['sortOrder'] as int? ?? 0,
      );
    }).toList();

    final items = (json['items'] as List<dynamic>).map((i) {
      return DetectedMenuItem.fromJson(i as Map<String, dynamic>);
    }).toList();

    return MenuAnalysisResult(
      detectedLanguage: json['detectedLanguage'] as String,
      detectedLanguageName: json['detectedLanguageName'] as String,
      categories: categories,
      items: items,
      currency: json['currency'] as String?,
      restaurantName: json['restaurantName'] as String?,
    );
  }

  /// Create from a fresh MenuAnalysisResult
  factory PendingAIMenuResult.fromAnalysisResult({
    required String id,
    required String restaurantId,
    required MenuAnalysisResult analysisResult,
  }) {
    return PendingAIMenuResult(
      id: id,
      restaurantId: restaurantId,
      createdAt: DateTime.now(),
      result: analysisResult,
      selectedItemIndices: List.generate(analysisResult.items.length, (i) => i),
      status: AIMenuResultStatus.completed,
    );
  }

  /// Create a failed result
  factory PendingAIMenuResult.failed({
    required String id,
    required String restaurantId,
    required String error,
  }) {
    return PendingAIMenuResult(
      id: id,
      restaurantId: restaurantId,
      createdAt: DateTime.now(),
      result: MenuAnalysisResult(
        detectedLanguage: 'en',
        detectedLanguageName: 'English',
        categories: [],
        items: [],
      ),
      status: AIMenuResultStatus.failed,
      errorMessage: error,
    );
  }
}

enum AIMenuResultStatus {
  pending,    // Processing in background
  completed,  // Ready to view/import
  imported,   // Already imported to menu
  saved,      // Saved as template
  failed,     // Processing failed
  expired,    // Too old, cleaned up
}
