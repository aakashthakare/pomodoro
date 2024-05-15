import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Pomodoro',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pomodoro",
      home: PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  PomodoroTimer();

  @override
  State<StatefulWidget> createState() => PomodoroTimerState();
}

class PomodoroTimerState extends State<PomodoroTimer> {
  static var totalSeconds = 1800;
  static Duration duration = Duration(seconds: 0);

  Timer? timer;

  @override
  void initState() {
    updateDuration();
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildTimer();
  }

  buildTimer() {
    return Center(
      child: Text(
        duration.inMinutes.toString(),
        style: TextStyle(fontSize: 120),
        textAlign: TextAlign.center,
      ),
    );
  }

  start() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => tick());
  }

  updateDuration() {
    duration = Duration(seconds: totalSeconds);
  }

  tick() {
    setState(() {
      totalSeconds--;
      updateDuration();
    });
  }
}
