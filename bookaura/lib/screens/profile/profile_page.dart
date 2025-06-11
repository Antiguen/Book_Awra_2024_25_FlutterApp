import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';

// Riverpod provider for user profile state
final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<User>>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier extends StateNotifier<AsyncValue<User>> {
  ProfileNotifier() : super(const AsyncLoading()) {
    fetchProfile();
  }

  final Dio dio = Dio();

  Future<void> fetchProfile() async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await dio.get(
        'http://localhost:3006/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        state = AsyncData(User.fromJson(data));
      } else {
        state = AsyncError("Failed to load profile", StackTrace.current);
      }
    } catch (e) {
      state = AsyncError("Error loading profile: $e", StackTrace.current);
    }
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _editProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/edit_profile');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: profileAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFB17979)),
            ),
            error: (err, _) => Center(
              child: Text(
                err.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            data: (user) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with Edit and Logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Color(0xFFB17979),
                        fontSize: 28,
                        fontFamily: 'Cursive',
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _editProfile(context),
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFFB17979),
                          ),
                          tooltip: "Edit Profile",
                        ),
                        IconButton(
                          onPressed: () => _logout(context),
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: Color(0xFFB17979),
                          ),
                          tooltip: "Logout",
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  backgroundImage: user.imageUrl != null && user.imageUrl!.isNotEmpty
                      ? NetworkImage(user.imageUrl!)
                      : null,
                  child: user.imageUrl == null || user.imageUrl!.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 48,
                        )
                      : null,
                ),
                const SizedBox(height: 24),
                // Profile Details
                if (user.role == "author" || user.role == "artist") ...[
                  _ProfileDetailItem(
                    icon: Icons.person,
                    label: user.role == "author" ? "Author Name" : "Artist Name",
                    value: user.fullName,
                  ),
                  _ProfileDetailItem(
                    icon: Icons.info,
                    label: "Bio",
                    value: user.bio ?? "",
                  ),
                  _ProfileDetailItem(
                    icon: Icons.list,
                    label: "Genre",
                    value: user.genre ?? "",
                  ),
                  _ProfileDetailItem(
                    icon: Icons.info,
                    label: "Description",
                    value: user.description ?? "",
                  ),
                ] else if (user.role == "admin") ...[
                  _ProfileDetailItem(
                    icon: Icons.admin_panel_settings,
                    label: "Admin",
                    value: user.fullName,
                  ),
                  _ProfileDetailItem(
                    icon: Icons.email,
                    label: "Email",
                    value: user.email,
                  ),
                ] else ...[
                  _ProfileDetailItem(
                    icon: Icons.person,
                    label: "Name",
                    value: user.fullName,
                  ),
                  _ProfileDetailItem(
                    icon: Icons.email,
                    label: "Email",
                    value: user.email,
                  ),
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFB17979), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Color(0xFFB17979), fontSize: 16),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28, top: 2, bottom: 8),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
