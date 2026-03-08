import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  late final GetStorage _storage;
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  Future<void> onInit() async {
    super.onInit();
    _storage = GetStorage();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    final savedTheme = _storage.read('isDarkMode');
    if (savedTheme != null) {
      _isDarkMode.value = savedTheme;
    }
  }

  void toggleTheme() {
    _isDarkMode.toggle();
    _storage.write('isDarkMode', _isDarkMode.value);
    Get.back();
  }
}
