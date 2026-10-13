import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping_list/main.dart';

void main() {
  testWidgets('shows the starting items and adds a new one', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ShoppingListApp());

    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Bread'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Eggs');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();

    expect(find.text('Eggs'), findsOneWidget);
  });
}
