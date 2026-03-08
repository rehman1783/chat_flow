import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/main_screen_controller.dart';
import 'package:chat_flow/controllers/notification_controller.dart';
import 'package:chat_flow/views/chat_list_screen.dart';
import 'package:chat_flow/views/friends_screen.dart';
import 'package:chat_flow/views/find_friends_screen.dart';
import 'package:chat_flow/views/profile_screen.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/theme/app_theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainScreenController>();
    final notificationController = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Flow',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              children: [
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    iconSize: 24,
                    onPressed: () => Get.toNamed(AppRoutes.notifications),
                    tooltip: 'Notifications',
                  ),
                ),
                Obx(() {
                  final count = notificationController.unreadCount.value;
                  return count > 0
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              count > 99 ? '99+' : count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        switch (mainController.selectedIndex.value) {
          case 0:
            return const ChatListScreen();
          case 1:
            return const FriendsScreen();
          case 2:
            return const FindFriendsScreen();
          case 3:
            return const ProfileScreen();
          default:
            return const ChatListScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: mainController.selectedIndex.value,
          onTap: mainController.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Find Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
