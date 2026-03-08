import 'package:chat_flow/models/chat_model.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final RxInt selectedIndex = 0.obs;
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  void loadChats() {
    try {
      isLoading.value = true;
      if (currentUser != null) {
        _firestoreService.getUserChatsStream(currentUser!.uid).listen((
          chatList,
        ) {
          // Create a new list to trigger reactivity
          chats.value = List.from(chatList);
          isLoading.value = false;
        }, onError: (error) {
          this.error.value = error.toString();
          isLoading.value = false;
          print('Error loading chats: $error');
        });
      }
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
      print('Error loading chats: $e');
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> refreshChats() async {
    loadChats();
  }
}
