import 'package:flutter/material.dart';
import 'dbhelper.dart';

void main() => runApp(ShoppingListApp());

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();
    helper.testDb();

    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Container(),
    );
  }
}
