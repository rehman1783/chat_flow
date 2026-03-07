import 'package:chat_flow/models/chat_model.dart';
import 'package:chat_flow/models/message_model.dart';
import 'package:chat_flow/models/user_model.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatScreenController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late String chatId;
  late String otherUserId;
  late UserModel otherUser;

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isSending = false.obs;
  final Rx<ChatModel?> chat = Rx<ChatModel?>(null);

  User? get currentUser => _firebaseAuth.currentUser;

  void initializeChat(String receiverId) async {
    try {
      otherUserId = receiverId;
      otherUser =
          await _firestoreService.getUser(receiverId) ??
          UserModel(
            id: '',
            email: '',
            displayName: 'Unknown User',
            photoUrl: '',
            isOnline: false,
            lastSeen: DateTime.now(),
            createdAt: DateTime.now(),
          );

      chatId = await _firestoreService.getOrCreateChatId(
        currentUser!.uid,
        otherUserId,
      );

      loadMessages();
      loadChat();
    } catch (e) {
      error.value = e.toString();
      print('Error initializing chat: $e');
    }
  }

  void loadMessages() {
    try {
      _firestoreService.getMessagesStream(chatId).listen((messageList) {
        messages.value = messageList;
      });
    } catch (e) {
      error.value = e.toString();
      print('Error loading messages: $e');
    }
  }

  void loadChat() {
    try {
      _firestoreService.getChat(chatId).then((chatModel) {
        if (chatModel != null) {
          chat.value = chatModel;
        }
      });
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      if (content.trim().isEmpty) return;

      isSending.value = true;
      error.value = '';

      final message = MessageModel(
        id: const Uuid().v4(),
        chatId: chatId,
        senderId: currentUser!.uid,
        receiverId: otherUserId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
      );

      await _firestoreService.sendMessage(message);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> editMessage(String messageId, String newContent) async {
    try {
      if (newContent.trim().isEmpty) return;

      isLoading.value = true;
      error.value = '';

      await _firestoreService.editMessage(chatId, messageId, newContent);
      Get.snackbar(
        'Success',
        'Message updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to edit message');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _firestoreService.deleteMessage(chatId, messageId);
      Get.snackbar(
        'Success',
        'Message deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to delete message');
    } finally {
      isLoading.value = false;
    }
  }

  bool isCurrentUserMessage(MessageModel message) {
    return message.senderId == currentUser?.uid;
  }
}
