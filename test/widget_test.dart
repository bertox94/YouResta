// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youresta/main.dart';

void main() {
  testWidgets('test1', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Finder email = find.byType(TextField).at(0);
    Finder password = find.byType(TextField).at(1);
    expect(email, findsOneWidget);
    await tester.enterText(email, 'a@m.it');
    await tester.enterText(password, '123456');
    Finder login = find.text('Log In');
    expect(login, findsOneWidget);
    await tester.tap(login);

  });
}
