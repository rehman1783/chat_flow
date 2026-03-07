import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/main_screen_controller.dart';
import 'package:chat_flow/controllers/notification_controller.dart';
import 'package:chat_flow/views/chat_list_screen.dart';
import 'package:chat_flow/views/friends_screen.dart';
import 'package:chat_flow/views/find_friends_screen.dart';
import 'package:chat_flow/views/profile_screen.dart';
import 'package:chat_flow/routes/app_routes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainScreenController>();
    final notificationController = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Flow'),
        centerTitle: true,
        actions: [
          Obx(
            () => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => Get.toNamed(AppRoutes.notifications),
                ),
                if (notificationController.unreadCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        notificationController.unreadCount.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
