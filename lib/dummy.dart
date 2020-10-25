void main() {
  double result = calculateArea(12, 5, true);
  print('The resulte is $result');

  String myString = 'Throw your Dart';
  String resultText = reverse(myString);

  print(resultText);

  var songs = List();

  songs.add('We will rock you');

  print(songs);
}

double calculateArea(double width, double higth, [bool isTriangle]) {
  double area;
  if (isTriangle) {
    area = 1 / 2 * width * higth;
  } else {
    area = width * higth;
  }

  return area;
}

String reverse(String text) {
  String resultText = '';

//   int length = text.length;
//   for(int i = length - 1; i >= 0 ; i--){
//     resultText += text[i];
//   }

  resultText = text.split("").reversed.join();

  return resultText;
}

bool convertYoBool(int value) => (value == 0) ? false : true;
