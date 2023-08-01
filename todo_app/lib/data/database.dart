import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/todo.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = "todo.db";
  static const int _databaseVersion = 1;
  static const String todoTable = "todo";

  DatabaseHelper._privateContructor();

  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  late Database _database;

  Future<Database> get database async {
    //if (!_database.isNull) return _database;
    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $todoTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  done INTEGER DEFAULT 0,
  title TEXT,
  memo TEXT,
  color INTEGER,
  category TEXT
)
''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> insertTodo(Todo todo) async {
    Database db = await instance.database;
    if (todo.id == null) {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category,
        "done": todo.done,
      };

      return await db.insert(todoTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category,
        "done": todo.done,
      };
      return await db
          .update(todoTable, row, where: "id = ?", whereArgs: [todo.id]);
    }
  }

  Future<List<Todo>> getAllData() async {
    Database db = await instance.database;
    List<Todo> todos = [];

    var queries = await db.query(todoTable);

    for (var q in queries) {
      todos.add(Todo(
        id: int.parse(q["id"].toString()),
        title: q["title"].toString(),
        date: int.parse(q["date"].toString()),
        memo: q["memo"].toString(),
        category: q["category"].toString(),
        color: int.parse(q["color"].toString()),
        done: int.parse(q["done"].toString()),
      ));
    }
    return todos;
  }

  Future<List<Todo>> getTodoByDate(int date) async {
    Database db = await instance.database;
    List<Todo> todos = [];

    var queries =
        await db.query(todoTable, where: "date = ?", whereArgs: [date]);

    for (var q in queries) {
      todos.add(Todo(
        id: int.parse(q["id"].toString()),
        title: q["title"].toString(),
        date: int.parse(q["date"].toString()),
        memo: q["memo"].toString(),
        category: q["category"].toString(),
        color: int.parse(q["color"].toString()),
        done: int.parse(q["done"].toString()),
      ));
    }
    return todos;
  }
}
