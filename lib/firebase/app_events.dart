import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './screens/launch_screen.dart';

void main() => runApp(FireBaseApp());

class FireBaseApp extends StatelessWidget {
  Future testData() async {
    Firestore db = Firestore.instance;

    var data = await db.collection('event_details').getDocuments();
    var details = data.documents.toList();
    details.forEach((d) {
      print(d.documentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    // testData();

    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LaunchScreen(),
    );
  }
}
