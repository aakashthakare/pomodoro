import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

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
  static var pomodoroMinutes = 1;
  static var totalSeconds = pomodoroMinutes * 60;
  static Duration duration = Duration(seconds: 0);
  bool _isStarted = false;

  Timer? timer;

  @override
  void initState() {
    updateDuration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildTimer(),
    );
  }

  buildTimer() {
    var hours = (duration.inMinutes ~/ 60).toString().padLeft(2, '0');
    var minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    var seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return Center(
        child: Column(children: [
      Text(
        "$hours:$minutes:$seconds",
        style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: _isStarted ? null : start,
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.white, // <-- Button color
                foregroundColor: Colors.lightBlue),
            child: const Icon(
              Icons.play_circle,
              size: 50,
            )),
        ElevatedButton(
            onPressed: _isStarted ? pause : null,
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.white, // <-- Button color
                foregroundColor: Colors.lightBlue),
            child: const Icon(
              Icons.pause,
              size: 50,
            )),
        ElevatedButton(
            onPressed: reset,
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.white, // <-- Button color
                foregroundColor: Colors.lightBlue),
            child: const Icon(
              Icons.restore,
              size: 50,
            ))
      ])
    ]));
  }

  start() {
    setState(() {
      _isStarted = true;
      timer = Timer.periodic(Duration(seconds: 1), (_) => tick());
    });
  }

  pause() {
    setState(() {
      _isStarted = false;
      timer?.cancel();
    });
  }

  reset() {
    setState(() {
      totalSeconds = pomodoroMinutes * 60;
      pause();
    });
  }

  updateDuration() {
    duration = Duration(seconds: totalSeconds);
  }

  tick() {
    setState(() {
      totalSeconds--;
      if (totalSeconds == 0) {
        reset();
        ringTheBell();
      } else {
        updateDuration();
      }
    });
  }

  ringTheBell() async {
    AudioPlayer player = AudioPlayer();
    await player.play(AssetSource('bell.wav'));
  }
}
