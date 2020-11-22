import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/timer_helper.dart';
import 'package:hello_world/productivity/ui/widgets.dart';

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

  final double buttonSize = 20.0;

  int workTime = 30;
  int shortBreak = 5;
  int longBreak = 20;

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
            setting: TimerHelper.WORK_TIME,
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
            setting: TimerHelper.WORK_TIME,
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
            setting: TimerHelper.SHORT_BREAK,
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
            setting: TimerHelper.SHORT_BREAK,
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
            setting: TimerHelper.LONG_BREAK,
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
            setting: TimerHelper.LONG_BREAK,
            callback: updateSetting,
          ),
        ],
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }

  _readSetting()  async {
    workTime = await TimerHelper.getWorkTime();
    shortBreak = await TimerHelper.getShortBreak();
    longBreak = await TimerHelper.getLongBreak();

    setState(() {
      txWork.text = workTime.toString();
      txShort.text = shortBreak.toString();
      txLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) async {
    print("key: $key, value: $value");

    switch (key) {
      case TimerHelper.WORK_TIME:
        {
          workTime = await TimerHelper.getWorkTime();
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            await TimerHelper.setWorkTime(workTime);
            setState(() {
              txWork.text = workTime.toString();
            });
          }
        }
        break;
      case TimerHelper.SHORT_BREAK:
        {
          shortBreak = await TimerHelper.getShortBreak();
          shortBreak += value;
          if (shortBreak >= 1 && shortBreak <= 120) {
            await TimerHelper.setShortBreak(shortBreak);
            setState(() {
              txShort.text = shortBreak.toString();
            });
          }
        }
        break;
      case TimerHelper.LONG_BREAK:
        {
          longBreak = await TimerHelper.getLongBreak();
          longBreak += value;
          if (longBreak >= 1 && longBreak <= 180) {
            await TimerHelper.setLongBreak(longBreak);
            setState(() {
              txLong.text = longBreak.toString();
            });
          }
        }
        break;
    }
  }
}
