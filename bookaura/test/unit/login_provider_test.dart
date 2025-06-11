import 'package:flutter_test/flutter_test.dart';
import 'package:bookaura/screens/auth/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('LoginState sets loading', () {
    final container = ProviderContainer();
    final notifier = container.read(loginProvider.notifier);

    notifier.setLoading(true);
    expect(container.read(loginProvider), true);

    notifier.setLoading(false);
    expect(container.read(loginProvider), false);
  });
}