import 'package:me/SDK/ground.dart';
import 'package:me/functions.dart';

mixin Quiz {

  ///returns a two dimensional list containing the following information on each quiz:
  ///index 0: id int
  ///index 1: name String
  ///index 2: numberOfQuestions int
  ///index 3: learned bool
  static Future<List<List<dynamic>>> getQuizes() async {
    List<dynamic> data = await customGet(
        "SELECT quiz_id, quiz_name, quiz_numberOfQuestion, quiz_learned FROM quizes");
    List<List<dynamic>> result = List.empty(growable: true);
    for (var row in data) {
      bool learned = false;
      if (row[3] == "1") learned = true;
      result.add([int.parse(row[0]), row[1], int.parse(row[2]), learned]);
    }
    return result;
  }

  ///takes id of a specific quiz
  ///
  ///returns a two dimensional list containing all questions for specific quiz with the following information:
  ///
  ///index 0: question String
  ///
  ///index 1: answer String
  static Future<List<List<String>>> getQuestions(int quizId) async {
    List<dynamic> data = await customGet(
        "SELECT question_question, question_answer FROM questions WHERE question_quiz_id = $quizId ORDER BY question_number ASC");
    List<List<String>> result = List.empty(growable: true);
    for (var row in data) {
      result.add(row);
    }
    return result;
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
  static Future<void> addQuestion(String question, String answer, int number, int quizId) async{
    await customPost("INSERT INTO questions(question_question, question_answer, question_number, question_quiz_id)VALUES('$question','$answer', $number, $quizId)");
  }

///deletes a question from the questions table specified by the given [number] and the given [quizId]
  static Future<void> removeQuestion(int number, int quizId) async{
    await customPost("DELETE FROM questions WHERE question_number = $number AND question_quiz_id = $quizId");
  }

///adds a quiz to the remote database
///
///questionList needs to look like the following:
///
///[[quiz_id, question, answer, number], usw.]
  static Future<void> addQuiz(String name, List<List<dynamic>> questions)async{
    int numberOfQuestions = questions.length;
    await customPost("INSERT INTO quizes(quiz_name, quiz_numberOfQuestion, quiz_learned) VALUES('$name', $numberOfQuestions, 0)");
    await customPost("INSERT INTO questions(question_quiz_id, question_question, question_answer, question_number) " + mapValuesForInsertion(prepareValuesForInsertion(questions)));
  }

///deletes a quiz from the remote database needing the given [quizId]
  static Future<void> removeQuiz(int quizId) async{
    await customPost("DELETE FROM quizes WHERE quiz_id = $quizId");
  }
}
