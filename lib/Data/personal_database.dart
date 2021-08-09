import 'dart:async';

import 'package:me/Data/sdk.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PersonalDatabase {
  PersonalDatabase._ctor(); //private constructor
  static final PersonalDatabase instance =
      PersonalDatabase._ctor(); //the single instance
  static Database? _database;
  Future<Database> get database async => _database ??= await _init();
  _init() async {
    return await openDatabase(
        join(await getDatabasesPath(), "personal_database.db"),
        onCreate: _onCreate,
        version: 1);
  }

  _onCreate(Database db, int version) {
    db.execute(
        "CREATE TABLE pomodoro(day Date PRIMARY KEY, goal INTEGER NOT NULL, count INTEGER)");
  }

  ///returns a future list of maps representing the rows of the given table
  Future<List<Map<String, dynamic>>> selectFromTable(String table,
      {List<String>? columns, String? whereClause, String? orderBy}) async {
    final db = await instance.database;
    return await db.query(table,
        columns: columns, where: whereClause, orderBy: orderBy);
  }

  ///executes the given sql query and returns the result as a future list of maps
  Future<List<Map<String, dynamic>>> select(String sqlQuery) async {
    final db = await instance.database;
    return await db.rawQuery(sqlQuery);
  }

  ///executes any sql operation
  Future<void> execute(String sql, {performOnCloud = true}) async {
    final db = await instance.database;
    await db.execute(sql);
    if (performOnCloud) {
      await customPost(sql);
    }
  }
}
