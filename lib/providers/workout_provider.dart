import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/workout.dart';
import '../models/exercise.dart';
import '../models/equipment.dart';
import '../models/muscle.dart';

class WorkoutProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  List<Exercise> _selectedExercises = [];
  List<Exercise> _finalExercises = [];
  List<Muscle> _selectedMuscles = [];
  List<Muscle> _allMuscles = [];
  List<Muscle> _finalMuscles = [];
  List<Equipment> _selectedEquipment = [];
  List<Equipment> _allEquipment = [];
  List<Equipment> _finalEquipment = [];
  List<Workout> _allWorkout = [];
  int _currentIndex = 2;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    filterExercises();
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  List<Exercise> get exercises => _filteredExercises;
  List<Exercise> get finalExercises => _finalExercises;
  List<Exercise> get selectedExercises => _selectedExercises;
  List<Muscle> get selectedMuscles => _selectedMuscles;
  List<Muscle> get finalMuscles => _finalMuscles;
  List<Equipment> get selectedEquipment => _selectedEquipment;
  List<Equipment> get finalEquipment => _finalEquipment;
  List<Equipment> get allEquipment => _allEquipment;
  List<Muscle> get allMuscles => _allMuscles;
  List<Workout> get allWorkout => _allWorkout;

  void refreshAllWorkOut(List<Workout> list) {
    _allWorkout = list;
    notifyListeners();
  }

  void clearFilters() {
    _selectedEquipment.clear();
    _selectedMuscles.clear();
    _searchQuery = '';
    filterExercises();
    notifyListeners();
  }

  void refreshExercies(List<Exercise> list) {
    if (list.isEmpty) {
      _finalExercises.clear();
    } else {
      _finalExercises = list;
    }
    // notifyListeners();
  }

  void refreshMuscle(List<Muscle> list) {
    if (list.isEmpty) {
      _selectedMuscles.clear();
    } else {
      _finalMuscles = list;
    }
    notifyListeners();
  }

  void refreshEquipment(List<Equipment> list) {
    if (list.isEmpty) {
      _selectedEquipment.clear();
    } else {
      _finalEquipment = list;
    }
    notifyListeners();
  }

  Muscle dummyMuscle = Muscle(
    id: "id",
    name: "All Groups",
    description: "description",
    utilityPercentage: 0,
    referenceId: "referenceId",
    thumbImage: "thumbImage",
  );

  Equipment dummyEquipment = Equipment(
    id: "id",
    name: "All equipment",
    description: "description",
    thumbImage: "thumbImage",
  );

  Future<void> loadExercises() async {
    _selectedEquipment.clear();
    _selectedMuscles.clear();
    final jsonFile = await rootBundle.loadString('assets/exercise_data.json');
    final jsonData = jsonDecode(jsonFile);
    final exercisesData = jsonData['entity']['data'] as List;
    log('----exercises----${exercisesData.length}');
    _exercises = exercisesData
        .map((exerciseData) => Exercise.fromJson(exerciseData))
        .toList();
    _filteredExercises = List.from(_exercises);
    log('----_exercises----${_exercises.length}');
    loadMuscles();
    loadEquipment();
    filterExercises();

    notifyListeners();
  }

  void filterExercises() {
    _filteredExercises = _exercises.where((exercise) {
      bool matchesQuery = _searchQuery.isEmpty ||
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesEquipment = _selectedEquipment.contains(dummyEquipment) ||
          _selectedEquipment.isEmpty ||
          _selectedEquipment
              .any((equipment) => exercise.equipments.contains(equipment));

      bool matchesMainMuscles = _selectedMuscles.contains(dummyMuscle) ||
          _selectedMuscles.isEmpty ||
          _selectedMuscles
              .any((muscle) => exercise.mainMuscles.contains(muscle));

      bool matchesSecondaryMuscles = _selectedMuscles.contains(dummyMuscle) ||
          _selectedMuscles.isEmpty ||
          _selectedMuscles
              .any((muscle) => exercise.secondaryMuscles.contains(muscle));

      return matchesQuery &&
          matchesEquipment &&
          matchesMainMuscles &&
          matchesSecondaryMuscles;
    }).toList();
    notifyListeners();
  }

  void loadMuscles() {
    final Set<Muscle> uniqueMuscles = {};
    _allMuscles.clear();
    for (var exercise in _exercises) {
      uniqueMuscles.addAll(exercise.mainMuscles);
      uniqueMuscles.addAll(exercise.secondaryMuscles);
    }
    // Convert the set to a list and sort it alphabetically by the muscle name
    _allMuscles = uniqueMuscles.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    _allMuscles.insert(0, dummyMuscle);
    if (_allMuscles.isNotEmpty) {
      log("---_allMuscles---${_allMuscles.first.name}");
    } else {
      log("---_allMuscles is empty---");
    }
  }

  void loadEquipment() {
    final Set<Equipment> uniqueEquipment = {};
    _allEquipment.clear();
    for (var exercise in _exercises) {
      uniqueEquipment.addAll(exercise.equipments);
    }
    // Convert the set to a list and sort it alphabetically by the muscle name
    _allEquipment = uniqueEquipment.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    _allEquipment.insert(0, dummyEquipment);
    if (_allEquipment.isNotEmpty) {
      log("---_allEquipment---${_allEquipment.first.name}");
    } else {
      log("---_allEquipment is empty---");
    }
  }

  void setSelectedEquipments(List<Equipment> equipments) {
    _selectedEquipment = equipments;
    filterExercises();
    notifyListeners();
  }

  void setSelectedMuscles(List<Muscle> muscles) {
    _selectedMuscles = muscles;
    filterExercises();
    notifyListeners();
  }

 
}
