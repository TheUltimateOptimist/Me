//contains the app´s theme

//packages:
import 'package:flutter/material.dart';

//reponsive factors:
///the height of the user's divice divided by 100
///
///needed for creating a UI that adopts to the different screen sizes
double? h;

///the width of the user's divice divided by 100
///
///needed for creating a UI that adopts to the different screen sizes
double? w;

initSize(context) {
  h = MediaQuery.of(context).size.height / 100;
  w = MediaQuery.of(context).size.width / 100;
}

class AppTheme {
  static AppTheme? _instance;
  AppTheme._internal() {
    _instance = this;
  }
  factory AppTheme() => _instance ?? AppTheme._internal();
  static Color backgroundColor = Color(0xFF1b1210);
  static Color strongOne = Color(0xFF6d031c);
  static Color strongTwo = Color(0xFF673e37);
  static Color lightOne = Color(0xFFa79086);
  static Color lightTwo = Color(0xFFd2d2c9);
  static String? fontFamily = "Dancing";
  static AppBarTheme appBarTheme = AppBarTheme(
      backgroundColor: strongOne,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightTwo,
          fontSize: h! * 7,fontFamily: "Dancing"
        ),
      ));
}
