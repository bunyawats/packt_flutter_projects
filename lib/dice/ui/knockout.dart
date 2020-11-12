import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../models/dice.dart';
import 'single.dart';

class KnockOutScreen extends StatefulWidget {
  @override
  _KnockOutScreenState createState() => _KnockOutScreenState();
}

class _KnockOutScreenState extends State<KnockOutScreen> {
  int _playerScore = 0;
  int _aiScore = 0;
  String _animation1;
  String _animation2;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _animation1 = 'Start';
    _animation2 = 'Start';
    super.initState();
  }

  Future play(BuildContext context) async {
    String message = '';

    setState(() {
      _animation1 = 'Roll';
      _animation2 = 'Roll';
    });

    Dice.wait3seconds().then((_) {
      Map<int, String> animation1 = Dice.getRandomAnimation();
      Map<int, String> animation2 = Dice.getRandomAnimation();

      int result = animation1.keys.first + 1 + animation2.keys.first + 1;
      int aiResult = Dice.getRandomNumber() + Dice.getRandomNumber();

      if (result == 7) result = 0;
      if (aiResult == 7) aiResult = 0;

      setState(() {
        _playerScore += result;
        _aiScore += aiResult;
        _animation1 = animation1.values.first;
        _animation2 = animation2.values.first;
      });

      if (_playerScore >= 50 || _aiScore >= 50) {
        if (_playerScore > _aiScore) {
          message = 'You win!';
        } else if (_playerScore == _aiScore) {
          message = 'Draw!';
        } else {
          message = 'You lose!';
        }
        showMessage(message);
      }
    });
  }

  Future showMessage(String message) async {
    print('message: $message');

    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void reset() {
    setState(() {
      _animation1 = 'Start';
      _animation2 = 'Start';
      _aiScore = 0;
      _playerScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Knockout Game'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.repeat_one),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => Single(),
              );
              Navigator.push(context, route);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: height / 3,
                    width: width / 2.5,
                    child: FlareActor(
                      'assets/dice.flr',
                      fit: BoxFit.contain,
                      animation: _animation1,
                    ),
                  ),
                  Container(
                    height: height / 3,
                    width: width / 2.5,
                    child: FlareActor(
                      'assets/dice.flr',
                      fit: BoxFit.contain,
                      animation: _animation2,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GameText('Player: ', Colors.deepOrange, false),
                  GameText(_playerScore.toString(), Colors.white, true),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(height / 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GameText('AI: ', Colors.deepOrange, false),
                  GameText(_aiScore.toString(), Colors.white, true),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(height / 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: width / 3,
                    height: height / 10,
                    child: RaisedButton(
                      child: Text('Play'),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      onPressed: () {
                        play(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    height: height / 10,
                    child: RaisedButton(
                      child: Text('Restart'),
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      onPressed: () {
                        reset();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameText extends StatelessWidget {
  final String text;
  final Color color;
  final bool isBordered;

  GameText(this.text, this.color, this.isBordered);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isBordered ? Border.all() : null,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color: color,
        ),
      ),
    );
  }
}
