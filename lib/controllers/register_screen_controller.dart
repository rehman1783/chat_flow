import 'package:chat_flow/controllers/auth_controllers.dart';
import 'package:get/get.dart';

class RegisterScreenController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxString displayName = ''.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> register() async {
    if (email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty ||
        displayName.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.value.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await authController.registerWithEmailAndPassword(
      email.value.trim(),
      password.value,
      displayName.value.trim(),
    );
  }

  void clear() {
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    displayName.value = '';
  }
}
