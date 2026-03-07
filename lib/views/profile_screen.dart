import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/profile_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileScreenController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.userModel.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Text(
                        controller.displayName.value.isEmpty
                            ? 'U'
                            : controller.displayName.value[0].toUpperCase(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.displayName.value,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.email.value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Edit Profile Button
              ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
              const SizedBox(height: 16),

              // Settings & Security
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Account Settings'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Sign Out Button
              ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context, controller),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              const SizedBox(height: 16),

              // Delete Account Button
              ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(context, controller),
                icon: const Icon(Icons.delete),
                label: const Text('Delete Account'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    ProfileScreenController controller,
  ) {
    Get.defaultDialog(
      title: 'Sign Out',
      content: const Text('Are you sure you want to sign out?'),
      textConfirm: 'Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.logout();
        Get.back();
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ProfileScreenController controller,
  ) {
    Get.defaultDialog(
      title: 'Delete Account',
      content: const Text(
        'This action is permanent. All your data will be deleted. Are you sure?',
      ),
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteAccount();
        Get.back();
      },
    );
  }
}
