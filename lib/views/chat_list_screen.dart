import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/main_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainScreenController>();

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      backgroundColor: Colors.white,
      onRefresh: () => controller.refreshChats(),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (controller.chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: 60,
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No active chats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start a new conversation with your friends',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.friends),
                  icon: const Icon(Icons.people),
                  label: const Text('View Friends'),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: controller.chats.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: AppTheme.borderColor, indent: 76),
          itemBuilder: (context, index) {
            final chat = controller.chats[index];
            final otherUserId =
                chat.user1Id ==
                    Get.find<MainScreenController>().currentUser?.uid
                ? chat.user2Id
                : chat.user1Id;
            final otherUserName =
                chat.user1Id ==
                    Get.find<MainScreenController>().currentUser?.uid
                ? chat.user2Name
                : chat.user1Name;
            final otherUserInitial = otherUserName.isNotEmpty
                ? otherUserName[0].toUpperCase()
                : 'U';

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.toNamed(
                  AppRoutes.chat,
                  parameters: {'userId': otherUserId},
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          otherUserInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              otherUserName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              chat.lastMessage.isEmpty
                                  ? 'No messages yet'
                                  : chat.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(chat.lastMessageTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
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
