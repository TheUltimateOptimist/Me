import 'package:http/http.dart' show post;
import 'Tables/sqlClass.dart';

Future<bool> customPost(String sql, {bool isFirstTry = true}) async {
  try {
    await post(Uri.parse("uri"), body: {"sql": sql});
    return true;
  } catch (error) {
    if (isFirstTry) {
      QuerySQL.addSQL(sql);
    }
    return false;
  }
}
