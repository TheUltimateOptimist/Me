//this file contains the screen that lets you start performing the pomodoro technique

//packages:
import 'package:flutter/material.dart'
    show
        AlertDialog,
        AppBar,
        BorderSide,
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        ElevatedButton,
        InputDecoration,
        Key,
        MainAxisAlignment,
        Navigator,
        SafeArea,
        Scaffold,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextButton,
        TextEditingController,
        TextField,
        TextStyle,
        UnderlineInputBorder,
        Widget,
        MaterialPageRoute,
        showDialog;
import 'package:me/PomodoroScreens/working.dart';
import 'package:me/SDK/ground.dart';
import 'package:me/functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart'
    show AreaSeries, SfCartesianChart, ChartSeries;

//my imports:
import 'package:me/theme.dart';
import 'package:me/SDK/Tables/pomodoro.dart';

class PomodoroScreen extends StatefulWidget {
  ///the screen from which you can start performing the Pomodoro technique
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final textEditingController = new TextEditingController();
  @override
  void initState() {
    getAsyncData();
    checkDayInitialization();
    super.initState();
  }

  Map<String, dynamic>? data;
  Future<void> getAsyncData() async {
    List<int> pomodoroCounts = await Pomodoro.getSevenLastPomodoroCounts();
    List<Performance> chartData = List.empty(growable: true);
    for (int i = 0; i < 7; i++) {
      chartData.add(Performance(dayNumber: i + 1, count: pomodoroCounts[i]));
    }
    data = {
      "chartData": chartData,
      "yesterdayCount": await Pomodoro.getYesterdayPomdoroCount(),
      "currentCount": await Pomodoro.getCurrentPomodoroCount(),
      "currentGoal": await Pomodoro.getCurrrentPomdoroGoal()
    };
    setState(() {
      data = data;
    });
  }

  Future<void> checkDayInitialization() async {
    if (!await Pomodoro.isDayInitialized()) {
      AlertDialog alertDialog = AlertDialog(
        title: Text(
          "Enter today´s Pomdoro Goal:",
          style: TextStyle(
            color: AppTheme.lightOne,
            fontSize: h! * 3,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: TextStyle(
                  color: AppTheme.lightTwo,
                  fontFamily: AppTheme.fontFamily,
                  fontSize: h! * 4),
            ),
            onPressed: () async {
              String time = currentDateString();
              int goal = int.parse(textEditingController.text);
              await customPost(
                  "INSERT INTO pomodoro VALUES('$time', $goal, 0)");
              await getAsyncData();
              setState(() {});
              Navigator.pop(context);
            },
          )
        ],
        backgroundColor: AppTheme.backgroundColor,
        content: TextField(
          controller: textEditingController,
          style: TextStyle(
              color: AppTheme.lightTwo,
              fontSize: h! * 3,
              fontFamily: AppTheme.fontFamily),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.strongOne),
            ),
            hintText: "goal",
            hintStyle: TextStyle(
              color: AppTheme.lightOne,
              fontSize: h! * 3,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),
      );
      await showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    if (data == null) {
      return Container(color: AppTheme.backgroundColor);
    } else {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            toolbarHeight: h! * 11,
            title: Container(
              margin: EdgeInsets.only(left: h! * 2),
              child: Text(
                "Pomodoro",
              ),
            ),
            textTheme: AppTheme.appBarTheme.textTheme,
            backgroundColor: AppTheme.appBarTheme.backgroundColor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CountingText(
                  text: "Yesterday: " + data!["yesterdayCount"].toString()),
              CountingText(
                  text: "Goal today: " + data!["currentGoal"].toString()),
              CountingText(text: "Today: " + data!["currentCount"].toString()),
              Container(
                margin: EdgeInsets.only(
                  left: w! * 7,
                  top: h ?? 0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppTheme.strongOne,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Working(
                          currentCount: data!["currentCount"],
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        data!["currentCount"] = value;
                      });
                    });
                  },
                  child: Text(
                    "EXECUTE",
                    style: TextStyle(
                      color: AppTheme.lightTwo,
                      fontFamily: AppTheme.fontFamily,
                      fontSize: h! * 6,
                    ),
                  ),
                ),
              ),
              Container(
                child: SfCartesianChart(
                  series: <ChartSeries>[
                    AreaSeries(
                      animationDuration: 10000,
                      color: AppTheme.strongTwo,
                      dataSource: data!["chartData"],
                      xValueMapper: (performance, _) => performance.dayNumber,
                      yValueMapper: (performance, _) => performance.count,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class Performance {
  Performance({this.count = 0, this.dayNumber = 0});
  final int count;
  final int dayNumber;
}

class CountingText extends StatelessWidget {
  const CountingText({Key? key, this.text = "", this.fontMultiplier = 4})
      : super(key: key);
  final String text;
  final double fontMultiplier;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: w! * 7, top: h ?? 0),
      child: Text(
        text,
        style: TextStyle(
            color: AppTheme.lightTwo,
            fontSize: h! * fontMultiplier,
            fontFamily: AppTheme.fontFamily),
      ),
    );
  }
}
