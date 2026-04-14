import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('simple app shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('HealTack'),
          ),
        ),
      ),
    );

    expect(find.text('HealTack'), findsOneWidget);
  });
}
