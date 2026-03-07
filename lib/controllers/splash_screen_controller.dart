import 'package:chat_flow/controllers/auth_controllers.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      final authController = Get.find<AuthController>();
      authController.checkInitialAuthState();
    });
  }
}
