import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/profile/profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookaura/models/user.dart';

void main() {
  test('ProfileNotifier initial state is loading', () {
    final container = ProviderContainer();
    final state = container.read(profileProvider);
    expect(state, isA<AsyncLoading<User>>());
  });
}