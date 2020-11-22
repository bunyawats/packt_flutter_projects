import 'package:webstorage/webstorage.dart';

class TimerHelper{

  static const String WORK_TIME = "workTime";
  static const String SHORT_BREAK = "shortBreak";
  static const String LONG_BREAK = "longBreak";

  static final service = LocalStorage();

  static int getWorkTime() => _getIntByKey(WORK_TIME, 40);
  static int getShortBreak() => _getIntByKey(SHORT_BREAK, 5);
  static int getLongBreak() => _getIntByKey(LONG_BREAK, 20);

  static void setWorkTime(int value) => _setIntByKey(WORK_TIME, value);
  static void setShortBreak(int value) => _setIntByKey(SHORT_BREAK, value);
  static void setLongBreak(int value) => _setIntByKey(LONG_BREAK, value);

  static int _getIntByKey(String key, int defaultValue ) {
    String valueStr = service.get(key);
    int value = defaultValue;
    if (valueStr == null) {
      service.set(key, defaultValue.toString());
    } else {
      value = int.tryParse(valueStr);
    }
    return value;
  }

  static _setIntByKey(String key, int value) {
    service.set(key, value.toString());
  }

}