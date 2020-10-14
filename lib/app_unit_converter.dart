import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      title: 'Measures Converter',
      home: ConverterApp(),
    ));

class ConverterApp extends StatefulWidget {
  @override
  ConverterAppState createState() => ConverterAppState();
}

class ConverterAppState extends State<ConverterApp> {
  String _startMeasure;
  String _convertedMeasure;
  double _numberForm;
  String _resultMessage;

  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  void convert(double value, String from, String to) {
    int nFrom = _measuresMap[from];
    int nTo = _measuresMap[to];

    print('nFrom $nFrom nTo $nTo');

    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;

    if (result == 0) {
      _resultMessage = 'This conversion cannot be perdormed';
    } else {
      _resultMessage =
          '${_numberForm.toString()} $_startMeasure are ${result.toString()} ';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  @override
  void initState() {
    _numberForm = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeX = MediaQuery.of(context).size.width;
    double sizeY = MediaQuery.of(context).size.height;

    final TextStyle inputStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[900],
    );

    final TextStyle labelStyle = TextStyle(
      fontSize: 24,
      color: Colors.grey[700],
    );

    final spacer = Padding(
      padding: EdgeInsets.only(bottom: sizeY / 40),
    );

    final List<String> _measures = [
      'meters',
      'kilometers',
      'grams',
      'kilograms',
      'feet',
      'miles',
      'pounds (lps)',
      'ounces',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Measures Converter '),
      ),
      body: Container(
        width: sizeX,
        padding: EdgeInsets.all(sizeX / 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              spacer,
              Text(
                'Value',
                style: labelStyle,
              ),
              spacer,
              TextField(
                style: inputStyle,
                decoration: InputDecoration(
                    hintText: "Please insert the measure to be converted"),
                onChanged: (text) {
                  var rv = double.tryParse(text);
                  if (rv != null) {
                    setState(() {
                      _numberForm = rv;
                    });
                  }
                },
              ),
              spacer,
              Text(
                'From',
                style: labelStyle,
              ),
              spacer,
              DropdownButton(
                style: inputStyle,
                isExpanded: true,
                value: _startMeasure,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => onStartMeasureChanged(value),
              ),
              spacer,
              Text(
                'To',
                style: labelStyle,
              ),
              spacer,
              DropdownButton(
                style: inputStyle,
                isExpanded: true,
                value: _convertedMeasure,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => onConvertedMeasureChanged(value),
              ),
              spacer,
              RaisedButton(
                  child: Text(
                    'Convert',
                    style: inputStyle,
                  ),
                  onPressed: () {
                    if (_startMeasure.isEmpty ||
                        _convertedMeasure.isEmpty ||
                        _numberForm == 0) {
                      return;
                    } else {
                      convert(_numberForm, _startMeasure, _convertedMeasure);
                    }
                  }),
              spacer,
              Text(
                (_resultMessage == null) ? '' : _resultMessage,
                style: labelStyle,
              ),
              spacer,
            ],
          ),
        ),
      ),
    );
  }

  void onStartMeasureChanged(String value) {
    setState(() {
      _startMeasure = value;
    });
  }

  void onConvertedMeasureChanged(String value) {
    setState(() {
      _convertedMeasure = value;
    });
  }
}
