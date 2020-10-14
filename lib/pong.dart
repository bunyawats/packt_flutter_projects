import 'package:flutter/material.dart';
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

  final int incremental = 10;

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }
    if (posX >= (width - 50) && hDir == Direction.right) {
      hDir = Direction.left;
    }
    if (posY >= (height - 50) && vDir == Direction.down) {
      vDir = Direction.up;
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
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
      setState(() {
        (hDir == Direction.right) ? posX += incremental : posX -= incremental;
        (vDir == Direction.down) ? posY += incremental : posY -= incremental;
      });
      checkBorders();
    });

    controller.forward();

    super.initState();
  }

  @override
  void dispose(){
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
    setState(() {
      batPosition += update.delta.dx;
    });
  }
}
