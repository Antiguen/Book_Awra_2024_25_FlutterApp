import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/search/search_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('SearchNotifier initial state is empty list', () {
    final container = ProviderContainer();
    final state = container.read(searchProvider);
    expect(state, isA<AsyncData<List>>());
    expect(state.value, isEmpty);
  });
}