import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/home/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('BooksNotifier initial state is empty list', () {
    final container = ProviderContainer();
    final books = container.read(booksProvider);
    expect(books, isA<List>());
    expect(books, isEmpty);
  });
}