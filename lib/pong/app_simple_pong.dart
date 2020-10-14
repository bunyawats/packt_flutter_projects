import 'package:flutter/material.dart';
import 'pong.dart';

void main() => runApp(PongApp());

class PongApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pong Demo'),
        ),
        body: SafeArea(
          child: Pong(),
        ),
      ),
    );
  }
}
