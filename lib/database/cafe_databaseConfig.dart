import 'package:flutter_coffee_note/model/cafe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CafeDatabaseSrvice {
  static final CafeDatabaseSrvice _database = CafeDatabaseSrvice._internal();
  late Future<Database> database;

  factory CafeDatabaseSrvice() => _database; // 이미 만들어지면 이전에 데이터베이스 리턴

  CafeDatabaseSrvice._internal() {
    databaseConfig();
  }
  Future<bool> databaseConfig() async {
    try {
      database = openDatabase(
          join(await getDatabasesPath(),
              "cafeNotes_database.db"), //autoincrement
          onCreate: (db, version) {
        return db.execute(
            '''CREATE TABLE cafeNotes(id INTEGER PRIMARY KEY AUTOINCREMENT,
             cafeName TEXT,
             beenName TEXT,
             brewing TEXT,
             hotIce TEXT,
             processing TEXT,
             cupNote Text)''');
      }, version: 1);
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

// CRUD
  Future<bool> insertCafe(Cafe cafe) async {
    final Database db = await database;
    try {
      db.insert(
        'cafeNotes',
        cafe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<List<Cafe>> selecteCafes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('cafeNotes');

    return List.generate(
        data.length,
        (index) => Cafe(
              id: data[index]['id'],
              cafeName: data[index]['cafeName'],
              beenName: data[index]['beenName'],
              brewing: data[index]['brewing'],
              hotIce: data[index]['hotIce'],
              processing: data[index]['processing'],
              cupNote: data[index]['cupNote'],
            ));
  }

  Future<Cafe> selecteCafe(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> data =
        await db.query('cafeNotes', where: 'id = ?', whereArgs: [id]);

    return Cafe(
      id: data[0]['id'],
      cafeName: data[0]['cafeName'],
      beenName: data[0]['beenName'],
      brewing: data[0]['brewing'],
      hotIce: data[0]['hotIce'],
      processing: data[0]['processing'],
      cupNote: data[0]['cupNote'],
    );
  }

  Future<bool> updateCafe(Cafe cafe) async {
    final Database db = await database;
    try {
      db.update(
        'cafeNotes',
        cafe.toMap(),
        where: 'id = ?',
        whereArgs: [cafe.id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> deleteCafe(int id) async {
    final Database db = await database;
    try {
      db.delete(
        'cafeNotes',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }
}
