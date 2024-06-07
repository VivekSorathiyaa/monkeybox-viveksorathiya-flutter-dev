import 'package:monkeybox_viveksorathiya_flutter_dev/models/set_model.dart';

import 'equipment.dart';
import 'muscle.dart';
import 'category.dart';

class Exercise {
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic thumbImage;
  final dynamic level;
  final List<Equipment> equipments;
  final List<Muscle> mainMuscles;
  final List<Muscle> secondaryMuscles;
  final List<Category> categories;
  final List<SetModel> setList;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbImage,
    required this.level,
    required this.equipments,
    required this.mainMuscles,
    required this.secondaryMuscles,
    required this.categories,
    List<SetModel>? setList,
  }) : setList = setList == null || setList.isEmpty
            ? [SetModel(reps: '', weight: '')]
            : setList;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      level: json['level'] ?? '',
      thumbImage: json['thumbImage'] ?? '',
      description: json['description'] ?? '',
      equipments: (json['equipments'] as List? ?? [])
          .map((e) => Equipment.fromJson(e ?? {}))
          .toList(),
      mainMuscles: (json['mainMuscles'] as List? ?? [])
          .map((m) => Muscle.fromJson(m ?? {}))
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List? ?? [])
          .map((m) => Muscle.fromJson(m ?? {}))
          .toList(),
      categories: (json['categories'] as List? ?? [])
          .map((c) => Category.fromJson(c ?? {}))
          .toList(),
      setList: (json['setList'] as List? ?? [])
          .map((c) => SetModel.fromJson(c ?? {}))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'thumbImage': thumbImage,
      'equipments': equipments.map((equipment) => equipment.toMap()).toList(),
      'mainMuscles': mainMuscles.map((muscle) => muscle.toMap()).toList(),
      'secondaryMuscles':
          secondaryMuscles.map((muscle) => muscle.toMap()).toList(),
      'categories': categories.map((category) => category.toMap()).toList(),
      'setList': setList.map((setLists) => setLists.toMap()).toList(),
    };
  }
}
