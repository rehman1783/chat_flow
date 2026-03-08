import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/notification_controller.dart';
import 'package:chat_flow/theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Friend Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                color: AppTheme.backgroundColor,
                child: const TabBar(
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondaryColor,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: 'Received'),
                    Tab(text: 'Sent'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Received Tab
            RefreshIndicator(
              onRefresh: () => controller.refreshNotifications(),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.receivedRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No friend requests',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemCount: controller.receivedRequests.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final request = controller.receivedRequests[index];

                    return Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppTheme.primaryColor,
                                  child: Text(
                                    request.senderName[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.senderName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        request.senderEmail,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      controller.rejectRequest(request.id),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('Reject'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      controller.acceptRequest(request.id),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Sent Tab
            RefreshIndicator(
              onRefresh: () => controller.refreshNotifications(),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.sentRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_outlined,
                          size: 80,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No requests sent',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemCount: controller.sentRequests.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final request = controller.sentRequests[index];

                    Color getStatusColor(String status) {
                      switch (status) {
                        case 'accepted':
                          return AppTheme.successColor;
                        case 'rejected':
                          return AppTheme.errorColor;
                        default:
                          return AppTheme.warningColor;
                      }
                    }

                    return Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                request.senderName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.senderName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Request sent',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(
                                  request.status,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: getStatusColor(
                                    request.status,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                request.status[0].toUpperCase() +
                                    request.status.substring(1),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: getStatusColor(request.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
