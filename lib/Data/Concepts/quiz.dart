import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:me/Data/personal_database.dart';
import 'package:me/SDK/Tables/quiz.dart';
import 'package:me/SDK/ground.dart';

import '../../functions.dart';

mixin Quiz {
  ///returns a two dimensional list containing the following information on each quiz:
  ///index 0: id int
  ///index 1: name String
  ///index 2: numberOfQuestions int
  ///index 3: learned bool
  static Future<List<List<dynamic>>> getQuizes() async {
    if (kIsWeb) {
      return QuizSDK.getQuizes();
    } else if (Platform.isAndroid || Platform.isIOS) {
      List<Map<String, dynamic>> queryResult = await PersonalDatabase.instance
          .selectFromTable("quizes",
              columns: [
                "quiz_id",
                "quiz_name",
                "quiz_numberOfQuestion",
                "quiz_learned"
              ],
              orderBy: "quiz_learned");
      List<List<dynamic>> result = List.empty(growable: true);
      for (var row in queryResult) {
        result.add([
          row["quiz_id"],
          row["quiz_name"],
          row["quiz_numberOfQuestions"],
          row["quiz_learned"]
        ]);
      }
      return result;
    }
    throw Exception;
  }

  ///takes id of a specific quiz
  ///
  ///returns a two dimensional list containing all questions for specific quiz with the following information:
  ///
  ///index 0: question String
  ///
  ///index 1: answer String
  static Future<List<List<String>>> getQuestions(int quizId) async {
    if (kIsWeb) {
      return QuizSDK.getQuestions(quizId);
    } else if (Platform.isAndroid || Platform.isIOS) {
      List<Map<String, dynamic>> queryResult = await PersonalDatabase.instance
          .selectFromTable("questions",
              columns: ["question_question", "question_answer"],
              whereClause: "question_quiz_id = $quizId",
              orderBy: "question_number ASC");
      List<List<String>> result = List.empty(growable: true);
      for (var row in queryResult) {
        result.add([row["question_question"], row["answer_answer"]]);
      }
      return result;
    }
    throw Exception;
  }

  ///adds a new question to a quiz needing the following specifications:
  ///
  ///String question: the question you should be asked taking the quiz
  ///
  ///String answer: the answer you need to give
  ///
  ///int number: when the question should appear in the quiz
  ///
  ///int quizid: to which quiz it belongs to
  ///
  ///example:
  ///```dart
  ///await addQuestion("What is 1 plus 1?", "2", 5, 7)
  ///```
  static Future<void> addQuestion(
      String question, String answer, int number, int quizId) async {
    String sqlOperation =
        "INSERT INTO questions(question_question, question_answer, question_number, question_quiz_id)VALUES('$question','$answer', $number, $quizId)";
    try {
      await QuizSDK.addQuestion(question, answer, number, quizId);
      if (kIsWeb) {
        await remoteAddSql(sqlOperation);
      } else {
        await PersonalDatabase.instance.execute(sqlOperation);
      }
    } catch (error) {
      if (Platform.isAndroid || Platform.isIOS) {
        await PersonalDatabase.instance.addSql(sqlOperation);
      }
    }
  }

  ///deletes a question from the questions table specified by the given [number] and the given [quizId]
  static Future<void> removeQuestion(int number, int quizId) async {
    String sqlOperation =
        "DELETE FROM questions WHERE question_number = $number AND question_quiz_id = $quizId";
    try {
      await QuizSDK.removeQuestion(number, quizId);
      if (kIsWeb) {
        await remoteAddSql(sqlOperation);
      } else {
        await PersonalDatabase.instance.execute(sqlOperation);
      }
    } catch (error) {
      if (Platform.isIOS || Platform.isAndroid) {
        await PersonalDatabase.instance.addSql(sqlOperation);
      }
    }
  }

  ///adds a quiz to the remote database
  ///
  ///questionList needs to look like the following:
  ///
  ///[[quiz_id, question, answer, number], usw.]
  static Future<void> addQuiz(
      String name, List<List<dynamic>> questions) async {
    int numberOfQuestions = questions.length;
    String sqlOne =
        "INSERT INTO quizes(quiz_name, quiz_numberOfQuestion, quiz_learned) VALUES('$name', $numberOfQuestions, 0)";
    String sqlTwo =
        "INSERT INTO questions(question_quiz_id, question_question, question_answer, question_number) " +
            mapValuesForInsertion(prepareValuesForInsertion(questions));
    try {
      await customPost(sqlOne);
      await customPost(sqlTwo);
      if (kIsWeb) {
        await remoteAddSql(sqlOne);
        await remoteAddSql(sqlTwo);
      } else {
        await PersonalDatabase.instance.execute(sqlOne);
        await PersonalDatabase.instance.execute(sqlTwo);
      }
    } catch (error) {
      if (Platform.isAndroid || Platform.isIOS) {
        PersonalDatabase.instance.addSql(sqlOne);
        PersonalDatabase.instance.addSql(sqlTwo);
      }
    }
  }

  ///deletes a quiz from the remote database needing the given [quizId]
  static Future<void> removeQuiz(int quizId) async {
    String sqlOperation = "DELETE FROM quizes WHERE quiz_id = $quizId";
    try {
      await QuizSDK.removeQuiz(quizId);
      if (kIsWeb) {
        await remoteAddSql(sqlOperation);
      } else {
        await PersonalDatabase.instance.execute(sqlOperation);
      }
    } catch (error) {
      if (Platform.isAndroid || Platform.isIOS) {
        PersonalDatabase.instance.addSql(sqlOperation);
      }
    }
  }
}
