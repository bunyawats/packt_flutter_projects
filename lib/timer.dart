import 'dart:async';
import 'package:webstorage/webstorage.dart';
import 'timer_model.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = true;
  Duration _time;
  Duration _fullTime;

  Timer timer;

  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";

  final service = LocalStorage();

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();
    String formattedTime = minutes + ":" + seconds;

    return formattedTime;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(
      Duration(seconds: 1),
      (int a) {
        String time;
        if (this._isActive) {
          _time = _time -
              Duration(
                seconds: 1,
              );
          _radius = _time.inSeconds / _fullTime.inSeconds;
          if (_time.inSeconds <= 0) {
            _isActive = false;
          }
        }
        time = returnTime(_time);
        return TimerModel(time, _radius);
      },
    );
  }

  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(
      minutes: (isShort) ? shortBreak : longBreak,
      seconds: 0,
    );
    _fullTime = _time;
  }

  readSettings() {
    work = int.tryParse(service.get(WORKTIME));
    shortBreak = int.tryParse(service.get(SHORTBREAK));
    longBreak = int.tryParse(service.get(LONGBREAK));
  }
}
