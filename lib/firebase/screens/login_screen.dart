import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String _userId;
  String _password;
  String _email;
  String _message = 'No Error';

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Future submit() {
    return null;
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: 120,
      ),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'email',
          icon: Icon(Icons.mail),
        ),
        validator: (text) => text.isEmpty ? 'Email is required' : '',
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'password',
          icon: Icon(Icons.enhanced_encryption),
        ),
        validator: (text) => text.isEmpty ? 'Password is required' : '',
      ),
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Theme.of(context).accentColor,
          elevation: 3,
          child: Text(buttonText),
          onPressed: submit,
        ),
      ),
    );
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? 'Login' : 'Sign up';
    return FlatButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget validationMessage() {
    return Text(
      _message,
      style: TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                emailInput(),
                passwordInput(),
                mainButton(),
                secondaryButton(),
                validationMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
