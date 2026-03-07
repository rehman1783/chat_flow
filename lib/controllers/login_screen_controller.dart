import 'package:chat_flow/controllers/auth_controllers.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await authController.signInWithEmailAndPassword(
      email.value.trim(),
      password.value,
    );
  }

  void clear() {
    email.value = '';
    password.value = '';
  }
}
