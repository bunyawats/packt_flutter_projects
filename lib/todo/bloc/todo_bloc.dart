import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../data/todo.dart';
import '../data/todo_db.dart';

class TodoBloc {
  TodoDb db;
  List<Todo> todoList;
  Function callBack;

  final _streamController = StreamController<List<Todo>>.broadcast();

  Stream<List<Todo>> get todoStream => _streamController.stream;

  TodoBloc() {
    db = TodoDb();
    _getTodoList();

    _streamController.stream.listen(_listTodo);
  }

  void setCallBack({Function callBack}) {
    this.callBack = callBack;
  }

  Future _getTodoList() async {
    var _todoList = await db.getTodoList();
    debugPrint('after db.getTodoList');
    _streamController.sink.add(_todoList);
  }

  void _listTodo(List<Todo> todoList) {
    this.todoList = todoList;
  }

  void deleteTodo(Todo todo) async {
    await db.deleteTodo(todo);
    debugPrint('after db.deleteTodo');
    await _getTodoList();
  }

  void updateTodo(Todo todo) async {
    await db.updateTodo(todo);
    debugPrint('after db.updateTodo');
    this.callBack();
  }

  void insertTodo(Todo todo) async {
    await db.insertTodo(todo);
    debugPrint('after db.insertTodo');
    this.callBack();
  }

  void dispose() {
    _streamController.close();
  }
}
