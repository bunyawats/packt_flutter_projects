import 'package:flutter/material.dart';
import 'data/todo_db.dart';
import 'data/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos BloC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();

    await db.insertTodo(
      Todo('Call Donald', 'And tell him about Daisy', '02/02/2020', 1),
    );
    await db.insertTodo(
      Todo('Buy Sugar', '1 Kg, brown', '02/02/2020', 2),
    );
    await db.insertTodo(
      Todo('Go Running', '@12.00, with neighbours', '02/02/2020', 3),
    );
    todos = await db.getTodos();

    debugPrint('First insert');
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });

    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Tim';
    await db.updateTodo(todoToUpdate);

    Todo todoDelete = todos[1];
    await db.deleteTodo(todoDelete);

    debugPrint('After Updates');
    todos = await db.getTodos();
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    _testData();
    return Container();
  }
}
