import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/story/add_story_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('AddStoryState validate returns false when empty', () {
    final container = ProviderContainer();
    final notifier = container.read(addStoryProvider.notifier);

    expect(notifier.validate(), false);
  });
}