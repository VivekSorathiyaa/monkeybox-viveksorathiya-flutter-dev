class Category {
  final dynamic id;
  final dynamic name;
  final dynamic referenceId;
  final dynamic thumbImage;

  Category({
    required this.id,
    required this.name,
    required this.referenceId,
    required this.thumbImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      referenceId: json['referenceId'] ?? '',
      thumbImage: json['thumbImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'referenceId': referenceId,
      'thumbImage': thumbImage,
    };
  }
}
