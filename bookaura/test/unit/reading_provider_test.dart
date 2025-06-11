import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/reading/reading_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('ReadingState initial state is loading', () {
    final container = ProviderContainer();
    final state = container.read(readingProvider('bookId'));
    expect(state, isA<AsyncLoading<dynamic>>());
  });
}