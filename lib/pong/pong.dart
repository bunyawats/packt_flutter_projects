import 'package:flutter/material.dart';
import 'dart:math';

import 'ball.dart';
import 'bat.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double width = 0;
  double height = 0;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;

  Animation<double> animation;
  AnimationController controller;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  double ranX = 1;
  double ranY = 1;

  int score = 0;

  final int incremental = 5;

  void checkBorders() {
    double diameter = 50;
    // to left
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      ranX = randomNumber();
    }
    // to right
    if (posX >= (width - diameter) && hDir == Direction.right) {
      hDir = Direction.left;
      ranX = randomNumber();
    }
    // to bottom
    if (posY >= (height - diameter) && vDir == Direction.down) {
      //check if bat is here otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        ranY = randomNumber();

        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    // to top
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      ranY = randomNumber();
    }
  }

  @override
  void initState() {
    posX = 0;
    posY = 0;

    controller = AnimationController(
      duration: const Duration(
        minutes: 100000,
      ),
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(controller);

    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += (incremental * ranX).round()
            : posX -= (incremental * ranX).round();
        (vDir == Direction.down)
            ? posY += (incremental * ranY).round()
            : posY -= (incremental * ranY).round();
      });
      checkBorders();
    });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;

        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 24,
              child: Text('Score: $score'),
            ),
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ),
            Positioned(
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(
                  batWidth,
                  batHeight,
                ),
              ),
              bottom: 0,
              left: batPosition,
            )
          ],
        );
      },
    );
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    //this is random number between 0.5 - 1.5
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Game Over'),
              content: Text('Would you like to play again'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    setState(() {
                      posX = 0;
                      posY = 0;
                      score = 0;
                    });
                    Navigator.of(context).pop();
                    controller.repeat();
                  },
                  child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dispose();
                  },
                  child: Text('No'),
                ),
              ]);
        });
  }
}
