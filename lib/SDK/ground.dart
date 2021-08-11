import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> customPost(String sql) async {
  try {
    await http.post(Uri.parse("https://my-personal-cloud.herokuapp.com/post"),
        body: {"sql": sql});
    return true;
  } catch (error) {
    return false;
  }
}

Future<List<dynamic>> customGet(String sql) async {
  try {
    final response = await http
        .get(Uri.parse("https://my-personal-cloud.herokuapp.com/get/$sql"));
    print(response.body);
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } catch (error) {
    print(error);
    return [];
  }
}
