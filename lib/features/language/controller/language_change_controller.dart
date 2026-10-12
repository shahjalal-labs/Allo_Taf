import 'package:allo_taf/core/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageChangeController extends GetxController {
  RxString selectedLanguage = "English".obs;
  RxString tempLanguage = "English".obs;

  @override
  void onInit() {
    super.onInit();
    // Load the saved state from AuthService when app starts
    selectedLanguage.value = AuthService.language;
    tempLanguage.value = AuthService.language;
  }

  void openDialog() {
    tempLanguage.value = selectedLanguage.value;
  }

  void selectLanguage(String language) {
    tempLanguage.value = language;
  }

  void applyLanguage() {
    selectedLanguage.value = tempLanguage.value;

    // Persist the selection
    AuthService.saveLanguage(selectedLanguage.value);

    if (selectedLanguage.value == "English") {
      Get.updateLocale(const Locale("en", "US"));
    } else {
      Get.updateLocale(const Locale("fr", "FR"));
    }
  }
}
