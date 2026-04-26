import 'package:chat_flow/models/user_model.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FindFriendsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> searchResults = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxList<String> sentRequestIds = <String>[].obs;
  final RxList<String> friendIds = <String>[].obs;
  final RxMap<String, String> requestStatus =
      <String, String>{}.obs; // userId -> status (pending/accepted/rejected)

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadAllUsers();
  }

  Future<void> loadAllUsers() async {
    try {
      isLoading.value = true;
      error.value = '';

      final allUsers = await _firestoreService.getAllUsers();
      
      // Filter out current user
      final filteredUsers = allUsers
          .where((user) => user.id != currentUser?.uid)
          .toList();
      
      users.value = filteredUsers;
      
      print('Loaded ${users.length} users');

      // Load sent request IDs
      await loadSentRequests();
    } catch (e) {
      error.value = e.toString();
      print('Error loading users: $e');
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSentRequests() async {
    try {
      final sentRequests = await _firestoreService.getSentFriendRequests(
        currentUser!.uid,
      );
      sentRequestIds.value = sentRequests.map((req) => req.receiverId).toList();

      // Track status of requests
      for (var req in sentRequests) {
        requestStatus[req.receiverId] = req.status;
      }

      // Load received requests to check for accepted ones
      final receivedRequests = await _firestoreService
          .getReceivedFriendRequests(currentUser!.uid);
      for (var req in receivedRequests) {
        if (req.status == 'accepted') {
          friendIds.add(req.senderId);
          requestStatus[req.senderId] = 'friends';
        }
      }
    } catch (e) {
      print('Error loading sent requests: $e');
    }
  }

  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
    } else {
      searchResults.value = users
          .where(
            (user) =>
                user.displayName.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  Future<void> sendFriendRequest(UserModel targetUser) async {
    try {
      if (currentUser == null) return;

      isLoading.value = true;
      error.value = '';

      final currentUserModel = await _firestoreService.getUser(
        currentUser!.uid,
      );
      if (currentUserModel != null) {
        await _firestoreService.sendFriendRequest(
          currentUser!.uid,
          targetUser.id,
          currentUserModel.displayName,
          currentUserModel.email,
          currentUserModel.photoUrl,
        );

        // Update sent request IDs
        sentRequestIds.add(targetUser.id);

        Get.snackbar(
          'Success',
          'Friend request sent to ${targetUser.displayName}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to send friend request');
    } finally {
      isLoading.value = false;
    }
  }

  bool hasRequestSent(String userId) {
    return sentRequestIds.contains(userId);
  }

  bool isFriend(String userId) {
    return friendIds.contains(userId);
  }

  String getRequestStatus(String userId) {
    return requestStatus[userId] ?? 'none';
  }

  void markAsAccepted(String userId) {
    if (sentRequestIds.contains(userId)) {
      sentRequestIds.remove(userId);
    }
    friendIds.add(userId);
    requestStatus[userId] = 'friends';
  }

  void resetRequestStatus(String userId) {
    sentRequestIds.remove(userId);
    friendIds.remove(userId);
    requestStatus.remove(userId);
  }
}
