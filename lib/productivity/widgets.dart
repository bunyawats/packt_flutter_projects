import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      color: this.color,
      minWidth: this.size,
    );
  }

  ProductivityButton(
      {@required this.color,
      @required this.text,
      this.size,
      @required this.onPressed});
}

class SettingButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final double size;
  final String setting;
  final CallbackSetting callback;

  const SettingButton({
    Key key,
    this.color,
    this.text,
    this.value,
    this.size,
    this.setting,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => this.callback(
        this.setting,
        this.value,
      ),
      color: this.color,
    );
  }
}
