// this file contains the data model belonging to the pomodoro technique

import 'package:me/Data/personal_database.dart';

class Pomodoro {
  Pomodoro({required this.day, required this.goal, this.count = 0});
  final String day;
  final int goal;
  final int count;
  static const String table = "pomodoro";
  Map<String, dynamic> toMap() {
    return {
      "day": day,
      "goal": goal,
      "count": count,
    };
  }

//inserts one Pomodoro into the pomodoro table
  static Future<void> insertPomodoro(Pomodoro pomodoro) async {
    String day = DateTime.now().toString().split(" ")[0];
    if (await getPomodoroCount(day) > 0) {
      await PersonalDatabase.instance.insertIntoTable(table, pomodoro.toMap());
    } else
      await PersonalDatabase.instance
          .update("UPDATE $table SET count = count + 1 WHERE day = '$day'");
  }

  static Future<List<int>> getSevenLastPomodoroDays() async {
    List<Map<String, dynamic>> tableOrdered = await PersonalDatabase.instance
        .selectFromTable(table, columns: ["count", "day"], orderBy: "day DESC");
    print(tableOrdered);
    List<int> result = List.empty(growable: true);
    int i = 0;
    while (i < tableOrdered.length && result.length < 7) {
      if (tableOrdered[i]["day"] != DateTime.now().toString().split(" ")[0]) {
        result.add(tableOrdered[i]["count"]);
      }
    }
    while (result.length < 7) {
      result.add(0);
    }
    return result.reversed.toList();
  }

  ///return the number of pomodoros executed on specific day
  ///
  ///String day needs format: 2021-12-12
  static Future<int> getPomodoroCount(String day) async {
    bool exists = false;
    if ((await PersonalDatabase.instance.select(
                "SELECT COUNT(*) FROM $table WHERE day = '$day'"))[0]
            ["COUNT(*)"] >
        0) {
      exists = true;
    }
    if (exists) {
      return (await PersonalDatabase.instance.selectFromTable(table,
          columns: ["count"], whereClause: "day = $day"))[0]["count"];
    } else
      return 0;
  }

  static Future<int> getPomodoroGoal(String day) async {
    bool exists = false;
    if ((await PersonalDatabase.instance.select(
                "SELECT COUNT(*) FROM $table WHERE day = '$day'"))[0]
            ["COUNT(*)"] >
        0) {
      exists = true;
    }
    if (exists) {
      return (await PersonalDatabase.instance.selectFromTable(table,
          columns: ["goal"], whereClause: "day = $day"))[0]["count"];
    } else
      return 0;
  }
}
