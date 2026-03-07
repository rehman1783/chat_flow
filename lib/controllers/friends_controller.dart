import 'package:chat_flow/models/user_model.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RxList<UserModel> friends = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  Future<void> loadFriends() async {
    try {
      isLoading.value = true;
      error.value = '';

      if (currentUser != null) {
        final userFriends = await _firestoreService.getUserFriends(
          currentUser!.uid,
        );
        friends.value = userFriends;
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load friends');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFriends() async {
    await loadFriends();
  }
}
