class SetModel {
  dynamic reps;
  dynamic weight;

  SetModel({required this.reps, required this.weight}) {
    this.reps = reps ?? '';
    this.weight = weight ?? '';
  }

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      reps: json['reps'] ?? '',
      weight: json['weight'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }
}
