import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:bookaura/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app login and navigation flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap "Let's Read" on landing page
    final letsReadButton = find.text("Let's Read");
    expect(letsReadButton, findsOneWidget);
    await tester.tap(letsReadButton);
    await tester.pumpAndSettle();

    // Enter login credentials
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Tap Login
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Expect to land on HomePage (look for BookAura title)
    expect(find.text('BookAura'), findsWidgets);
  });
}