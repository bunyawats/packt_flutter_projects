class WeTest {
  String text = "Hey, I am getting teh number:";

  populateText(int a, int b) {
    int value = a + b;
    text = "$text ${value.toString()}";
  }
}
