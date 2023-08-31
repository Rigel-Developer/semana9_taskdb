import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

var logger = Logger();

class DBAdmin {
  Database? _database;

  //Singleton
  static final DBAdmin db = DBAdmin._internal();
  DBAdmin._internal();

  Future<Database?> checkDatabase() async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, 'taskDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database dbx, int version) async {
        await dbx.execute(
            "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status TEXT)");
      },
    );
  }

  insertRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, description, status) VALUES('Tarea 1', 'Descripcion 1', 'Pendiente')");
    logger.t(res);
  }

  insertTask(Map<String, dynamic> task) async {
    Database? db = await checkDatabase();
    int res = await db!.insert('TASK', task);
    logger.t(res);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    Database? db = await checkDatabase();
    final List<Map<String, dynamic>> tasks = await db!.query('TASK');
    logger.t(tasks);
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getRawTasks() async {
    Database? db = await checkDatabase();
    final List<Map<String, dynamic>> tasks =
        await db!.rawQuery('SELECT * FROM TASK');
    logger.t(tasks);
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getTaskById(int id) async {
    Database? db = await checkDatabase();
    final List<Map<String, dynamic>> task =
        await db!.query('TASK', where: 'id = ?', whereArgs: [id]);
    logger.t(task);
    return task;
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    Database? db = await checkDatabase();
    final int res = await db!
        .update('TASK', task, where: 'id = ?', whereArgs: [task['id']]);
    logger.t(res);
    return res;
  }

  Future<int> deleteTask(int id) async {
    Database? db = await checkDatabase();
    final int res = await db!.delete('TASK', where: 'id = ?', whereArgs: [id]);
    logger.t(res);
    return res;
  }
}
