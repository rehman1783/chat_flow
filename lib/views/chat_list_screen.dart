import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/main_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainScreenController>();

    return RefreshIndicator(
      onRefresh: () => controller.refreshChats(),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No active chats',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.friends),
                  icon: const Icon(Icons.people),
                  label: const Text('View Friends'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.chats.length,
          itemBuilder: (context, index) {
            final chat = controller.chats[index];
            final otherUserId =
                chat.user1Id ==
                    Get.find<MainScreenController>().currentUser?.uid
                ? chat.user2Id
                : chat.user1Id;

            return ListTile(
              onTap: () => Get.toNamed(
                AppRoutes.chat,
                parameters: {'userId': otherUserId},
              ),
              leading: CircleAvatar(
                child: Text(
                  chat.user1Id ==
                          Get.find<MainScreenController>().currentUser?.uid
                      ? chat.user2Name[0].toUpperCase()
                      : chat.user1Name[0].toUpperCase(),
                ),
              ),
              title: Text(
                chat.user1Id ==
                        Get.find<MainScreenController>().currentUser?.uid
                    ? chat.user2Name
                    : chat.user1Name,
              ),
              subtitle: Text(
                chat.lastMessage.isEmpty ? 'No messages yet' : chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                _formatTime(chat.lastMessageTime),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
