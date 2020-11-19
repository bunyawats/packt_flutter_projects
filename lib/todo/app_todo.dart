import 'package:flutter/material.dart';
import 'data/todo.dart';
import 'bloc/todo_bloc.dart';
import 'ui/todo_screen.dart';

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
  TodoBloc todoBloc;

  @override
  void initState() {
    debugPrint('do _HomePageState initState');
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  FloatingActionButton buildAddTodoButton(BuildContext context, Todo todo) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoScreen(todo, true),
          ),
        );
      },
    );
  }

  ListView buildTodoListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(snapshot.data[index].id.toString()),
          onDismissed: (_) {
            todoBloc.deleteTodo(snapshot.data[index]);
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor,
              child: Text('${snapshot.data[index].priority}'),
            ),
            title: Text('${snapshot.data[index].name}'),
            subtitle: Text('${snapshot.data[index].description}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TodoScreen(snapshot.data[index], false);
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    debugPrint('do _HomePageState build');

    Todo todo = Todo('', '', '', 0);

    todoBloc.getTodoList();
    List<Todo> todoList = todoBloc.todoList;

    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      floatingActionButton: buildAddTodoButton(context, todo),
      body: Container(
        child: StreamBuilder<List<Todo>>(
          stream: todoBloc.todoStream,
          initialData: todoList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return buildTodoListView(snapshot);
          },
        ),
      ),
    );
  }
}
