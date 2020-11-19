import 'package:flutter/material.dart';

import '../app_todo.dart';
import '../bloc/todo_bloc.dart';
import '../data/todo.dart';

class TodoScreen extends StatelessWidget {
  final Todo todo;
  final bool isNew;
  final TodoBloc bloc;

  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtCompleteBy = TextEditingController();
  final TextEditingController txtPriority = TextEditingController();

  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.parse(txtPriority.text);

    debugPrint('save: $todo');

    if (isNew) {
      bloc.insertTodoSink.add(todo);
    } else {
      bloc.updateTodoSink.add(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 20.0;
    txtName.text = todo.name;
    txtDescription.text = todo.description;
    txtCompleteBy.text = todo.completeBy;
    txtPriority.text = todo.priority.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtName,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtDescription,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtCompleteBy,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Complete by',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtPriority,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Priority',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: MaterialButton(
                color: Colors.green,
                child: Text('Save'),
                onPressed: () {
                  save().then((_) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                        (Route<dynamic> route) => false,
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
