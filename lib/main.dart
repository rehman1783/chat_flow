import 'package:chat_flow/controllers/auth_controllers.dart';
import 'package:chat_flow/controllers/push_notification_controller.dart';
import 'package:chat_flow/controllers/theme_controller.dart';
import 'package:chat_flow/firebase_options.dart';
import 'package:chat_flow/routes/app_pages.dart';
import 'package:chat_flow/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(PushNotificationController()); // Initialize push notifications
  Get.put(ThemeController()); // Initialize theme controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      title: 'Chat Flow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
