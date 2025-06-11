import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod StateNotifier for signup state
class SignupState extends StateNotifier<bool> {
  SignupState() : super(false);

  void setLoading(bool value) => state = value;
}

final signupProvider = StateNotifierProvider<SignupState, bool>(
  (ref) => SignupState(),
);

final usernameProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final birthdateProvider = StateProvider<String>((ref) => '');
final genderProvider = StateProvider<String?>((ref) => null);
final roleProvider = StateProvider<String>((ref) => 'reader');

class SignUpPage extends ConsumerWidget {
  final VoidCallback? onSignUpSuccess;
  const SignUpPage({super.key, this.onSignUpSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(signupProvider);
    final username = ref.watch(usernameProvider);
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final birthdate = ref.watch(birthdateProvider);
    final gender = ref.watch(genderProvider);
    final role = ref.watch(roleProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Cursive',
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 32),
                // Username
                TextField(
                  onChanged: (val) => ref.read(usernameProvider.notifier).state = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB17979)),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                // Email
                TextField(
                  onChanged: (val) => ref.read(emailProvider.notifier).state = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB17979)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                // Password
                TextField(
                  onChanged: (val) => ref.read(passwordProvider.notifier).state = val,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB17979)),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                // Birthdate
                TextField(
                  onChanged: (val) => ref.read(birthdateProvider.notifier).state = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.white,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB17979)),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: gender,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    ref.read(genderProvider.notifier).state = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                // Role Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoleRadio(ref, 'reader', role),
                    _buildRoleRadio(ref, 'writer', role),
                  ],
                ),
                const SizedBox(height: 24),
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _handleSignUp(context, ref, username, email, password, birthdate, gender, role),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB17979),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Login Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleRadio(WidgetRef ref, String role, String selectedRole) {
    return Row(
      children: [
        Radio<String>(
          value: role,
          groupValue: selectedRole,
          onChanged: (value) {
            ref.read(roleProvider.notifier).state = value!;
          },
          activeColor: const Color(0xFFB17979),
        ),
        Text(
          role[0].toUpperCase() + role.substring(1),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _handleSignUp(
    BuildContext context,
    WidgetRef ref,
    String username,
    String email,
    String password,
    String birthdate,
    String? gender,
    String role,
  ) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        birthdate.isEmpty ||
        gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    ref.read(signupProvider.notifier).setLoading(true);

    try {
      final dio = Dio();
      final response = await dio.post(
        'http://localhost:3006/auth/register',
        data: {
          'fullName': username,
          'email': email,
          'userPassword': password,
          'dateOfBirth': birthdate,
          'gender': gender,
          'role': role,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up successful!')),
        );
        onSignUpSuccess?.call();
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        String errorMsg = "Sign Up failed";
        try {
          final data = response.data;
          if (data is Map && data['message'] != null) {
            errorMsg = data['message'];
          }
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up failed: $e')),
      );
    } finally {
      ref.read(signupProvider.notifier).setLoading(false);
    }
  }
}
