import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/auth/signup_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('SignUpPage renders and responds to input', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SignUpPage()),
      ),
    );

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);

    // Enter username, email, password, birthdate
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.enterText(find.byType(TextField).at(3), '2000-01-01');

    // Select gender
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    // Tap Sign Up button
    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);
    await tester.tap(signUpButton);
    await tester.pump();
  });
}