import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
            ],
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
                        Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'No friend requests',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.receivedRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.receivedRequests[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  request.senderName[0].toUpperCase(),
                                ),
                              ),
                              title: Text(request.senderName),
                              subtitle: Text(request.senderEmail),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      controller.acceptRequest(request.id),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Accept'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      controller.rejectRequest(request.id),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Reject'),
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
                        Icon(Icons.send, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'No requests sent',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.sentRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.sentRequests[index];

                    return ListTile(
                      title: Text(request.senderName),
                      subtitle: Text('Status: ${request.status}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: request.status == 'accepted'
                              ? Colors.green[100]
                              : request.status == 'rejected'
                              ? Colors.red[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          request.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: request.status == 'accepted'
                                ? Colors.green
                                : request.status == 'rejected'
                                ? Colors.red
                                : Colors.orange,
                          ),
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
