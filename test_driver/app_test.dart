import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Notes App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final devName = find.byValueKey('DevName');
    final buttonFinder = find.byType('AboutButton');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    // test('starts at 0', () async {
    //   // Use the `driver.getText` method to verify the counter starts at 0.
    //   expect(await driver.getText(counterTextFinder), "0");
    // });

    test('taps about button', () async {
      // First, tap the button.
      await driver.tap(buttonFinder);

      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(devName), "Hash Studios");
    });
  });
}
