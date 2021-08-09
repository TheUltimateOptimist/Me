//this file contains the screen that lets you start performing the pomodoro technique

//packages:
import 'package:flutter/material.dart'
    show
        State,
        StatefulWidget,
        Key,
        AppBar,
        Container,
        Widget,
        BuildContext,
        SafeArea,
        Scaffold,
        EdgeInsets,
        Text,
        Column,
        CrossAxisAlignment,
        MainAxisAlignment,
        ElevatedButton,
        StatelessWidget,
        Navigator,
        TextStyle;
import 'package:me/Data/Tables/pomodoroClass.dart';
import 'package:syncfusion_flutter_charts/charts.dart'
    show AreaSeries, SfCartesianChart, ChartSeries;

//my imports:
import 'package:me/theme.dart';

class PomodoroScreen extends StatefulWidget {
  ///the screen from which you can start performing the Pomodoro technique
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  @override
  void initState() {
    getAsyncData();
    super.initState();
  }

  Map<String, dynamic>? data;
  Future<void> getAsyncData() async {
    List<int> pomodoroCounts = await QueryPomodoro.getSevenLastPomodoroDays();
    List<Performance> chartData = List.empty(growable: true);
    for (int i = 0; i < 7; i++) {
      chartData.add(Performance(dayNumber: i + 1, count: pomodoroCounts[i]));
    }
    data = {
      "chartData": chartData,
      "yesterdayCount": await QueryPomodoro.getPomodoroCount(
          DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0]),
      "currentCount":
          await QueryPomodoro.getPomodoroCount(DateTime.now().toString()),
      "currentGoal": await QueryPomodoro.getPomodoroGoal(DateTime.now().toString())
    };
    setState(() {
      data = data;
    });
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
                    Navigator.pushNamed(context, "home/pomodoro/working");
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
