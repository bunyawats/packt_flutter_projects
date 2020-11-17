import 'dart:async';
import '../data/todo.dart';
import '../data/todo_db.dart';

class TodoBloc {
  TodoDb db;
  List<Todo> todoList;

  final _todoStreamController = StreamController<List<Todo>>.broadcast();
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  Stream<List<Todo>> get todos => _todoStreamController.stream;
  StreamSink<List<Todo>> get todoSink => _todoStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoInsertController.sink;

  TodoBloc() {
    db = TodoDb();
    getTodos();

    _todoStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
  }

  void dispose() {
    _todoStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todoSink.add(todos);
  }

  List<Todo> returnTodos(List<Todo> todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((result) {
      getTodos();
    });
  }

  void _updateTodo(Todo todo) {
    db.updateTodo(todo).then((result) {
      getTodos();
    });
  }

  void _addTodo(Todo todo) {
    db.insertTodo(todo).then((result) {
      getTodos();
    });
  }
}
