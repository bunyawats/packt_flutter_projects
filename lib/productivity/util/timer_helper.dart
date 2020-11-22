import 'package:shared_preferences/shared_preferences.dart';
import 'package:webstorage/webstorage.dart';

class TimerHelper {
  static const String WORK_TIME = "workTime";
  static const String SHORT_BREAK = "shortBreak";
  static const String LONG_BREAK = "longBreak";

  static final localStorage = LocalStorage();

  // static int getWorkTime() => _getIntByKey(WORK_TIME, 40);
  // static int getShortBreak() => _getIntByKey(SHORT_BREAK, 5);
  // static int getLongBreak() => _getIntByKey(LONG_BREAK, 20);
  //
  // static void setWorkTime(int value) => _setIntByKey(WORK_TIME, value);
  // static void setShortBreak(int value) => _setIntByKey(SHORT_BREAK, value);
  // static void setLongBreak(int value) => _setIntByKey(LONG_BREAK, value);

  static Future<int> getWorkTime() => _getIntByKeyPreferences(WORK_TIME, 40);
  static Future<int> getShortBreak() => _getIntByKeyPreferences(SHORT_BREAK, 5);
  static Future<int> getLongBreak() => _getIntByKeyPreferences(LONG_BREAK, 20);

  static Future setWorkTime(int value) => _setIntByKeyPreferences(WORK_TIME, value);
  static Future setShortBreak(int value) => _setIntByKeyPreferences(SHORT_BREAK, value);
  static Future setLongBreak(int value) => _setIntByKeyPreferences(LONG_BREAK, value);

  static int _getIntByKey(String key, int defaultValue) {
    String valueStr = localStorage.get(key);
    int value = defaultValue;
    if (valueStr == null) {
      localStorage.set(key, defaultValue.toString());
    } else {
      value = int.tryParse(valueStr);
    }
    return value;
  }

  static _setIntByKey(String key, int value) {
    localStorage.set(key, value.toString());
  }

  static Future<int> _getIntByKeyPreferences(String key, int defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String valueStr = preferences.getString(key);
    int value = defaultValue;
    if (valueStr == null) {
      await preferences.setString(key, defaultValue.toString());
    } else {
      value = int.tryParse(valueStr);
    }
    return value;
  }

  static Future _setIntByKeyPreferences(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value.toString());
  }
}
