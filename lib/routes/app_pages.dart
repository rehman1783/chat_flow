import 'package:chat_flow/controllers/auth_controllers.dart';
import 'package:chat_flow/controllers/chat_screen_controller.dart';
import 'package:chat_flow/controllers/find_friends_controller.dart';
import 'package:chat_flow/controllers/friends_controller.dart';
import 'package:chat_flow/controllers/login_screen_controller.dart';
import 'package:chat_flow/controllers/main_screen_controller.dart';
import 'package:chat_flow/controllers/notification_controller.dart';
import 'package:chat_flow/controllers/profile_screen_controller.dart';
import 'package:chat_flow/controllers/register_screen_controller.dart';
import 'package:chat_flow/controllers/settings_screen_controller.dart';
import 'package:chat_flow/controllers/splash_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/views/auth/login_screen.dart';
import 'package:chat_flow/views/auth/register_screen.dart';
import 'package:chat_flow/views/chat_screen.dart';
import 'package:chat_flow/views/find_friends_screen.dart';
import 'package:chat_flow/views/friends_screen.dart';
import 'package:chat_flow/views/forgot_password_screen.dart';
import 'package:chat_flow/views/main_screen.dart';
import 'package:chat_flow/views/notification_screen.dart';
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
        Get.put(AuthController());
        Get.put(LoginScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(RegisterScreenController());
      }),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.put(MainScreenController());
        Get.put(NotificationController());
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
      name: AppRoutes.usersList,
      page: () => const FindFriendsScreen(),
      binding: BindingsBuilder(() {
        Get.put(FindFriendsController());
      }),
    ),
    GetPage(
      name: AppRoutes.friends,
      page: () => const FriendsScreen(),
      binding: BindingsBuilder(() {
        Get.put(FriendsController());
      }),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      binding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: BindingsBuilder(() {
        Get.put(SettingsScreenController());
        Get.put(ProfileScreenController());
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
