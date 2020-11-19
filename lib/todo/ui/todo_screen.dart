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

  Padding buildTextField(
    TextEditingController textField,
    String label,
  ) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        controller: textField,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
        ),
      ),
    );
  }

  Future save({Function callBack}) async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.parse(txtPriority.text);

    debugPrint('save: $todo');

    bloc.setCallBack(callBack: callBack);
    if (isNew) {
      bloc.insertTodoSink.add(todo);
    } else {
      bloc.updateTodoSink.add(todo);
    }
  }

  Padding buildSaveButton(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: MaterialButton(
        color: Colors.green,
        child: Text(label),
        onPressed: () {
          save(
            callBack: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            buildTextField(txtName, 'Name'),
            buildTextField(txtDescription, 'Description'),
            buildTextField(txtCompleteBy, 'Complete by'),
            buildTextField(txtPriority, 'Priority'),
            buildSaveButton(context, 'Save'),
          ],
        ),
      ),
    );
  }
}
