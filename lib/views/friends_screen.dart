import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/friends_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';

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
        onRefresh: () => controller.refreshFriends(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.friends.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No friends yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.friends.length,
            itemBuilder: (context, index) {
              final friend = controller.friends[index];

              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      child: Text(friend.displayName[0].toUpperCase()),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: friend.isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(friend.displayName),
                subtitle: Text(
                  friend.isOnline
                      ? 'Online'
                      : 'Last seen ${_lastSeenTime(friend.lastSeen)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () => Get.toNamed(
                    AppRoutes.chat,
                    parameters: {'userId': friend.id},
                  ),
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
