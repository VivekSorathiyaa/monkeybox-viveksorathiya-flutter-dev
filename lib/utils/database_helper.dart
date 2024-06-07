import 'dart:convert';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/category.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/equipment.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/muscle.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/exercise.dart';

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
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        equipments TEXT,
        mainMuscles TEXT,
        secondaryMuscles TEXT,
        categories TEXT
      )
    ''');
    // Create tables for equipments, muscles, categories as needed.
  }

  Future<void> insertExercise(Exercise exercise) async {
    final db = await database;
    await db?.insert(
      'exercises',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('exercises');
    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'],
        name: maps[i]['name'],
        level: maps[i]['level'],
        thumbImage: maps[i]['thumbImage'],
        description: maps[i]['description'],
        equipments: _parseEquipments(maps[i]['equipments']),
        mainMuscles: _parseMuscles(maps[i]['mainMuscles']),
        secondaryMuscles: _parseMuscles(maps[i]['secondaryMuscles']),
        categories: _parseCategories(maps[i]['categories']),
      );
    });
  }

  List<Equipment> _parseEquipments(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((e) => Equipment.fromJson(e)).toList();
  }

  List<Muscle> _parseMuscles(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((m) => Muscle.fromJson(m)).toList();
  }

  List<Category> _parseCategories(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((c) => Category.fromJson(c)).toList();
  }

  Future<void> deleteExercise(String id) async {
    final db = await database;
    await db?.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await database;
    await db?.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }
}
