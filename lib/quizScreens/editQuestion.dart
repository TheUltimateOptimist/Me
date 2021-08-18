//packages:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me/UIWidgets/floatingActionButton.dart';

import '../theme.dart';

//my imports:

class EditQuestion extends StatefulWidget {
  const EditQuestion(this.question, this.answer, this.isCreation, {Key? key}) : super(key: key);
  final String question;
  final String answer;
  final bool isCreation;

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  String? answers;
  List<TextEditingController> controllers = List.empty(growable: true);
  List<Widget> children = List.empty(growable: true);
  String precisionText = "precise";
  ScrollController scrollController = ScrollController();
  List<Widget> createChildren(List<String> answers) {
    List<Widget> result = List.empty(growable: true);
    result.add(
      desciption(
        "Question:",
        false,
      ),
    );
    controllers.add(TextEditingController(text: widget.question));
    result.add(
      customTextField(controllers[0]),
    );
    int i = 1;
    for (var element in answers) {
      controllers.add(TextEditingController(text: element));
      result.add(
        desciption(
          i.toString() + ". Answer: ",
          true,
          answer: element,
        ),
      );
      result.add(
        customTextField(controllers[i]),
      );
      i++;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (answers == null) {
      answers = widget.answer;
    }
    children = createChildren(answers!.split("--a--"));
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          setState(
            () {
              answers = answers! + "--a--";
              controllers = [];
            },
          );
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.decelerate);
          });
        },
      ),
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: w! * 2),
            child: TextButton(
              onPressed: () {
                // -->save the changes <--
                Navigator.pop(context, controllers[0].text);
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: h! * 3,
                ),
              ),
            ),
          ),
        ],
        title: Text("Edit"),
        backgroundColor: AppTheme.appBarTheme.backgroundColor,
        textTheme: AppTheme.appBarTheme.textTheme,
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
      ),
    );
  }

  desciption(String text, bool showDeleteIcon, {String? answer}) {
    EdgeInsets margin = EdgeInsets.only(top: h! * 1, left: h! * 2);
    Container trailingButton;
    Container textContainer = Container(
      margin: margin,
      child: Text(
        text,
        style: TextStyle(
          fontSize: h! * 4,
          color: AppTheme.lightOne,
        ),
      ),
    );
    if (showDeleteIcon) {
      trailingButton = Container(
        margin: margin,
        child: IconButton(
          onPressed: () {
            setState(() {
              List<String> workingList = answers!.split("--a--");
              workingList.remove(answer);
              answers = workingList.join("--a--");
            });
          },
          icon: Icon(
            Icons.delete,
            size: h! * 3,
            color: AppTheme.strongOne,
          ),
        ),
      );
    } else {
      trailingButton = Container(
        margin: margin,
        child: TextButton(
          onPressed: () {
            setState(() {
              if (precisionText == "precise") {
                precisionText = "multiple";
              } else {
                precisionText = "precise";
              }
            });
          },
          child: Text(
            precisionText,
            style: TextStyle(
              color: AppTheme.strongTwo,
              fontSize: h! * 3,
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textContainer,
        trailingButton,
      ],
    );
  }

  customTextField(TextEditingController textEditingController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: h! * 2),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppTheme.strongOne),
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: w! * 2,
        ),
        child: TextField(
          controller: textEditingController,
          style: TextStyle(
            color: AppTheme.lightTwo,
            fontSize: h! * 2.5,
          ),
          maxLines: 11,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
