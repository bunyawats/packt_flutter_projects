import 'package:flutter/material.dart';
import 'util/dbhelper.dart';
import 'models/shopping_list.dart';
import 'models/list_items.dart';

void main() => runApp(ShoppingListApp());

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {

  DbHelper helper = DbHelper();

  Future showData() async {
    await helper.openDb();

    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);

    ListItem item = ListItem(0, listId, 'Bread', 'noted', 'i kg');
    int itemId = await helper.insertItem(item);

    print('List id: $listId');
    print('Item id: $itemId');
  }

  @override
  Widget build(BuildContext context) {

    showData();
    return Container();
  }
}
