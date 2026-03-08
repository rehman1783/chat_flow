import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/auth_controllers.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final email = ''.obs;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Reset Your Password',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Enter your email address and we will send you a link to reset your password.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            Obx(
              () => TextField(
                onChanged: (value) => email.value = value,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                onPressed: authController.isLoading
                    ? null
                    : () async {
                        if (email.value.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter your email',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        await authController.sendPasswordResetEmail(
                          email.value,
                        );
                      },
                child: authController.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Reset Link'),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
