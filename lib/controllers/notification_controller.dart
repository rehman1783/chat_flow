import 'package:chat_flow/models/friend_request_model.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RxList<FriendRequestModel> receivedRequests =
      <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> sentRequests = <FriendRequestModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt unreadCount = 0.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      error.value = '';

      if (currentUser != null) {
        final received = await _firestoreService.getReceivedFriendRequests(
          currentUser!.uid,
        );
        final sent = await _firestoreService.getSentFriendRequests(
          currentUser!.uid,
        );

        receivedRequests.value = received;
        sentRequests.value = sent;
        unreadCount.value = received.length;
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _firestoreService.acceptFriendRequest(requestId);

      // Remove from received requests
      receivedRequests.removeWhere((req) => req.id == requestId);
      unreadCount.value = receivedRequests.length;

      Get.snackbar(
        'Success',
        'Friend request accepted!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to accept request');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _firestoreService.rejectFriendRequest(requestId);

      // Remove from received requests
      receivedRequests.removeWhere((req) => req.id == requestId);
      unreadCount.value = receivedRequests.length;

      Get.snackbar(
        'Success',
        'Friend request rejected',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to reject request');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }
}
