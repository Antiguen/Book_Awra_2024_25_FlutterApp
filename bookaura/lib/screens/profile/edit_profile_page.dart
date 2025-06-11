import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod StateNotifier for profile editing
class EditProfileState extends StateNotifier<AsyncValue<void>> {
  EditProfileState()
      : fullNameController = TextEditingController(),
        bioController = TextEditingController(),
        genreController = TextEditingController(),
        descriptionController = TextEditingController(),
        super(const AsyncData(null));

  final fullNameController;
  final bioController;
  final genreController;
  final descriptionController;

  File? imageFile;
  String userRole = "author";
  String userEmail = "user@example.com";

  Future<void> fetchProfile() async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:3006/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        fullNameController.text = data['fullName'] ?? '';
        bioController.text = data['bio'] ?? '';
        genreController.text = data['genre'] ?? '';
        descriptionController.text = data['description'] ?? '';
        userRole = data['role'] ?? '';
        userEmail = data['email'] ?? '';
        state = const AsyncData(null);
      } else {
        state = AsyncError("Failed to load profile", StackTrace.current);
      }
    } catch (e) {
      state = AsyncError("Error loading profile: $e", StackTrace.current);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile = File(picked.path);
      state = const AsyncData(null);
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    if ((userRole == "author" || userRole == "artist") && imageFile == null) {
      state = AsyncError("Please select a profile image", StackTrace.current);
      return;
    }
    if (userEmail.isEmpty) {
      state = AsyncError("User email not found", StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final dio = Dio();

      FormData formData = FormData.fromMap({
        'fullName': fullNameController.text.trim(),
        'bio': bioController.text.trim(),
        'genre': genreController.text.trim(),
        'description': descriptionController.text.trim(),
        if (imageFile != null)
          'image': await MultipartFile.fromFile(imageFile!.path, filename: 'profile.jpg'),
      });

      final response = await dio.put(
        'http://localhost:3006/users/me',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        state = const AsyncData(null);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.of(context).pop();
        }
      } else {
        state = AsyncError("Failed to update profile", StackTrace.current);
      }
    } catch (e) {
      state = AsyncError("Error: $e", StackTrace.current);
    }
  }
}

final editProfileProvider = StateNotifierProvider<EditProfileState, AsyncValue<void>>(
  (ref) => EditProfileState(),
);

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(editProfileProvider.notifier).fetchProfile());
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final editProfile = ref.watch(editProfileProvider.notifier);
    final state = ref.watch(editProfileProvider);
    final isLoading = state is AsyncLoading;
    final errorMessage = state is AsyncError ? state.error.toString() : null;
    final isCreator = editProfile.userRole == "author" || editProfile.userRole == "artist";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Color(0xFFB17979), fontFamily: 'Cursive'),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFB17979)),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB17979)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Image
                  GestureDetector(
                    onTap: () => editProfile.pickImage(),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      backgroundImage: editProfile.imageFile != null
                          ? FileImage(editProfile.imageFile!)
                          : null,
                      child: editProfile.imageFile == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 48,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Full Name
                  TextField(
                    controller: editProfile.fullNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: isCreator
                          ? (editProfile.userRole == "author"
                              ? "Author Name"
                              : "Artist Name")
                          : "Full Name",
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB17979)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Creator-specific fields
                  if (isCreator) ...[
                    TextField(
                      controller: editProfile.bioController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Bio",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB17979)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: editProfile.genreController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Genre",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.list,
                          color: Colors.white,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB17979)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: editProfile.descriptionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB17979)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => editProfile.saveProfile(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB17979),
                      ),
                      child: Text(
                        isLoading ? "Saving..." : "Save Changes",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
