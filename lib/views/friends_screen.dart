import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/friends_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/theme/app_theme.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FriendsController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Friends'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () => controller.refreshFriends(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (controller.friends.isEmpty) {
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
                      Icons.people_outline,
                      size: 60,
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No friends yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find and add friends to start chatting',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: controller.friends.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.borderColor,
              indent: 76,
            ),
            itemBuilder: (context, index) {
              final friend = controller.friends[index];
              final friendInitial = friend.displayName.isNotEmpty
                  ? friend.displayName[0].toUpperCase()
                  : 'U';

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.accentdColor,
                          child: Text(
                            friendInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: friend.isOnline
                                  ? AppTheme.successColor
                                  : AppTheme.textSecondaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friend.displayName.isNotEmpty
                                ? friend.displayName
                                : 'Unknown User',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            friend.isOnline
                                ? 'Online'
                                : 'Last seen ${_lastSeenTime(friend.lastSeen)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chat,
                          color: AppTheme.primaryColor,
                        ),
                        iconSize: 20,
                        onPressed: () => Get.toNamed(
                          AppRoutes.chat,
                          parameters: {'userId': friend.id},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  String _lastSeenTime(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
