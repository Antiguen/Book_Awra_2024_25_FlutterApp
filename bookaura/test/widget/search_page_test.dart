import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/search/search_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('SearchPage renders search bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SearchPage(allBooks: const [])),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search books...'), findsOneWidget);
  });
}