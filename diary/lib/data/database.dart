import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'diary.dart';

class DatabaseHelper {
  static const String _databaseName = "Diary.db";
  static const int _databaseVersion = 1;
  static const String DiaryTable = "Diary";

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
CREATE TABLE $DiaryTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER DEFAULT 0,
  title TEXT,
  memo TEXT,
  image TEXT,
  status INTEGER,
  category TEXT
)
''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> insertDiary(Diary diary) async {
    Database db = await instance.database;

    List<Diary> d = await getDiaryByDate(diary.date);

    if (d.isEmpty) {
      Map<String, dynamic> row = {
        "title": diary.title,
        "date": diary.date,
        "memo": diary.memo,
        "status": diary.status,
        "category": diary.category,
        "image": diary.image
      };

      return await db.insert(DiaryTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": diary.title,
        "date": diary.date,
        "memo": diary.memo,
        "status": diary.status,
        "category": diary.category,
        "image": diary.image
      };
      return await db
          .update(DiaryTable, row, where: "date = ?", whereArgs: [diary.date]);
    }
  }

  Future<List<Diary>> getAllData() async {
    Database db = await instance.database;
    List<Diary> diarys = [];

    var queries = await db.query(DiaryTable);

    for (var q in queries) {
      diarys.add(Diary(
        id: int.parse(q["id"].toString()),
        title: q["title"].toString(),
        date: int.parse(q["date"].toString()),
        memo: q["memo"].toString(),
        category: q["category"].toString(),
        status: int.parse(q["status"].toString()),
        image: q["image"].toString(),
      ));
    }
    return diarys;
  }

  Future<List<Diary>> getDiaryByDate(int date) async {
    Database db = await instance.database;
    List<Diary> diarys = [];

    var queries =
        await db.query(DiaryTable, where: "date = ?", whereArgs: [date]);

    for (var q in queries) {
      diarys.add(Diary(
        id: int.parse(q["id"].toString()),
        title: q["title"].toString(),
        date: int.parse(q["date"].toString()),
        memo: q["memo"].toString(),
        category: q["category"].toString(),
        status: int.parse(q["status"].toString()),
        image: q["image"].toString(),
      ));
    }
    return diarys;
  }
}
