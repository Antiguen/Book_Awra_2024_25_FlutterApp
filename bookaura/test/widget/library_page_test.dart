import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/library/library_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('LibraryPage shows loading and empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LibraryPage()),
      ),
    );

    // Should show loading indicator first
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate data loaded (empty)
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('No bookmarked books yet...'), findsOneWidget);
  });
}