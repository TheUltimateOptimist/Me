import 'dart:async';

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

  ///inserts the given values as one row into the given table
  Future<int> insertIntoTable(String table, Map<String, dynamic> values) async {
    final db = await instance.database;
    return await db.insert(table, values);
  }

  ///deletes rows from the given table that match with the given whereclause
  ///
  ///if no whereclause is given it deletes all rows from the given table
  ///
  ///exanple: await deleteRows("pomodoro", whereClause: "day = 2021-12-12");
  Future<int> deleteRows(String table, {String? whereClause}) async {
    final db = await instance.database;
    return await db.delete(table, where: whereClause);
  }

  ///updates rows from the given table with the given values if the given whereClause is true
  ///
  ///if no whereClause is given every row in the table is updated
  ///
  ///the whereClause String does not need the where key word
  Future<int> upadateSingle(String table, Map<String, dynamic> values,
      {String? whereClause}) async {
    final db = await instance.database;
    return await db.update(table, values, where: whereClause);
  }

///lets you update a table with a raw sql statement
  Future<int> update(sql) async{
    final db = await instance.database;
    return await db.rawUpdate(sql);
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
  Future<void> execute(String sql) async{
final db = await instance.database;
await db.execute(sql);
  }
}
