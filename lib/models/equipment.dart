class Equipment {
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic thumbImage;

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbImage,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      thumbImage: json['thumbImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbImage': thumbImage,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Equipment) return false;
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
