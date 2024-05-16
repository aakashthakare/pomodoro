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

class PomodoroSession {
  String title;
  int seconds;
  Color color;

  PomodoroSession(this.title, this.seconds, this.color);
}

class PomodoroSessionManager {
  static const int start = 1;
  static const int end = 8;

  var session = 10;
  var smallBreak = 3;
  var longBreak = 20;

  var state = 1;

  next() {
    int timerMinutes;
    String title;
    Color color;

    if (state == end) {
      state = start;
      timerMinutes = longBreak;
      title = "Long Break";
      color = Colors.blueGrey;
    } else {
      if (state % 2 != 0) {
        timerMinutes = session;
        title = "Focus";
        color = Colors.lightGreen;
      } else {
        timerMinutes = smallBreak;
        color = Colors.lightBlue;
        title = "Break";
      }
      state++;
    }
    return PomodoroSession(
        title, Duration(minutes: timerMinutes).inSeconds, color);
  }

  clear() {
    state = 1;
  }
}

class PomodoroTimerState extends State<PomodoroTimer> {
  static PomodoroSessionManager sessionManager = PomodoroSessionManager();
  static PomodoroSession session = sessionManager.next();
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

    String timer;

    if (hours == "00") {
      timer = "$minutes:$seconds";
    } else {
      timer = "$hours:$minutes:$seconds";
    }

    return Container(
        color: session.color,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text(
                timer,
                style: TextStyle(
                    fontSize: 124,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                session.title,
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
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
            ])));
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
      pause();
      _isStarted = false;
      sessionManager.clear();
      session = sessionManager.next();
      updateDuration();
    });
  }

  updateDuration() {
    duration = Duration(seconds: session.seconds);
  }

  tick() {
    setState(() {
      session.seconds -= 1;
      if (session.seconds == 0) {
        session = sessionManager.next();
        ringTheBell();
      }
      updateDuration();
    });
  }

  ringTheBell() async {
    AudioPlayer player = AudioPlayer();
    await player.play(AssetSource('bell.wav'));
  }
}
