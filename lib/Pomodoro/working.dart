// this file contains the screen that is shown while executing the pomodoro technique

//packages:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:me/Pomodoro/pomodoro.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

//my packages:
import 'package:me/theme.dart';

class Working extends StatefulWidget {
  const Working({Key? key}) : super(key: key);

  @override
  _WorkingState createState() => _WorkingState();
}

class _WorkingState extends State<Working> {
  Timer? t;
  String title = "Work like hell!";
  String timeLeft = "27:00";
  int secondsLeft = 5;
  int stepNumber = 1;
  bool makeAPause = true;
  bool isRunning = true;

void playMusic(){
  FlutterRingtonePlayer.play(
            android: AndroidSounds.ringtone,
            ios: IosSounds.receivedMessage,
            looping: false,
            volume: 1,
            asAlarm: true);
}
  @override
  void initState() {
    t = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (isRunning) {
        secondsLeft = secondsLeft - 1;
        timeLeft = toTimeString(secondsLeft);
      }
      if (secondsLeft == 0 && makeAPause == true) {
        playMusic();
        if (stepNumber == 4) {
          Navigator.pop(context);
          timer.cancel();
        }
        secondsLeft = 180;
        title = "Take a break!";
        timeLeft = toTimeString(180);
        makeAPause = false;
      } else if (secondsLeft == 0 && makeAPause == false) {
        playMusic();
        secondsLeft = 27 * 60;
        timeLeft = toTimeString(27 * 60);
        title = "Work like hell!";
        stepNumber = stepNumber + 1;
        makeAPause = true;
      }
      if (isRunning) {
        setState(() {
          timeLeft = timeLeft;
          isRunning = isRunning;
        });
      }
    });
    super.initState();
  }

  String toTimeString(int seconds) {
    String minutes = ((seconds / 60).floor()).toString();
    String remainingSeconds = (seconds % 60).toString();
    if (int.parse(minutes) < 10) {
      minutes = "0" + minutes;
    }
    if (int.parse(remainingSeconds) < 10) {
      remainingSeconds = "0" + remainingSeconds;
    }
    return minutes + ":" + remainingSeconds;
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: h! * 11,
          centerTitle: true,
          title: Text(
            title,
          ),
          textTheme: AppTheme.appBarTheme.textTheme,
          backgroundColor: AppTheme.appBarTheme.backgroundColor,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: h! * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountingText(
                text: "Current Count: 3",
                fontMultiplier: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: w! * 7),
                    child: IconButton(
                      icon: icon(),
                      iconSize: h! * 6,
                      color: AppTheme.strongOne,
                      onPressed: () {
                        if (isRunning) {
                          isRunning = false;
                        } else
                          isRunning = true;
                        setState(() {
                          isRunning = isRunning;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel_presentation),
                    iconSize: h! * 6,
                    color: AppTheme.strongOne,
                    onPressed: () {
                      Navigator.pop(context);
                      t?.cancel();
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: h! * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    step(1)[0],
                    step(1)[1],
                    step(2)[0],
                    step(2)[1],
                    step(3)[0],
                    step(3)[1],
                    step(4)[0],
                    step(4)[1],
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Text(
                  timeLeft,
                  style: TextStyle(
                    color: AppTheme.lightOne,
                    fontSize: h! * 15,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> step(int stepId) {
    Color containerColor;
    if (stepNumber == stepId) {
      containerColor = AppTheme.strongOne;
    } else
      containerColor = AppTheme.strongTwo;
    Widget arrow;
    if (stepId != 4) {
      arrow = Icon(
        Icons.arrow_downward,
        color: AppTheme.lightTwo,
        size: h! * 3,
      );
    } else
      arrow = Text("");
    return [
      Center(
        child: Container(
            width: w! * 80,
            height: h! * 8,
            color: containerColor,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Session " + stepId.toString(),
                style: TextStyle(
                  color: AppTheme.lightTwo,
                  fontSize: h! * 3,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            )),
      ),
      arrow,
    ];
  }

  Icon icon() {
    if (isRunning) {
      return Icon(Icons.pause);
    } else
      return Icon(Icons.play_arrow);
  }
}
