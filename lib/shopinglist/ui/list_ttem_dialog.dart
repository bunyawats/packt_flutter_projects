import 'package:flutter/material.dart';
import '../models/list_items.dart';
import '../util/dbhelper.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();

    print('on open item dialog: $item');

    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity.toString();
      txtNote.text = item.note;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New Shopping Item' : 'Edit Shopping Item'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping Item Name',
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                hintText: 'Shopping Item Quantity',
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                hintText: 'Shopping Item Note',
              ),
            ),
            RaisedButton(
              child: Text('Save Shopping Item'),
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;

                print('on save shopping item $isNew');

                helper.insertItem(item);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
