import 'dart:async';

import 'package:me/SDK/ground.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

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

  _onCreate(Database db, int version) async {
    db.execute(
        "CREATE TABLE pomodoro(day Date PRIMARY KEY, goal INTEGER NOT NULL, count INTEGER NOT NULL)");
    db.execute(
        "CREATE TABLE quizes(quiz_id INTEGER PRIMARY KEY AUTO_INCREMENT, quiz_name TEXT NOT NULL, quiz_numberOfQuestions INTEGER NOT NULL, quiz_learned INTEGER NOT NULL)");
    db.execute(
        "CREATE TABLE questions(question_question TEXT NOT NULL, question_answer TEXT NOT NULL, question_number INTEGER NOT NULL, question_quiz_id INTEGER NOT NULL, FOREIGN KEY(question_quiz_id) REFERENCES quizes(quiz_id) ON UPDATE CASCADE ON DELETE CASCADE)");
    db.execute(
        "CREATE TABLE quizing(quizing_datetime DATETIME PRIMARY KEY, quizing_quiz_id INTEGER NOT NULL, quizing_correct INTEGER NOT NULL, FOREIGN KEY(quizing_quiz_id) REFERENCES quizes(quiz_id) ON UPDATE CASCADE ON DELETE CASCADE)");
    db.execute(
        "CREATE TABLE sql(sql_id INTEGER PRIMARY KEY AUTO_INCREMENT, sql TEXT NOT NULL)");
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
  }

  //insert an sql operation for later executing on remote database
  Future<void> addSql(String sqlOperation) async {
    final db = await instance.database;
    await db.execute("INSERT INTO sql(sql) VALUES('$sqlOperation')");
  }
}
