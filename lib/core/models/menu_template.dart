/// Model for saved menu templates
class MenuTemplate {
  final String id;
  final String restaurantId;
  final String name;
  final String? description;
  final String? detectedLanguage;
  final String? detectedLanguageName;
  final String? currency;
  final Map<String, dynamic> templateData;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuTemplate({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.description,
    this.detectedLanguage,
    this.detectedLanguageName,
    this.currency,
    required this.templateData,
    this.isActive = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuTemplate.fromJson(Map<String, dynamic> json) {
    return MenuTemplate(
      id: json['id'] as String? ?? '',
      restaurantId: json['restaurant_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      detectedLanguage: json['detected_language'] as String?,
      detectedLanguageName: json['detected_language_name'] as String?,
      currency: json['currency'] as String?,
      templateData: (json['template_data'] as Map<String, dynamic>?) ?? {},
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurant_id': restaurantId,
        'name': name,
        'description': description,
        'detected_language': detectedLanguage,
        'detected_language_name': detectedLanguageName,
        'currency': currency,
        'template_data': templateData,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  /// Get the number of items in this template
  int get itemCount {
    final items = templateData['items'] as List?;
    return items?.length ?? 0;
  }

  /// Get the number of categories in this template
  int get categoryCount {
    final categories = templateData['categories'] as List?;
    return categories?.length ?? 0;
  }

  MenuTemplate copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    String? detectedLanguage,
    String? detectedLanguageName,
    String? currency,
    Map<String, dynamic>? templateData,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuTemplate(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      detectedLanguageName: detectedLanguageName ?? this.detectedLanguageName,
      currency: currency ?? this.currency,
      templateData: templateData ?? this.templateData,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
