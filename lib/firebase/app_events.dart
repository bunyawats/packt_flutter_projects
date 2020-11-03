import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';
import 'shared/authentication.dart';

void main() => runApp(FireBaseApp());

class FireBaseApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Authentication auth = Authentication();

    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LaunchScreen(),
    );
  }
}
