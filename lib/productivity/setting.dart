import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webstorage/webstorage.dart';
import 'package:hello_world/widgets.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController txWork;
  TextEditingController txShort;
  TextEditingController txLong;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";

  final double buttonSize = 20.0;

  int workTime = 30;
  int shortBreak = 5;
  int longBreak = 20;

  final service = LocalStorage();

  TextStyle textStyle = TextStyle(
    fontSize: 24,
  );

  @override
  void initState() {
    txWork = TextEditingController();
    txShort = TextEditingController();
    txLong = TextEditingController();

    _readSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: <Widget>[
          Text(
            "Work",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            size: buttonSize,
            setting: WORKTIME,
            callback: updateSetting,
          ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: txWork,
          ),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            size: buttonSize,
            setting: WORKTIME,
            callback: updateSetting,
          ),
          Text(
            "Short",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            size: buttonSize,
            setting: SHORTBREAK,
            callback: updateSetting,
          ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: txShort,
          ),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            size: buttonSize,
            setting: SHORTBREAK,
            callback: updateSetting,
          ),
          Text(
            "Long",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            size: buttonSize,
            setting: LONGBREAK,
            callback: updateSetting,
          ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: txLong,
          ),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            size: buttonSize,
            setting: LONGBREAK,
            callback: updateSetting,
          ),
        ],
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }

  _readSetting() async {
    print("call _readSetting");
    workTime = int.tryParse(service.get(WORKTIME));
    print('workTime from local store : $workTime');
    if (workTime == null) {
      workTime = 40;
      service.set(WORKTIME, workTime.toString());
    }
    shortBreak = int.tryParse(service.get(SHORTBREAK));
    if (shortBreak == null) {
      shortBreak = 5;
      service.set(SHORTBREAK, shortBreak.toString());
    }
    longBreak = int.tryParse(service.get(LONGBREAK));
    if (longBreak == null) {
      longBreak = 20;
      service.set(LONGBREAK, longBreak.toString());
    }

    setState(() {
      txWork.text = workTime.toString();
      txShort.text = shortBreak.toString();
      txLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    print("key: $key, value: $value");

    switch (key) {
      case WORKTIME:
        {
          workTime = int.tryParse(service.get(WORKTIME));
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            service.set(WORKTIME, workTime.toString());
            setState(() {
              txWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          shortBreak = int.tryParse(service.get(SHORTBREAK));
          shortBreak += value;
          if (shortBreak >= 1 && shortBreak <= 120) {
            service.set(SHORTBREAK, shortBreak.toString());
            setState(() {
              txShort.text = shortBreak.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          longBreak = int.tryParse(service.get(LONGBREAK));
          longBreak += value;
          if (longBreak >= 1 && longBreak <= 180) {
            service.set(LONGBREAK, longBreak.toString());
            setState(() {
              txLong.text = longBreak.toString();
            });
          }
        }
        break;
    }
  }
}
