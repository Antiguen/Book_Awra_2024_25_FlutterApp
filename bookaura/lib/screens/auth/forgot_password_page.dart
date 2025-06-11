import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod StateNotifier for forgot password state
class ForgotPasswordState extends StateNotifier<bool> {
  ForgotPasswordState() : super(false);

  void submit() => state = true;
  void reset() => state = false;
}

final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordState, bool>(
  (ref) => ForgotPasswordState(),
);

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmailSubmitted = ref.watch(forgotPasswordProvider);
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            const Text(
              "Forgot Password",
              style: TextStyle(
                color: Color(0xFFB17979),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF222222),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFB17979)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(forgotPasswordProvider.notifier).submit();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("If this email is registered, a reset link will be sent."),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB17979),
                ),
                child: const Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ),
            if (isEmailSubmitted) ...[
              const SizedBox(height: 16),
              const Text(
                "Check your email for reset instructions",
                style: TextStyle(color: Colors.white),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  ref.read(forgotPasswordProvider.notifier).reset();
                  Navigator.of(context).pop();
                },
                child: const Text("Back to Login", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}