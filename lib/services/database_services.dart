import 'package:flutter_sqflite/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static Database? _db;

  static final DatabaseServices instance = DatabaseServices._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";

  DatabaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getdatabase();
      return _db!;
    }
  }

  Future<Database> getdatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "local_db");
    final database =
        await openDatabase(databasePath, version: 1, onCreate: (db, version) {
      db.execute('''
      CREATE TABLE $_tasksTableName (
       $_tasksIdColumnName INTEGER PRIMARY KEY,
       $_tasksContentColumnName TEXT NOT NULL,
       $_tasksStatusColumnName INTEGER NOT NULL
      )
      ''');
    });
    return database;
  }

  void addTask(String content) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksContentColumnName: content,
      _tasksStatusColumnName: 0,
    });
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tasksTableName);

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => Task.fromMap(map)).toList();
  }

  void updateTask(int id, int status) async {
    final db = await database;
    await db.update(
        _tasksTableName,
        {
          _tasksStatusColumnName: status,
        },
        where: 'id = ?',
        whereArgs: [
          id,
        ]);
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(_tasksTableName, where: 'id = ?', whereArgs: [
      id,
    ]);
  }
}
