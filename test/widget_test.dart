import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calculator3_app/main.dart';
import 'package:flutter_calculator3_app/calculator_bloc.dart';
import 'package:flutter_calculator3_app/calculator_page.dart';

void main() {
  testWidgets('Calculator UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our calculator starts with '0' display.
    expect(find.text('0'), findsOneWidget);

    // Tap some number buttons
    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('3'));
    await tester.pump();

    // Verify that the display shows '123'
    expect(find.text('123'), findsOneWidget);

    // Tap the clear button
    await tester.tap(find.text('C'));
    await tester.pump();

    // Verify that the display is back to '0'
    expect(find.text('0'), findsOneWidget);
  });
}
