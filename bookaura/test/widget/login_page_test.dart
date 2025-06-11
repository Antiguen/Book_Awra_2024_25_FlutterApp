import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/auth/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('LoginPage renders and responds to input', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginPage()),
      ),
    );

    // Check for BookAura title
    expect(find.text('BookAura'), findsOneWidget);

    // Check for Email and Password fields
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Enter email and password
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Tap the Login button
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pump();

    // Check for loading indicator or error message (optional)
  });
}