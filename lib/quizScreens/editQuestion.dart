//packages:
import 'package:flutter/material.dart';
import 'package:me/UIWidgets/floatingActionButton.dart';

import '../theme.dart';

//my imports:

class EditQuestion extends StatefulWidget {
  const EditQuestion(this.question, this.answer, {Key? key}) : super(key: key);
  final String question;
  final String answer;

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  List<TextEditingController> controllers = List.empty(growable: true);
  List<Widget> children = List.empty(growable: true);
  @override
  void initState() {
    createChildren(widget.answer.split("-aa-"));
    super.initState();
  }

  void createChildren(List<String> answers) {
    List<Widget> result = List.empty(growable: true);
    result.add(
      desciption(
        "Question:",
        false,
      ),
    );
    result.add(
      customTextField(
        TextEditingController(
          text: widget.question,
        ),
      ),
    );
    for (var element in answers) {
      result.add(
        desciption(
          "Answer: ",
          true,
        ),
      );
      result.add(
        customTextField(
          TextEditingController(
            text: element,
          ),
        ),
      );
    }
    children = result;
  }

  @override
  Widget build(BuildContext context) {
    print(children.length);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: CustomFloatingActionButton(),
      appBar: AppBar(
        title: Text("Edit"),
        backgroundColor: AppTheme.appBarTheme.backgroundColor,
        textTheme: AppTheme.appBarTheme.textTheme,
      ),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
      ),
    );
  }

  desciption(String text, bool showDeleteIcon) {
    EdgeInsets margin = EdgeInsets.only(
      top: h! * 1,
      left: h! * 2,
    );
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textContainer,
          Container(
            margin: margin,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, size: h! * 3, color: AppTheme.strongOne),
            ),
          ),
        ],
      );
    } else {
      return textContainer;
    }
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
