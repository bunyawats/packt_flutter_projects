import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../data/todo.dart';
import '../data/todo_db.dart';

class TodoBloc {
  TodoDb db;
  List<Todo> todoList;

  final _streamController = StreamController<List<Todo>>.broadcast();
  final _insertController = StreamController<Todo>();
  final _updateController = StreamController<Todo>();
  final _deleteController = StreamController<Todo>();

  Function callBack;

  TodoBloc() {
    db = TodoDb();
    getTodoList();

    _streamController.stream.listen(_listTodo);
    _insertController.stream.listen(_insertTodo);
    _updateController.stream.listen(_updateTodo);
    _deleteController.stream.listen(_deleteTodo);
  }

  void setCallBack({Function callBack}) {
    this.callBack = callBack;
  }

  Stream<List<Todo>> get todoStream => _streamController.stream;

  Future getTodoList() async {
    todoList = await db.getTodoList();
    debugPrint('after db.getTodoList');
    _streamController.sink.add(todoList);
  }

  List<Todo> _listTodo(List<Todo> todoList) {
    return todoList;
  }

  void deleteTodo(Todo todo) {
    _deleteController.sink.add(todo);
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((result) {
      debugPrint('after db.deleteTodo');
      getTodoList();
    });
  }

  void updateTodo(Todo todo) {
    _updateController.sink.add(todo);
  }

  void _updateTodo(Todo todo) {
    db.updateTodo(todo).then((result) async {
      debugPrint('after db.updateTodo');
      await getTodoList();
      this.callBack();
    });
  }

  void insertTodo(Todo todo) {
    _insertController.sink.add(todo);
  }

  void _insertTodo(Todo todo) {
    db.insertTodo(todo).then((result) async {
      debugPrint('after db.insertTodo');
      await getTodoList();
      this.callBack();
    });
  }

  void dispose() {
    _streamController.close();
    _insertController.close();
    _updateController.close();
    _deleteController.close();
  }
}
