import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/auth/signup_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('SignupState sets loading', () {
    final container = ProviderContainer();
    final notifier = container.read(signupProvider.notifier);

    notifier.setLoading(true);
    expect(container.read(signupProvider), true);

    notifier.setLoading(false);
    expect(container.read(signupProvider), false);
  });
}