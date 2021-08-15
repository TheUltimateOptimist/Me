import 'package:flutter/material.dart';

//needed for using the Timer
import 'dart:async';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
//the time left till the next special time comes up
  String timeLeft = "";

///takes an when converting it to string adds a 0 in fron when it is smaller than 10
///
///will look nicer  when displayed on the screen
String customString(int i){
  if(i < 10){
    return "0" + i.toString();
  }
  else{
    return i.toString();
  }
}

  ///converts a duration to a
  ///string: days hours:minuts:seconds
  String remainingTimeToText(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours - days * 24;
    int minutes = duration.inMinutes - hours * 60;
    int seconds = duration.inSeconds - hours * 3600 - minutes * 60;
    if (days > 0) {
      String s = "days ";
      if(days == 1){
        s = "day ";
      }
      return days.toString() +
          s +
          customString(hours) +
          ":" +
          customString(minutes) +
          ":" +
          customString(seconds);
    } else {
      return customString(hours) +
          ":" +
          customString(minutes) +
          ":" +
          customString(seconds);
    }
  }

  ///returns the time remaining till the next
  ///special time takes place as a string: hours:minutes:seconds
  ///
  ///if specialTime is currently active
  ///it returns an empty string
  String timeRemaining() {
    DateTime now = DateTime.now();
    //check if dateTime is between Sunday 10PM and Thursday 6PM
    if (now.weekday < 4 ||
        (now.weekday == 4 && now.hour < 18) ||
        (now.weekday == 7 && now.hour > 9)) {
      DateTime nextSpecialTime = DateTime(now.year, now.month, now.day, 18);
      while (nextSpecialTime.weekday < 4) {
        nextSpecialTime.add(Duration(days: 1));
      }
      return remainingTimeToText(nextSpecialTime.difference(now));
    }
    //check if current dateTime is thursday, friday, saturday,
    //sunday and not between 6 and 10 PM
    else if (now.weekday > 3 && (now.hour < 18 || now.hour > 21)) {
      if (now.hour < 18) {
        return remainingTimeToText(
            DateTime(now.year, now.month, now.day, 18).difference(now));
      } else {
        if (now.weekday == 7) {
          DateTime nowPlus4 = now.add(Duration(days: 4));
          DateTime specialTime =
              DateTime(nowPlus4.year, nowPlus4.month, nowPlus4.day, 18);
          return remainingTimeToText(specialTime.difference(now));
        } else {
          DateTime nowPlus1 = now.add(Duration(days: 1));
          DateTime specialTime =
              DateTime(nowPlus1.year, nowPlus1.month, nowPlus1.day, 18);
          return remainingTimeToText(specialTime.difference(nowPlus1));
        }
      }
    } else {
      return "";
    }
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted == true) {
        setState(() {
          timeLeft = timeRemaining();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Text(
            timeLeft,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
