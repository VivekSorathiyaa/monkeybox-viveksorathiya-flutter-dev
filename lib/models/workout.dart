import 'dart:convert';
import 'exercise.dart'; // Adjust based on your actual file structure

class Workout {
  final List<Exercise> exerciseList;
  String name;

  Workout({
    required this.exerciseList,
    required this.name,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      exerciseList: (json['exerciseList'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exercises': jsonEncode(exerciseList.map((e) => e.toMap()).toList()), // Convert exerciseList to JSON string
      'name': name,
    };
  }
}
