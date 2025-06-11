import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod FutureProvider for user role
final userRoleProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';
  if (token.isEmpty) return 'user';
  final dio = Dio();
  try {
    final response = await dio.get(
      'http://localhost:3006/users/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return data['role'] ?? 'user';
    }
  } catch (_) {}
  return 'user';
});

class BottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleAsync = ref.watch(userRoleProvider);

    return userRoleAsync.when(
      loading: () => const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox(
        height: 60,
        child: Center(child: Icon(Icons.error, color: Colors.red)),
      ),
      data: (userRole) {
        final List<BottomNavigationBarItem> items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ];

        if (userRole == "superadmin") {
          items.add(const BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Add Author",
          ));
          items.add(const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Book",
          ));
        } else if (userRole == "artist") {
          items.add(const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Book",
          ));
        }

        return BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xFFB17979),
          unselectedItemColor: Colors.white,
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          type: BottomNavigationBarType.fixed,
        );
      },
    );
  }
}