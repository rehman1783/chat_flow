import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/views/auth/login_screen.dart';
import 'package:chat_flow/views/auth/register_screen.dart';
import 'package:chat_flow/views/home_screen.dart';
import 'package:chat_flow/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeScreenController());
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
