
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Test Input and output', () {
    FlutterDriver driver;

    // Finders for the widgets we want to test.
    var textfield = find.byValueKey('textfield');
    var button = find.byValueKey('done');
    var output = find.byValueKey('output');

    // Connect to Flutter driver.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // close the flutter driver after tests are completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('output is empty', () async {
      // Check that no text is on the screen.
      expect(await driver.getText(output), "");
    });

    test('input text and update ', () async {
      //emulate text field tap
      await driver.tap(textfield);

      //emulate text input
      await driver.enterText("input text");

      // Then, tap the done button.
      await driver.tap(button);

      // finally, check that value printed is correct.
      expect(await driver.getText(output), "input text");
    });
  });
}