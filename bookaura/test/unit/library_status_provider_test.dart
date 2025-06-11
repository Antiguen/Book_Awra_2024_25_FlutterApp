import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/story/description_page.dart';
import 'package:bookaura/models/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('LibraryStatusNotifier initial state is loading', () {
    final book = Book(
      id: '1',
      title: 'Test',
      artist: 'Test',
      album: 'Test',
      genre: 'Test',
      description: 'Test',
      songContentType: '',
      imageContentType: '',
      uploadDate: '',
      imageData: '',
    );
    final container = ProviderContainer();
    final state = container.read(libraryStatusProvider(book));
    expect(state, isA<AsyncLoading<bool>>());
  });
}