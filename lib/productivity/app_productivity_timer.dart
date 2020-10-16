import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'setting.dart';
import 'timer_model.dart';
import 'widgets.dart';
import 'timer.dart';

void main() => runApp(ProductivityApp());

class ProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5.0;
  final CountDownTimer timer = CountDownTimer();

  void goToSetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timer.startWork();

    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Work Timer'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') {
                goToSetting(context);
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
          final double availableWidth = constraint.maxWidth;
          return Column(
            children: [
              TopButtonBar(defaultPadding: defaultPadding, timer: timer),
              Expanded(
                child:
                    WorkIndicator(timer: timer, availableWidth: availableWidth),
              ),
              BottomButtonBar(defaultPadding: defaultPadding, timer: timer)
            ],
          );
        },
      ),
    );
  }
}

class BottomButtonBar extends StatelessWidget {
  const BottomButtonBar({
    Key key,
    @required this.timer,
    @required this.defaultPadding,
  }) : super(key: key);

  final double defaultPadding;
  final CountDownTimer timer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff212121),
            text: "Stop",
            onPressed: () => timer.stopTimer(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Start",
            onPressed: () => timer.startTimer(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
      ],
    );
  }
}

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({
    Key key,
    @required this.timer,
    @required this.defaultPadding,
  }) : super(key: key);

  final double defaultPadding;
  final CountDownTimer timer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Work",
            onPressed: () => timer.startWork(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff607D88),
            text: "Short Break",
            onPressed: () => timer.startBreak(true),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff454A64),
            text: "Long Break",
            onPressed: () => timer.startBreak(false),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
        ),
      ],
    );
  }
}

class WorkIndicator extends StatelessWidget {
  const WorkIndicator({
    Key key,
    @required this.timer,
    @required this.availableWidth,
  }) : super(key: key);

  final CountDownTimer timer;
  final double availableWidth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
       // initialData: null,
        stream: timer.stream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          // print('snapshot: $snapshot');
          TimerModel timerModel = (snapshot.data == null )
              ? TimerModel('00:00', 1)
              : snapshot.data;

          return CircularPercentIndicator(
            radius: availableWidth / 2,
            lineWidth: 10.0,
            percent: timerModel.percent,
            center: Text(
              timerModel.time,
              style: Theme.of(context).textTheme.headline4,
            ),
            progressColor: Color(0xff009688),
          );
        });
  }
}
