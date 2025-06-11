import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/story/add_book_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('AddBookState validateInput returns false when empty', () {
    final container = ProviderContainer();
    final notifier = container.read(addBookProvider.notifier);

    expect(notifier.validateInput(), false);
  });
}