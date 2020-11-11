import 'dart:io';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../helpers/dbhelper.dart';
import '../app_truasure_map.dart';

class PictureScreen extends StatelessWidget {
  final String imagePath;
  final Place place;

  PictureScreen(this.imagePath, this.place);

  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text('Save Picture'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              place.image = imagePath;
              helper.insertPlace(place);
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => MainMap(),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: Container(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
