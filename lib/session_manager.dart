import 'package:flutter/material.dart';

import 'session.dart';

class PomodoroSessionManager {
  static const int start = 1;
  static const int end = 8;

  var focus = 25;
  var smallBreak = 5;
  var longBreak = 30;

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
        timerMinutes = focus;
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
