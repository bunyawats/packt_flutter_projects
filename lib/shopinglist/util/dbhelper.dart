import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

    print(lists[0].toString());
    print(items[0].toString());
  }
}
