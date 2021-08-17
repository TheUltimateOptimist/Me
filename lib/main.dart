//contains main entry point of the app

//packages:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:me/Data/sync.dart';
import 'package:me/quizScreens/editQuestion.dart';
import 'package:me/quizScreens/specificQuiz.dart';
//import 'package:me/stackOverflow.dart';

//my imports:
import 'quizScreens/quizes.dart';
import 'PomodoroScreens/pomodoro.dart';
import 'package:me/PomodoroScreens/working.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (await (Connectivity().checkConnectivity()) != ConnectivityResult.none &&
  //     !kIsWeb) {
  //   await SyncDatabases.integrateRemoteChanges();
  //   SyncDatabases.pushLocalChanges();
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Me',
      initialRoute: "home/quizes",
      routes: {
        "home": (context) => MyHomePage(title: "Me"),
        "home/quizes": (context) => QuizScreen(),
        "home/pomodoro": (context) => PomodoroScreen(),

        //"test": (context) => CombinedHomeView()
      },
      home: MyHomePage(title: 'Me'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    //implement init State
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text(""),
    );
  }
}
