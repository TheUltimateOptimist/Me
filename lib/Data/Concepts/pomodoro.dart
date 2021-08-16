import 'package:flutter/foundation.dart';
import 'package:me/Data/personal_database.dart';
import 'package:me/SDK/Tables/pomodoro.dart';

import '../../functions.dart';

mixin Pomodoro {
  ///returns the current pomodoro count as an integer
  static Future<int> getCurrentPomodoroCount() async {
    String now = currentDateString();
    String sqlOperation = "SELECT COUNT(*) FROM pomodoro WHERE day = '$now'";
    if (kIsWeb) {
      return PomodoroSDK.getCurrentPomodoroCount();
    } else {
      return (await PersonalDatabase.instance.select(sqlOperation))[0]
          ["COUNT(*)"];
    }
  }

  ///returns the seven last pomodoro counts as a list of integers
  static Future<List<int>> getSevenLastPomodoroCounts() async {
    String sqlOperation = "SELECT count, day FROM pomodoro ORDER BY day DESC";
    if (kIsWeb) {
      return await PomodoroSDK.getSevenLastPomodoroCounts();
    } else {
      List<Map<String, dynamic>> queryResult =
          await PersonalDatabase.instance.select(sqlOperation);
      List<int> result = List.empty(growable: true);
      int i = 0;
      for (var row in queryResult) {
        if (row["day"] != currentDateString()) {
          result.add(
            int.parse(
              row["count"],
            ),
          );
          i++;
        }
        if (i == 7) {
          break;
        }
      }
      while (result.length < 7) {
        result.add(0);
      }
      return result.reversed.toList();
    }
  }

  ///returns yesterdays pomodoro counts as an integer
  static Future<int> getYesterdayPomdoroCount() async {
    String yesterday = currentDateString(yesterday: true);
    String sqlOperation =
        "SELECT COUNT(*) FROM pomodoro WHERE day = '$yesterday'";
    if (kIsWeb) {
      return PomodoroSDK.getYesterdayPomdoroCount();
    } else {
      return int.parse(
        (await PersonalDatabase.instance.select(sqlOperation))[0]["COUNT(*)"],
      );
    }
  }

  ///returns the current pomodoro goal as an integer
  static Future<int> getCurrrentPomdoroGoal() async {
    String now = currentDateString();
    String sqlOperation = "SELECT goal FROM pomodoro WHERE day = '$now'";
    if (kIsWeb) {
      return await PomodoroSDK.getCurrrentPomdoroGoal();
    } else {
      return int.parse(
          (await PersonalDatabase.instance.select(sqlOperation))[0]["goal"]);
    }
  }

  ///checks if a pomodoro goal has already been specified if yes returns true else returns false
  static Future<bool> isDayInitialized() async {
    String now = currentDateString();
    String sqlOperation = "SELECT * FROM pomodoro WHERE day = '$now'";
    if (kIsWeb) {
      return await PomodoroSDK.isDayInitialized();
    } else {
      List<Map<String, dynamic>> queryResult =
          await PersonalDatabase.instance.select(sqlOperation);
      if (queryResult.length <= 0) {
        return false;
      } else
        return true;
    }
  }
}
