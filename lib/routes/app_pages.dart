import 'package:chat_flow/controllers/chat_screen_controller.dart';
import 'package:chat_flow/controllers/login_screen_controller.dart';
import 'package:chat_flow/controllers/main_screen_controller.dart';
import 'package:chat_flow/controllers/profile_screen_controller.dart';
import 'package:chat_flow/controllers/register_screen_controller.dart';
import 'package:chat_flow/controllers/settings_screen_controller.dart';
import 'package:chat_flow/controllers/splash_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/views/auth/login_screen.dart';
import 'package:chat_flow/views/auth/register_screen.dart';
import 'package:chat_flow/views/chat_screen.dart';
import 'package:chat_flow/views/main_screen.dart';
import 'package:chat_flow/views/profile_screen.dart';
import 'package:chat_flow/views/settings_screen.dart';
import 'package:chat_flow/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(LoginScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.put(RegisterScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.put(MainScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
      binding: BindingsBuilder(() {
        Get.put(ChatScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: BindingsBuilder(() {
        Get.put(SettingsScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.put(ProfileScreenController());
      }),
    ),
  ];
}
