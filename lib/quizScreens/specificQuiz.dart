//packages:
import 'package:flutter/material.dart';
import 'package:me/Data/Concepts/quiz.dart';
import 'package:me/UIWidgets/floatingActionButton.dart';
import 'package:me/theme.dart';

import 'editQuestion.dart';

//my imports:

class SpecificQuiz extends StatefulWidget {
  const SpecificQuiz(
      {Key? key,
      required this.quizId,
      required this.name,
      required this.learned})
      : super(key: key);
  final int quizId;
  final String name;
  final int learned;

  @override
  _SpecificQuizState createState() => _SpecificQuizState();
}

class _SpecificQuizState extends State<SpecificQuiz> {
  List<List<dynamic>>? quiz;

  @override
  void initState() {
    asyncData();
    super.initState();
  }

  Future<void> asyncData() async {
    //quiz = await Quiz.getQuestions(widget.quizId);
    setState(() {
      quiz = [
        ["What is one plus one equal to?", "2", 0],
        ["Why is the banane krumm", "What the fuck", 1],
        ["Wie heißt Jonathan mit Vorname?", "Definitiv Jonathan", 0]
      ];
      addIndices();
    });
  }

  void addIndices() {
    for (int i = 0; i < quiz!.length; i++) {
      quiz![i].add((i + 1).toString() + ". ");
    }
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    if (quiz == null) {
      return Container(
        color: AppTheme.backgroundColor,
      );
    } else {
      return Scaffold(
        floatingActionButton: CustomFloatingActionButton(onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditQuestion("", "answer")))
              .then((value) => asyncData());
        }),
        appBar: AppBar(
          backgroundColor: AppTheme.appBarTheme.backgroundColor,
          title: Text(
            widget.name,
          ),
          textTheme: AppTheme.appBarTheme.textTheme,
          // leading: Icon(
          //   Icons.check_rounded,
          //   color: Colors.green,
          //   size: h! * 3,
          // ),
          actions: [
            Row(
              children: [
                Text(
                  "12",
                  style: TextStyle(fontSize: h! * 2.5),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.play_circle,
                    size: h! * 4,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppTheme.strongTwo,
        body: ListView.builder(
            itemCount: quiz!.length,
            itemBuilder: (context, index) {
              IconData icon;
              Color iconColor;
              if (quiz![index][2] == 0) {
                icon = Icons.cancel_rounded;
                iconColor = AppTheme.strongOne;
              } else {
                icon = Icons.check_circle;
                iconColor = Colors.green;
              }
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditQuestion(
                        quiz![index][0],
                        quiz![index][1],
                      ),
                    ),
                  );
                },
                title: Text(
                  quiz![index][0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.lightOne,
                    fontSize: h! * 3,
                  ),
                ),
                tileColor: AppTheme.strongTwo,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditQuestion(
                              quiz![index][0],
                              quiz![index][1],
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        size: h! * 3,
                        color: AppTheme.strongOne,
                      ),
                    ),
                    Icon(
                      icon,
                      color: iconColor,
                      size: h! * 3,
                    ),
                    IconButton(
                      onPressed: () async {
                        //delete quiz
                      },
                      icon: Icon(
                        Icons.delete,
                        size: h! * 3,
                        color: AppTheme.lightOne,
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
  }
}
