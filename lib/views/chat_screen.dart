import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_flow/controllers/chat_screen_controller.dart';
import 'package:chat_flow/routes/app_routes.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = Get.parameters['userId'] ?? '';
    final controller = Get.put(ChatScreenController());
    final messageController = TextEditingController();

    controller.initializeChat(userId);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.otherUser.displayName)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Quick access buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.friends),
                    icon: const Icon(Icons.people),
                    label: const Text('View Friends'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.usersList),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Find Friends'),
                  ),
                ),
              ],
            ),
          ),
          // Messages list
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
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
                        'No messages yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isCurrentUser = controller.isCurrentUserMessage(
                    message,
                  );

                  return Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: TextStyle(
                              color: isCurrentUser
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(message.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isCurrentUser
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                              if (message.editedAt != null)
                                Text(
                                  ' (edited)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCurrentUser
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                              if (isCurrentUser)
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _showEditDialog(
                                    context,
                                    controller,
                                    message.id,
                                    message.content,
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
          // Input area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => FloatingActionButton(
                    mini: true,
                    onPressed: controller.isSending.value
                        ? null
                        : () {
                            if (messageController.text.isNotEmpty) {
                              controller.sendMessage(messageController.text);
                              messageController.clear();
                            }
                          },
                    child: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showEditDialog(
    BuildContext context,
    ChatScreenController controller,
    String messageId,
    String currentContent,
  ) {
    final editController = TextEditingController(text: currentContent);

    Get.defaultDialog(
      title: 'Edit Message',
      content: TextField(
        controller: editController,
        decoration: const InputDecoration(hintText: 'Edit your message'),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        if (editController.text.isNotEmpty) {
          controller.editMessage(messageId, editController.text);
          Get.back();
        }
      },
    );
  }
}
