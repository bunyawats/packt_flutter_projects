import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webdriver/async_core.dart';

import '../models/place.dart';
import '../helpers/dbhelper.dart';

class PlaceDialog {
  final txtName = TextEditingController();
  final txtLat = TextEditingController();
  final txtLon = TextEditingController();

  final bool isNew;
  final Place place;

  PlaceDialog(this.place, this.isNew);

  Widget buildAlert(BuildContext context) {
    DbHelper helper = DbHelper();

    txtName.text = place.name;
    txtLat.text = place.lat.toString();
    txtLon.text = place.lon.toString();

    return AlertDialog(
      title: Text('Place'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            TextField(
              controller: txtLat,
              decoration: InputDecoration(
                hintText: 'Latitude',
              ),
            ),
            TextField(
              controller: txtLon,
              decoration: InputDecoration(
                hintText: 'Longitude',
              ),
            ),
            RaisedButton(
              child: Text('OK'),
              onPressed: () {
                place.name = txtName.text;
                place.lat = double.parse(txtLat.text);
                place.lon = double.parse(txtLon.text);
                helper.insertPlace(place);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
