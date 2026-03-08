import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Observable notification count
  final RxInt unreadNotificationCount = 0.obs;

  Future<void> initializeNotifications() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      print('Notification Permission Status: ${settings.authorizationStatus}');

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleForegroundMessage(message);
      });

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationTap(message);
      });

      // Get FCM token
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');

    // Show notification in app
    if (message.notification != null) {
      _showLocalNotification(
        message.notification!.title ?? 'New Message',
        message.notification!.body ?? '',
        message.data,
      );
      unreadNotificationCount.value++;
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped');
    print('Data: ${message.data}');

    // Navigate based on notification data
    if (message.data['type'] == 'message') {
      final String userId = message.data['userId'] ?? '';
      if (userId.isNotEmpty) {
        Get.toNamed('/chat', parameters: {'userId': userId});
      }
    }
  }

  void _showLocalNotification(
    String title,
    String body,
    Map<String, dynamic> data,
  ) {
    // Show a snackbar as an in-app notification
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
      icon: const Icon(Icons.notifications, color: Colors.white),
    );
  }

  Future<void> sendTestNotification(String title, String body) async {
    // In production, this would be called from your backend
    _showLocalNotification(title, body, {});
  }

  void resetNotificationCount() {
    unreadNotificationCount.value = 0;
  }
}

// Top-level function for background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  // Here you can handle background messages
  // In this example, we'll just print them
}
