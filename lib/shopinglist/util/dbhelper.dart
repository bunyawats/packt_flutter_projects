import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper {
  final int version = 1;
  Database db;

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

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

    // await db.execute('INSERT INTO lists VALUES ( 1, "Fruit", 2)');
    // await db.execute(
    //     'INSERT INTO items VALUES(1 , 1 , "Apples", "2 Kg", "Better if they are green")');

    ShoppingList list = ShoppingList(
      id: 0,
      name: 'Fruit',
      priority: 3,
    );
    int idList = await insertList(list);
    ListItem item = ListItem(
      id: 0,
      idList: idList,
      name: 'Apples',
      quantity: '2 Kg',
      note: 'Better if they are green',
    );
    int itemId = await insertItem(item);

    list = ShoppingList(
      id: 0,
      name: 'Bakery',
      priority: 2,
    );
    idList = await insertList(list);
    item = ListItem(
      id: 0,
      idList: idList,
      name: 'Bread',
      quantity: 'note',
      note: '1 kg',
    );
    itemId = await insertItem(item);

    List lists = await db.rawQuery('SELECT * FROM lists');
    List items = await db.rawQuery('SELECT * FROM items');

    lists.forEach((element) { print(element);});
    items.forEach((element) { print(element);});

    print('\n');
  }

  Future<int> insertList(ShoppingList list) async {

    print('on insert list $list');

    int id = await this.db.insert(
          'lists',
          list.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    print('on insert item $item');

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
        id: maps[index]['id'],
        name: maps[index]['name'],
        priority: maps[index]['priority'],
      );
    });
  }

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'idList = ?',
      whereArgs: [idList],
    );

    return List.generate(
      maps.length,
      (index) {
        return ListItem(
          id: maps[index]['id'],
          idList: maps[index]['idList'],
          name: maps[index]['name'],
          quantity: maps[index]['quantity'],
          note: maps[index]['note'],
        );
      },
    );
  }

  Future<int> deleteList(ShoppingList list) async {
    int result = await db.delete(
      'items',
      where: ' idList =  ?',
      whereArgs: [list.id],
    );
    result = await db.delete(
      'lists',
      where: ' id = ? ',
      whereArgs: [list.id],
    );

    return result;
  }

  Future<int> deleteItem(ListItem item) async {
    int result = await db.delete(
      'items',
      where: ' id =  ?',
      whereArgs: [item.id],
    );

    return result;
  }
}
