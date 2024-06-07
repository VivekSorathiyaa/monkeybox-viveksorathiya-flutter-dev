class Muscle {
  final String id;
  final String name;
  final String description;
  final dynamic utilityPercentage;
  final String referenceId;
  final String thumbImage;

  Muscle({
    required this.id,
    required this.name,
    required this.description,
    required this.utilityPercentage,
    required this.referenceId,
    required this.thumbImage,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      utilityPercentage: json['utilityPercentage'] ?? '',
      referenceId: json['referenceId'] ?? '',
      thumbImage: json['thumbImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'utilityPercentage': utilityPercentage,
      'referenceId': referenceId,
      'thumbImage': thumbImage,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Muscle) return false;
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
