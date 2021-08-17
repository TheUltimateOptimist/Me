//packages:
import 'package:flutter/material.dart';
import 'package:me/Data/Concepts/quiz.dart';
import 'package:me/UIWidgets/customListView.dart';
import 'package:me/UIWidgets/floatingActionButton.dart';
import 'package:me/theme.dart';

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
    quiz = [
      ["What is one plus one equal to?", "2", 0],
      ["Why is the banane krumm", "What the fuck", 1],
      ["Wie heißt Jonathan mit Vorname?", "Definitiv Jonathan", 0]
    ];
    addIndices();
  }

  void addIndices() {
    for (int i = 0; i < quiz!.length; i++) {
      quiz![i].add((i + 1).toString() + ". ");
    }
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
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
      body: CustomListView(
        indexToInsertCompletionStatus: 1,
        showCompletionStatus: true,
        completionStatuses:
            quiz!.map((e) => int.parse(e[2].toString())).toList(),
        onPressed: () {},
        titles: quiz!.map((e) => e[3].toString() + e[0].toString()).toList(),
        addGarbageCan: true,
        trailing: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              size: h! * 3,
              color: AppTheme.strongOne,
            ),
          ),
        ],
      ),
    );
  }
}
