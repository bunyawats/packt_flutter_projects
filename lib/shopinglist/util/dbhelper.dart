import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper {
  final int version = 1;
  Database db;

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
          database.execute('''
          CREATE TABLE lists(
            id INTEGER PRIMARY KEY, 
            name TEXT,
            priority INTEGER
          )
          ''');
          database.execute(''' 
          CREATE TABLE items(
            id INTEGER PRIMARY KEY, 
            idList INTEGER, 
            name TEXT, 
            quantity TEXT, 
            note TEXT, 
            FOREIGN KEY(idList) 
            REFERENCES lists(id)
          )
          ''');
        },
        version: version,
      );

      return db;
    }
  }

  Future testDb() async {
    db = await openDb();

    await db.execute('DELETE FROM lists');
    await db.execute('DELETE FROM items');

    await db.execute('INSERT INTO lists VALUES ( 0, "Fruit", 2)');
    await db.execute(
        'INSERT INTO items VALUES(0,0, "Apples", "2 Kg", "Better if they are green")');

    List lists = await db.rawQuery('SELECT * FROM lists');
    List items = await db.rawQuery('SELECT * FROM items');

    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await insertList(list);
    ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    int itemId = await insertItem(item);
    print('List Id: ' + listId.toString());
    print('Item Id: '+ itemId.toString());

    print(lists[0].toString());
    print(items[0].toString());
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await this.db.insert(
          'lists',
          list.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await this.db.insert(
          'items',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db.query('lists');

    return List.generate(maps.length, (index) {
      return ShoppingList(
        maps[index]['id'],
        maps[index]['name'],
        maps[index]['priority'],
      );
    });
  }
}
