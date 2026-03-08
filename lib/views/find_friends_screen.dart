import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/find_friends_controller.dart';

class FindFriendsScreen extends StatelessWidget {
  const FindFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FindFriendsController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Find Friends'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.searchUsers,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final displayUsers = controller.searchQuery.value.isEmpty
                  ? controller.users
                  : controller.searchResults;

              if (displayUsers.isEmpty) {
                return const Center(child: Text('No users found'));
              }

              return ListView.builder(
                itemCount: displayUsers.length,
                itemBuilder: (context, index) {
                  final user = displayUsers[index];
                  final requestSent = controller.hasRequestSent(user.id);

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(user.displayName[0].toUpperCase()),
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(user.email),
                    trailing: ElevatedButton(
                      onPressed: requestSent
                          ? null
                          : () => controller.sendFriendRequest(user),
                      child: Text(requestSent ? 'Requested' : 'Add'),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
