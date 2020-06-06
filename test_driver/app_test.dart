import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Notes App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final devName = find.byValueKey('DevName');
    final buttonFinder = find.byType('AboutButton');
    final backButtonFinder = find.byValueKey('BackButton');
    final newNoteButtonFinder = find.byValueKey('NewNote');
    final bodyTextFieldFinder = find.byValueKey('BodyText');
    final doneButtonFinder = find.byValueKey('Done');

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('taps about button', () async {
      await driver.tap(buttonFinder);

      expect(await driver.getText(devName), "Hash Studios");
    });

    test('taps back button', () async {
      await driver.tap(backButtonFinder);
    });

    test('taps new note button', () async {
      await driver.tap(newNoteButtonFinder);
    });

    test('body text entered', () async {
      await driver.tap(bodyTextFieldFinder);
      await driver.enterText('New Note');

      expect(await driver.getText(bodyTextFieldFinder), "New Note");
    });

    test('taps done button', () async {
      await driver.tap(doneButtonFinder);
    });

    test('taps new note button', () async {
      await driver.tap(newNoteButtonFinder);
    });

    test('body text entered', () async {
      await driver.tap(bodyTextFieldFinder);
      await driver.enterText('Another Note');

      expect(await driver.getText(bodyTextFieldFinder), "Another Note");
    });

    test('taps done button', () async {
      await driver.tap(doneButtonFinder);
    });

    test('taps about button', () async {
      await driver.tap(buttonFinder);

      expect(await driver.getText(devName), "Hash Studios");
    });

    test('taps back button', () async {
      await driver.tap(backButtonFinder);
    });
  });
}
