import 'package:chat_flow/models/user_model.dart';
import 'package:chat_flow/routes/app_routes.dart';
import 'package:chat_flow/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<User?> _user = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isinitialized = false.obs;

  User? get user => _user.value;
  UserModel? get userModel => _userModel.value;
  String get error => _error.value;
  bool get isInitialized => _isinitialized.value;
  bool get isAuthenticated => _user.value != null;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_authService.authStateChanges);
    ever(_user, _handleAuthStateChange);
  }

  // ================= AUTH STATE LISTENER =================
  void _handleAuthStateChange(User? user) {
    if (!_isinitialized.value) {
      _isinitialized.value = true;
    }

    // Delay navigation until the widget tree is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user == null) {
        if (Get.currentRoute != AppRoutes.login &&
            Get.isRegistered<AuthController>()) {
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        if (Get.currentRoute != AppRoutes.home &&
            Get.isRegistered<AuthController>()) {
          Get.offAllNamed(AppRoutes.home);
        }
      }
    });
  }

  // ================= INITIAL CHECK =================
  void checkInitialAuthState() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user.value = currentUser;
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }

    _isinitialized.value = true;
  }

  // ================= SIGN IN =================
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      UserModel? userModel = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (userModel != null) {
        _userModel.value = userModel;
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Login Failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Login error: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // ================= REGISTER =================
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      UserModel? userModel = await _authService.registerWithEmailAndPassword(
        email,
        password,
        displayName,
      );

      if (userModel != null) {
        _userModel.value = userModel;
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Registration Failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Registration error: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // ================= LOGOUT =================
  // ================= LOGOUT =================
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      await _authService.signOut();
      _userModel.value = null;

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Logout Failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Logout error: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // ================= DELETE ACCOUNT =================
  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      await _authService.deleteAccount();
      _userModel.value = null;

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Account Deletion Failed',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Account deletion error: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // ================= RESET PASSWORD =================
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      await _authService.sendPasswordResetEmail(email);

      Get.snackbar(
        'Success',
        'Password reset email sent',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to send password reset email',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Password reset error: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }
}
