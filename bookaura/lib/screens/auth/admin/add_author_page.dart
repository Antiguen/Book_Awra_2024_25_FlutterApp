import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PROVIDER FOR AUTHOR FORM STATE
final addAuthorFormProvider = ChangeNotifierProvider((ref) => AddAuthorFormNotifier());

class AddAuthorFormNotifier extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    errorMessage = value;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    dobController.clear();
    genderController.clear();
    notifyListeners();
  }

  bool validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();
    final dob = dobController.text.trim();
    final gender = genderController.text.trim().toLowerCase();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty || dob.isEmpty || gender.isEmpty) {
      return false;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) return false;
    try {
      final date = DateTime.parse(dob);
      if (date.isAfter(DateTime.now())) return false;
    } catch (_) {
      return false;
    }
    if (!(gender == "male" || gender == "female")) return false;
    return true;
  }
}

class AddAuthorPage extends ConsumerWidget {
  const AddAuthorPage({super.key});

  bool get isSuperAdmin => true; // Replace with your logic

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final form = ref.read(addAuthorFormProvider);
    if (!form.validateForm()) {
      form.setError("Please fill all fields correctly");
      return;
    }
    form.setLoading(true);
    form.setError(null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final dio = Dio();

      final response = await dio.post(
        'http://localhost:3006/auth/register-artist',
        data: {
          "email": form.emailController.text.trim(),
          "userPassword": form.passwordController.text.trim(),
          "fullName": form.fullNameController.text.trim(),
          "dateOfBirth": form.dobController.text.trim(),
          "gender": form.genderController.text.trim().toLowerCase(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Author added successfully!")),
          );
        }
        form.clearFields();
      } else {
        String errorMsg = "Failed to add author";
        try {
          final data = response.data;
          if (data is Map && data['message'] != null) {
            errorMsg = data['message'];
          }
        } catch (_) {}
        if (errorMsg.toLowerCase().contains("email") && errorMsg.toLowerCase().contains("exist")) {
          errorMsg = "Email is already in use";
        }
        form.setError(errorMsg);
      }
    } catch (e) {
      form.setError("Error: $e");
    } finally {
      form.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(addAuthorFormProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isSuperAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Access denied: Super admin access required")),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: const Text(
          "BookAura",
          style: TextStyle(
            color: Color(0xFFB17979),
            fontFamily: 'Cursive',
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              "Add New Author",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cursive',
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: form.emailController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Author's Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: form.passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Author's Password"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: form.fullNameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Author's Full Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: form.dobController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Date of Birth (YYYY-MM-DD)"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: form.genderController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Gender (male/female)"),
            ),
            const SizedBox(height: 24),
            if (form.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  color: Colors.red[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            form.errorMessage!,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: form.isLoading ? null : () => _submit(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB17979),
                ),
                child: form.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("Add Author", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF333333),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB17979)),
      ),
    );
  }
}