import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'todo.dart';

class TodoDb {
  static final TodoDb _singleton = TodoDb._internal();
  TodoDb._internal();

  factory TodoDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('todo');
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
      // await this.deleteAll();
    }
    return _database;
  }

  Future _openDb() async {
    final docPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);

    return db;
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  Future updateTodo(Todo todo) async {
    final finder = Finder(
      filter: Filter.byKey(todo.id),
    );
    await store.update(
      _database,
      todo.toMap(),
      finder: finder,
    );
  }

  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

  Future<List<Todo>> getTodoList() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'),
      SortOrder('id'),
    ]);

    final todosSnapshot = await store.find(
      _database,
      finder: finder,
    );

    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

  Future testData() async {
    await this.database;
    List<Todo> todos = await this.getTodoList();
    await this.deleteAll();
    todos = await this.getTodoList();

    await this.insertTodo(
      Todo('Call Donald', 'And tell him about Daisy', '02/02/2020', 1),
    );
    await this.insertTodo(
      Todo('Buy Sugar', '1 Kg, brown', '02/02/2020', 2),
    );
    await this.insertTodo(
      Todo('Go Running', '@12.00, with neighbours', '02/02/2020', 3),
    );
    todos = await this.getTodoList();

    debugPrint('First insert');
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });

    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Tim';
    await this.updateTodo(todoToUpdate);

    Todo todoDelete = todos[1];
    await this.deleteTodo(todoDelete);

    debugPrint('After Updates');
    todos = await this.getTodoList();
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });
  }
}
