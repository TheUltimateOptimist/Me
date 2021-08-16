// containse all api calling functions concerning the pomodoro table

//packages:

//my imports:

import 'package:me/functions.dart';

import '../ground.dart';

mixin PomodoroSDK {
  static Future<int> getCurrentPomodoroCount() async {
    String now = currentDateString();
    List<dynamic> result =
        await customGet("SELECT count FROM pomodoro WHERE day = '$now'");
    if (result.length == 0) {
      return 0;
    } else
      return int.parse(result[0][0]);
  }

  static Future<List<int>> getSevenLastPomodoroCounts() async {
    List<dynamic> response =
        await customGet("SELECT count, day FROM pomodoro ORDER BY day DESC");
    List<int> result = List.empty(growable: true);
    int i = 0;
    for (var row in response) {
      print(currentDateString());
      print(row[1]);
      if (row[1] != currentDateString()) {
        result.add(int.parse(row[0]));
        i = i + 1;
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

  static Future<int> getYesterdayPomdoroCount() async {
    String yesterday = currentDateString(yesterday: true);
    List<dynamic> result =
        await customGet("SELECT count FROM pomodoro WHERE day = '$yesterday'");
    if (result.length == 0) {
      return 0;
    } else
      return int.parse(result[0][0]);
  }

  static Future<int> getCurrrentPomdoroGoal() async {
    String now = currentDateString();
    List<dynamic> result =
        await customGet("SELECT goal FROM pomodoro WHERE day = '$now'");
    if (result.length == 0) {
      return 0;
    } else
      return int.parse(result[0][0]);
  }

  static Future<bool> isDayInitialized() async {
    String now = currentDateString();
    List<dynamic> result =
        await customGet("SELECT * FROM pomodoro WHERE day = '$now'");
    if (result.length > 0) {
      return true;
    } else
      return false;
  }
}
