import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/data/database.dart';
import 'package:sqflite/sqflite.dart';

class Query<T extends MyData> {
  final String tableName;

  Query({
    required this.tableName,
  });

  Future<int> insertDataById(T data) async {
    Database db = await DatabaseHelper.instance.database;

    final _map = data.toMap();
    if (data.id == null) {
      return await db.insert(tableName, _map);
    } else {
      return await db
          .update(tableName, _map, where: "id=?", whereArgs: [data.id]);
    }
  }

  Future<int> insertDataByDate(T data) async {
    Database db = await DatabaseHelper.instance.database;

    List<Map<String, Object?>> query = [];
    data.fromDB(query.first);

    final _map = data.toMap();
    if (data.date == null) {
      return await db.insert(tableName, _map);
    } else {
      return await db
          .update(tableName, _map, where: "date=?", whereArgs: [data.date]);
    }
  }

  Future<List<T>> queryDataByDate(int date, T t) async {
    Database db = await DatabaseHelper.instance.database;
    List<T> datas = [];

    final query =
        await db.query(tableName, where: "date = ?", whereArgs: [date]);
    for (var q in query) {
      datas.add(t.fromDB(q) as T);
    }

    return datas;
  }

  Future<List<T>> queryAllData(int date, T t) async {
    Database db = await DatabaseHelper.instance.database;
    List<T> datas = [];

    final query = await db.query(tableName);
    for (var q in query) {
      datas.add(t.fromDB(q) as T);
    }

    return datas;
  }
}
