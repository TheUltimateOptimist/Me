//this file contains the implementation of all SharedPreferences that are needed throughout the app

//packages:
import 'package:shared_preferences/shared_preferences.dart';

///manages all SharedPreferences
class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }
  UserPreferences._ctor();
  late SharedPreferences _p;

  ///initializes the SharedPreferences
  init() async {
    _p = await SharedPreferences.getInstance();
    
  }
  set shouldRefresh(bool shouldRefresh){
    _p.setBool("shouldRefresh", shouldRefresh);
  }

  bool get shouldRefresh{
    return _p.getBool("shouldRefresh") ?? false;
  }
}