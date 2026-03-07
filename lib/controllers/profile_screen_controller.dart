import 'package:chat_flow/models/user_model.dart';
import 'package:chat_flow/services/auth_service.dart';
import 'package:chat_flow/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString displayName = ''.obs;
  final RxString email = ''.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      if (currentUser != null) {
        final user = await _firestoreService.getUser(currentUser!.uid);
        if (user != null) {
          userModel.value = user;
          displayName.value = user.displayName;
          email.value = user.email;
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(String newDisplayName) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (currentUser != null) {
        await _firestoreService.updateUserProfile(
          currentUser!.uid,
          newDisplayName,
          userModel.value?.photoUrl ?? '',
        );

        displayName.value = newDisplayName;

        // Create a new UserModel with updated displayName
        if (userModel.value != null) {
          userModel.value = userModel.value!.copyWith(
            displayName: newDisplayName,
          );
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (currentUser != null && currentUser!.email != null) {
        // Re-authenticate user before changing password
        await currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: currentUser!.email!,
            password: currentPassword,
          ),
        );

        // Update password
        await currentUser!.updatePassword(newPassword);

        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to change password: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to logout');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await _authService.deleteAccount();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to delete account');
    } finally {
      isLoading.value = false;
    }
  }
}
