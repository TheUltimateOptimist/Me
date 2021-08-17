// this file contains the screen that lets you take and enter quizes

//packages:
import 'package:flutter/material.dart';

//my imports:
import 'package:me/Data/Concepts/quiz.dart';
import 'package:me/UIWidgets/customListView.dart';
import 'package:me/UIWidgets/floatingActionButton.dart';
import 'package:me/theme.dart';

///the state dependent screen that show all available quizes
class QuizScreen extends StatefulWidget {
  ///the state dependent screen that shows all available quizes
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<List<dynamic>>? quizes;

  @override
  void initState() {
    asyncData();
    super.initState();
  }

  Future<void> asyncData() async {
    //quizes = await Quiz.getQuizes();
    quizes = [
      [0, "First Quiz", 14, false],
      [1, "Second Quiz", 9, true],
      [2, "Third Quiz", 78, false]
    ];
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    if (quizes == null) {
      return Container(color: AppTheme.backgroundColor);
    } else {
      return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          floatingActionButton: CustomFloatingActionButton(),
          appBar: AppBar(
            backgroundColor: AppTheme.appBarTheme.backgroundColor,
            textTheme: AppTheme.appBarTheme.textTheme,
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: Icon(
            //       Icons.search,
            //     ),
            //   ),
            // ],
            title: Text("Quizes"),
          ),
          body: CustomListView(
            onPressed: () {},
            titles: quizes!.map((e) => e[1].toString()).toList(),
            addGarbageCan: true,
            trailing: [
              Icon(
                Icons.check_circle,
                size: h! * 3,
                color: AppTheme.lightOne,
              )
            ],
          ));
    }
  }
}
