import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data.dart';

class DataBaseHelper {
  static const _databaseName = "eyebody.db";
  static const int _databaseVersion = 1;
  static const foodTable = "food";
  static const workoutTable = "workout";
  static const eyebodyTable = "eyebody";

  DataBaseHelper._privateConstructor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();
  late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS $foodTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  type INTEGER DEFAULT 0,
  kcal INTEGER DEFAULT 0,
  image String,
  memo String
)
''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS $workoutTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  time INTEGER DEFAULT 0,
  name String,
  image String,
  memo String
)
''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS $eyebodyTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  weight INTEGER DEFAULT 0,
  image String
)
''');
  }

  FutureOr<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {}

  Future<int> insertFood(Food food) async {
    Database db = await instance.database;

    if (food.id < 0) {
      final map = food.toMap();
      return await db.insert(foodTable, map);
    } else {
      final map = food.toMap();
      return await db.update(foodTable, map);
    }
  }

  Future<List<Food>> queryFoodByDate(int date) async {
    Database db = await instance.database;
    List<Food> foods = [];

    var query = await db.query(foodTable, where: "date = ?", whereArgs: [date]);

    for (var r in query) {
      foods.add(Food.fromDB(r));
    }

    return foods;
  }

  Future<List<Food>> queryAllFood() async {
    Database db = await instance.database;
    List<Food> foods = [];

    var query = await db.query(foodTable);

    for (var r in query) {
      foods.add(Food.fromDB(r));
    }

    return foods;
  }

  Future<int> insertWorkOut(WorkOut workout) async {
    Database db = await instance.database;

    if (workout.id < 0) {
      final map = workout.toMap();
      return await db.insert(workoutTable, map);
    } else {
      final map = workout.toMap();
      return await db.update(workoutTable, map);
    }
  }

  Future<List<WorkOut>> queryWorkOutByDate(int date) async {
    Database db = await instance.database;
    List<WorkOut> workouts = [];

    var query =
        await db.query(workoutTable, where: "date = ?", whereArgs: [date]);

    for (var r in query) {
      workouts.add(WorkOut.fromDB(r));
    }

    return workouts;
  }

  Future<List<WorkOut>> queryAllWorkOut() async {
    Database db = await instance.database;
    List<WorkOut> workouts = [];

    var query = await db.query(workoutTable);

    for (var r in query) {
      workouts.add(WorkOut.fromDB(r));
    }

    return workouts;
  }

  Future<int> insertEyeBody(EyeBody eyebody) async {
    Database db = await instance.database;

    if (eyebody.id < 0) {
      final map = eyebody.toMap();
      return await db.insert(eyebodyTable, map);
    } else {
      final map = eyebody.toMap();
      return await db.update(eyebodyTable, map);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database db = await instance.database;
    List<EyeBody> eyebodys = [];

    var query =
        await db.query(eyebodyTable, where: "date = ?", whereArgs: [date]);

    for (var r in query) {
      eyebodys.add(EyeBody.fromDB(r));
    }

    return eyebodys;
  }

  Future<List<EyeBody>> queryAllEyeBody() async {
    Database db = await instance.database;
    List<EyeBody> eyebodys = [];

    var query = await db.query(eyebodyTable);

    for (var r in query) {
      eyebodys.add(EyeBody.fromDB(r));
    }

    return eyebodys;
  }
}
