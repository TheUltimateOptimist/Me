// this file contains the screen that lets you take and enter quizes

//packages:
import 'package:flutter/material.dart';

//my imports:
import 'package:me/Data/Concepts/quiz.dart';
import 'package:me/UIWidgets/floatingActionButton.dart';
import 'package:me/quizScreens/specificQuiz.dart';
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
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    asyncData();
    super.initState();
  }

  Future<void> asyncData() async {
    //quizes = await Quiz.getQuizes();
    setState(() {
      //quizes = quizes;
      quizes = [
        [0, "First Quiz", 14, 0],
        [1, "Second Quiz", 9, 1],
        [2, "Third Quiz", 78, 0]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    if (quizes == null) {
      return Container(color: AppTheme.backgroundColor);
    } else {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () async {
            AlertDialog alertDialog = AlertDialog(
              title: Text(
                "Enter name",
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpecificQuiz(
                          quizId: 1,
                          name: textEditingController.text,
                          learned: 0,
                        ),
                      ),
                    );
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
          },
        ),
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
        body: ListView.builder(
            itemCount: quizes!.length,
            itemBuilder: (context, index) {
              IconData icon;
              Color iconColor;
              if (quizes![index][3] == 0) {
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
                      builder: (context) => SpecificQuiz(
                        quizId: 0,
                        name: "First Quiz",
                        learned: 0,
                      ),
                    ),
                  );
                },
                title: Text(
                  quizes![index][1],
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
                    Container(
                      margin: EdgeInsets.only(right: w! * 2),
                      child: Text(
                        quizes![index][2].toString(),
                        style: TextStyle(
                          color: AppTheme.lightOne,
                          fontSize: h! * 3,
                        ),
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
