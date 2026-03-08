import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/profile_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileScreenController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.userModel.value == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Header Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Obx(
                        () => Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                controller.displayName.value.isEmpty
                                    ? 'U'
                                    : controller.displayName.value[0]
                                          .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Online status indicator
                            if (controller.userModel.value?.isOnline ?? false)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.displayName.value.isEmpty
                            ? 'Unknown User'
                            : controller.displayName.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.email.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Edit Profile Button
              ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
              const SizedBox(height: 24),

              // Settings & Security Section
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Account Settings'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    const Divider(height: 0, indent: 56),
                    ListTile(
                      leading: const Icon(
                        Icons.lock_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Danger Zone Section
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorColor,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context, controller),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(context, controller),
                icon: const Icon(Icons.delete),
                label: const Text('Delete Account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                  side: const BorderSide(color: AppTheme.errorColor),
                ),
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
