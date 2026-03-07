import 'package:chat_flow/controllers/auth_controllers.dart';
import 'package:chat_flow/controllers/profile_screen_controller.dart';
import 'package:get/get.dart';

class SettingsScreenController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();

  final RxString currentPassword = ''.obs;
  final RxString newPassword = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxBool isChangingPassword = false.obs;
  final RxBool isDeletingAccount = false.obs;

  Future<void> changePassword() async {
    if (currentPassword.value.isEmpty ||
        newPassword.value.isEmpty ||
        confirmPassword.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.value != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.value.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isChangingPassword.value = true;
    await profileController.changePassword(
      currentPassword.value,
      newPassword.value,
    );
    isChangingPassword.value = false;
    clearPasswordFields();
  }

  Future<void> deleteAccount() async {
    isDeletingAccount.value = true;
    await profileController.deleteAccount();
    isDeletingAccount.value = false;
  }

  void clearPasswordFields() {
    currentPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
  }

  Future<void> logout() async {
    await profileController.logout();
  }
}
