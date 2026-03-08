import 'package:chat_flow/models/message_model.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:chat_flow/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PushNotificationController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RxList<String> notifiedUsers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializePushNotifications();
  }

  Future<void> _initializePushNotifications() async {
    try {
      // Initialize Firebase Messaging
      await _notificationService.initializeNotifications();

      // Listen to new messages in real-time
      _listenToIncomingMessages();
    } catch (e) {
      print('Error initializing push notifications: $e');
    }
  }

  void _listenToIncomingMessages() {
    final currentUserId = _firebaseAuth.currentUser?.uid;
    if (currentUserId == null) return;

    // Listen to all messages where current user is receiver
    _firestoreService
        .getAllMessagesStream(currentUserId)
        .listen(
          (messages) {
            for (final message in messages) {
              // Check if message is unread and from a new sender
              if (!message.isRead &&
                  message.receiverId == currentUserId &&
                  !notifiedUsers.contains(message.senderId)) {
                _showMessageNotification(message);
                notifiedUsers.add(message.senderId);
              }
            }
          },
          onError: (error) {
            print('Error listening to messages: $error');
          },
        );
  }

  void _showMessageNotification(MessageModel message) {
    _firestoreService.getUser(message.senderId).then((senderUser) {
      if (senderUser != null) {
        _notificationService.sendTestNotification(
          '${senderUser.displayName} sent a message',
          message.content,
        );
      }
    });
  }

  void resetNotification() {
    _notificationService.resetNotificationCount();
  }
}
