// this file contains everything that has to do with the table that hosts the sql operations that could not be sent to the cloud due to the lack of an internet connection

//my imports:
import 'package:me/Data/personal_database.dart';
import 'package:me/SDK/ground.dart';

///mixin contains all functions needed for retrieving data from sql table and adding as well as performing that operations on the cloud
///
///table info:
///
///name: sql
///
///column1: dateTime DateTime PrimaryKey
///
///column2: sql TEXT
class QuerySQL {
  static const table = "sql";

  ///adds an sql operation to the sql table
  static Future<void> addSQL(String sqlOperation) async {
    String time = DateTime.now().toString();
    await PersonalDatabase.instance
        .execute("INSERT INTO $table Values('$time', '$sqlOperation')", performOnCloud: false);
  }

  ///remove specific sql operation/ions from the sql operation table
  ///
  ///to remove all set String dateTime to "all"
  ///
  ///to remove one set String dateTime to the specific DateTime of the sql operation
  static Future<void> _removeSQL(String dateTime) async {
    if (dateTime == "all") {
      await PersonalDatabase.instance.execute("DELETE FROM $table", performOnCloud: false);
    } else
      await PersonalDatabase.instance
          .execute("DELETE FROM $table WHERE dateTime = '$dateTime'", performOnCloud: false);
  }

///looks up the sql table if there are no operations it returns false as a refresh is not needed
///
///if there are operations it trys to perform them on the cloud and deletes them afterwards
///
/// if everything works it return false as no refresh is needed else it returns true
  static Future<bool> performOnCloud() async {
    if ((await PersonalDatabase.instance.select("SELECT COUNT(*) FROM sql"))[0]
            ["COUNT(*)"] >
        0) {
      List<Map<String, dynamic>> operationsByDate = await PersonalDatabase
          .instance
          .selectFromTable(table, orderBy: "dateTime ASC");
      bool shouldRefresh = false;
      for (int i = 0; i < operationsByDate.length; i++) {
        if (await customPost(
          operationsByDate[i]["sql"],
          isFirstTry: false,
        )) {
          _removeSQL(operationsByDate[i]["dateTime"]);
        } else
          shouldRefresh = true;
      }
      return shouldRefresh;
    } else
      return false;
  }
}
