import 'dart:async';

import 'package:eyebody2/data/query.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data.dart';

class DatabaseHelper {
  static final _databaseName = "dietapp.db";
  static final int _databaseVersion = 2;

  static final foodTable = "food";
  static final workoutTable = "workout";
  static final bodyTable = "body";
  static final weight = "weight";

  DatabaseHelper._privateContructor();

  static final DatabaseHelper instance = DatabaseHelper._privateContructor();
  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();

    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute("""

CREATE TABLE IF NOT EXISTS $foodTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  type INTEGER DEFAULT 0,
  kcal INTEGER DEFAULT 0,
  time INTEGER DEFAULT 0,
  meal INTEGER DEFAULT 0,
  image String,
  memo String
)

""");

    await db.execute("""

CREATE TABLE IF NOT EXISTS $workoutTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  calorie INTEGER DEFAULT 0,
  intense INTEGER DEFAULT 0,
  part INTEGER DEFAULT 0,
  time INTEGER DEFAULT 0,
  type INTEGER DEFAULT 0,
  distance INTEGER DEFAULT 0,
  name String,
  memo String
)

""");

    await db.execute("""

CREATE TABLE IF NOT EXISTS $bodyTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  image String,
  memo String
)

""");

    await db.execute("""

CREATE TABLE IF NOT EXISTS $weight (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  fat INTEGER DEFAULT 0,
  muscle INTEGER DEFAULT 0
)

""");
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion == 2) {
      await db.execute("""
      ALTER TABLE $workoutTable 
      ADD type INTEGER DEFAULT 0
      """
// ,
//       ADD distance INTEGER DEFAULT 0
          );
    }
  }

  // Future<int> insertFood(Food food, String table) async {
  //   Database db = await instance.database;

  //   if (food.id == null) {
  //     final _map = food.toMap();

  //     return await db.insert(foodTable, _map);
  //   } else {
  //     final _map = food.toMap();
  //     return await db
  //         .update(foodTable, _map, where: "id=?", whereArgs: [food.id]);
  //   }
  // }

  // Future<List<Food>> queryFoodByDate(int date) async {
  //   Database db = await instance.database;

  //   List<Food> foods = [];

  //   final query =
  //       await db.query(foodTable, where: "date = ?", whereArgs: [date]);
  //   for (var q in query) {
  //     foods.add(Food.fromDB(q));
  //   }

  //   return foods;
  // }

  // Future<List<Food>> queryAllFood(int date) async {
  //   Database db = await instance.database;

  //   List<Food> foods = [];

  //   final query = await db.query(foodTable);
  //   for (var q in query) {
  //     foods.add(Food.fromDB(q));
  //   }

  //   return foods;
  // }
}
