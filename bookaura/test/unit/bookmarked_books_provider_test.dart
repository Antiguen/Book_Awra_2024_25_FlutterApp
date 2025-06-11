import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/library/library_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('BookmarkedBooksNotifier initial state is loading', () {
    final container = ProviderContainer();
    final state = container.read(bookmarkedBooksProvider);
    expect(state, isA<AsyncLoading<List<Book>>>());
  });
}