import 'package:me/Data/personal_database.dart';
import 'package:me/SDK/ground.dart';

mixin SyncDatabases {
  ///via http request collects the sql operations that were executed on the remote database
  ///and executes them on the local database
  static Future<void> integrateRemoteChanges() async {
    try {
      List<dynamic> queryResult = await customGet("SELECT * FROM sql");
      for (var row in queryResult) {
        await PersonalDatabase.instance.execute(row[1]);
        int id = int.parse(row[0]);
        await customPost("DELETE FROM sql WHERE sql_id = $id");
      }
    } catch (error) {
      print(error);
    }
  }

  ///via http request executes the local changes on the remote database
  /// if they have not been executed there yet
  static Future<void> pushLocalChanges() async {
    List<Map<String, dynamic>> queryResult =
        await PersonalDatabase.instance.selectFromTable("sql");
    for (var row in queryResult) {
      try {
        await customPost(row["sql"]);
        int id = int.parse(row["sql_id"]);
        await PersonalDatabase.instance
            .execute("DELETE FROM sql WHERE sql_id = $id");
      } catch (error) {
        print(error);
      }
    }
  }
}
