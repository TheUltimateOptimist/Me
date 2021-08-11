// this file contains the mixins the mixin QueryPomodoro that contains the functions needed for retrieving data from the pomodoro table

import 'package:flutter/foundation.dart';
import 'package:me/Data/personal_database.dart';
import 'package:me/SDK/Tables/pomodoro.dart';
import 'dart:io';

import 'package:me/functions.dart';

///contains the functions needed for retrieving data from the pomodoro table
///
///table info:
///
///name: pomodoro
///
///column1: day Date PRIMARY KEY
///column2: goal INTEGER NOT NULL
///column3: count INTEGER
mixin QueryPomodoro {
  static const String table = "pomodoro";
  static Future<List<int>> getSevenLastPomodoroDays() async {
    late List<Map<String, dynamic>> tableOrdered;
    if (kIsWeb) {
      tableOrdered = await Pomodoro.getAllPomodoroCountsWithDay();
    } else if (Platform.isAndroid || Platform.isIOS) {
      tableOrdered = await PersonalDatabase.instance.selectFromTable(table,
          columns: ["count", "day"], orderBy: "day DESC");
    }
    print(tableOrdered);
    List<int> result = List.empty(growable: true);
    int i = 0;
    while (i < tableOrdered.length && result.length < 7) {
      if (tableOrdered[i]["day"] != currentDateString()) {
        result.add(tableOrdered[i]["count"]);
      }
      i++;
    }
    while (result.length < 7) {
      result.add(0);
    }
    return result.reversed.toList();
  }

  ///return the number of pomodoros executed on specific day
  ///
  ///int dayId: 0 --> Today -1 --> yesterday
  static Future<int> getPomodoroCount(int dayId) async {
    late int result;
    late String time;
    if (kIsWeb) {
      if (dayId == 0) {
        result = await Pomodoro.getCurrentPomodoroCount();
      } else if (dayId == -1) {
        result = await Pomodoro.getYesterdayPomdoroCount();
      }
      return result;
    } else if (Platform.isAndroid || Platform.isIOS) {
      late List<dynamic> queryResult;
      if (dayId == 0) {
        time = currentDateString();
        queryResult = await PersonalDatabase.instance
            .select("SELECT count FROM pomodoro WHERE day = '$time'");
        if (queryResult.length > 0) {
          return queryResult[0]["count"];
        } else
          return 0;
      } else if (dayId == -1) {
        time = currentDateString(yesterday: true);
        queryResult = await PersonalDatabase.instance
            .select("SELECT count FROM pomodoro WHERE day = '$time'");
        if (queryResult.length > 0) {
          return queryResult[0]["count"];
        } else
          return 0;
      }
    }
    return 0;
  }

  static Future<int> getPomodoroGoal() async {
    if (kIsWeb) {
      return await Pomodoro.getCurrrentPomdoroGoal();
    } else if (Platform.isAndroid || Platform.isIOS) {
      String now = currentDateString();
      List<dynamic> queryResult = await PersonalDatabase.instance
          .select("SELECT goal FROM pomodoro WHERE day = '$now'");
      if (queryResult.isNotEmpty) {
        return queryResult[0]["goal"];
      } else
        return 0;
    } else
      return 0;
  }

  static Future<bool> isDayInitialized() async {
    if (kIsWeb) {
      return await Pomodoro.isDayInitialized();
    } else if (Platform.isAndroid || Platform.isIOS) {
      String now = currentDateString();
      List<dynamic> queryResult = await PersonalDatabase.instance
          .select("SELECT * FROM pomodoro WHERE day = '$now'");
      if (queryResult.length > 0) {
        return true;
      } else
        return false;
    }
    return true;
  }
}
