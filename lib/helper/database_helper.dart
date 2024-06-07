import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/exercise.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/workout.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../providers/workout_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "workout.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts (
        name TEXT PRIMARY KEY,
        exercises TEXT
      )
    ''');
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await database;
    try {
      await db?.insert(
        'workouts',
        workout.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting workout: $e');
      rethrow;
    }
  }

  Future getAllWorkouts(BuildContext context) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('workouts');
    var list = List.generate(maps.length, (i) {
      return Workout(
        name: maps[i]['name'],
        exerciseList: _parseExercises(maps[i]['exercises']),
      );
    });
    Provider.of<WorkoutProvider>(context, listen: false)
        .refreshAllWorkOut(list);
  }

  List<Exercise> _parseExercises(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((e) => Exercise.fromJson(e)).toList();
  }

  Future<void> deleteWorkout(String name) async {
    final db = await database;
    try {
      await db?.delete(
        'workouts',
        where: 'name = ?',
        whereArgs: [name],
      );
    } catch (e) {
      print('Error deleting workout: $e');
      rethrow;
    }
  }

  Future<Workout?> getWorkoutByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'workouts',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Workout(
        name: maps.first['name'],
        exerciseList: _parseExercises(maps.first['exercises']),
      );
    }

    return null;
  }

  Future<void> updateWorkout(Workout workout) async {
    log("----workout-----${workout.toMap()}");
    final db = await database;
    try {
      await db?.update(
        'workouts',
        workout.toMap(),
        where: 'name = ?',
        whereArgs: [workout.name],
      );
    } catch (e) {
      print('Error updating workout: $e');
      rethrow;
    }
  }

  Future<void> updateWorkoutName(Workout workout, String newWorkoutName) async {
  log("----workout-----${workout.toMap()}");
  final db = await database;
  try {
    await db?.update(
      'workouts',
      {'name': newWorkoutName}, // Update only the name field
      where: 'name = ?', // Find the workout by its current name
      whereArgs: [workout.name], // Pass the current name as whereArgs
    );
  } catch (e) {
    print('Error updating workout: $e');
    rethrow;
  }
}
}
