import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'session.dart';
import 'session_manager.dart';
import 'timer.dart';

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
                    fontSize: 128,
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
              SizedBox(height: 300),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: _isStarted ? null : start,
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.white, // <-- Button color
                        foregroundColor: Colors.lightBlue),
                    child: const Icon(
                      Icons.play_arrow,
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
