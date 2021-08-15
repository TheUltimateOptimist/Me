// this file contains the screen that lets you take and enter quizes

//packages:
import 'package:flutter/material.dart';

//my imports:

///the state dependent screen that lets the user enter and take quizes
class Quiz extends StatefulWidget {
  ///the state dependent screen that lets the user enter and take quizes
  const Quiz({ Key? key }) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


String remainingTimeToText(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours - days * 24;
    int minutes = duration.inMinutes - hours * 60;
    int seconds = duration.inSeconds - hours * 3600 - minutes * 60;
    if(days > 0){
      return days.toString() + "days " + hours.toString() + ":" + 
      minutes.toString() + ":" + seconds.toString();
    }
    else{
      return 
        hours.toString() + ":" + minutes.toString() +":"
         + seconds.toString();
        }
  }