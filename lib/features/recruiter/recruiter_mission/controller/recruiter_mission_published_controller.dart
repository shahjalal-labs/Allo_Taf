import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/service/app_urls.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/network_caller.dart';
import '../../../../core/utils/constants/app_colors.dart';

class RecruiterMissionPublishedController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();

  // Text Input controllers
  final titleController = TextEditingController();
  final needController = TextEditingController();
  final remunerationController = TextEditingController();
  final businessNameController = TextEditingController();
  final contactController = TextEditingController();

  // Selection states
  final selectedMetiers = <String>[].obs;
  final startDate = "".obs;
  final endDate = "".obs;
  final selectedUrgencyLevel = "URGENT".obs;
  final selectedCity = "Douala".obs;
  final selectedLocation = "Bonamoussadi".obs;
  final selectedDuration = "8".obs;

  final isLoading = false.obs;

  List<String> get filteredNeighborhoods {
    if (selectedCity.value == "Douala") {
      return AppItemsList.neighborhoodsOfDouala;
    } else if (selectedCity.value == "Yaoundé") {
      return AppItemsList.neighborhoodsOfYaounde;
    }
    return AppItemsList.neighborhoodsOfDouala;
  }

  @override
  void onInit() {
    super.onInit();

    ever(selectedCity, (String city) {
      final available = filteredNeighborhoods;
      if (!available.contains(selectedLocation.value)) {
        selectedLocation.value = available.isNotEmpty ? available.first : "";
      }
    });
  }

  void toggleMetier(String metierName) {
    if (selectedMetiers.contains(metierName)) {
      selectedMetiers.remove(metierName);
    } else {
      selectedMetiers.add(metierName);
    }
  }

  Future<void> chooseDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      if (isStartDate) {
        startDate.value = formattedDate;
      } else {
        endDate.value = formattedDate;
      }
    }
  }

  /// Converts date string to ISO-8601 UTC string (`YYYY-MM-DDTHH:mm:ssZ`)
  String _toIso8601String(String dateStr, {bool isEnd = false}) {
    try {
      final parsedDate = DateTime.parse(dateStr);
      final dateTime = isEnd
          ? DateTime.utc(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              0,
              0,
              0,
            )
          : DateTime.utc(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              0,
              0,
              0,
            );
      return dateTime.toIso8601String();
    } catch (_) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }

  /// Format phone numbers into E.164 (+237...) format
  String _formatWhatsAppNumber(String rawContact) {
    String cleaned = rawContact.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return cleaned;

    if (!cleaned.startsWith('+')) {
      if (cleaned.startsWith('237')) {
        cleaned = '+$cleaned';
      } else {
        cleaned = '+237$cleaned';
      }
    }
    return cleaned;
  }

  /// Extracts integer hours (e.g. "8 hrs" -> 8)
  int _parseWorkHours(String duration) {
    final numStr = RegExp(r'\d+').stringMatch(duration);
    return numStr != null ? int.parse(numStr) : 8;
  }

  Future<void> handlePublishMission() async {
    final formattedContact = _formatWhatsAppNumber(
      contactController.text.trim(),
    );

    // Validation checks
    final List<String> missingFields = [];
    if (titleController.text.trim().isEmpty) missingFields.add("Title".tr);
    if (needController.text.trim().isEmpty) missingFields.add("Description".tr);
    if (remunerationController.text.trim().isEmpty) {
      missingFields.add("Remuneration".tr);
    }
    if (startDate.value.isEmpty) missingFields.add("Start Date".tr);
    if (endDate.value.isEmpty) missingFields.add("End Date".tr);
    if (formattedContact.isEmpty) missingFields.add("WhatsApp Contact".tr);

    if (missingFields.isNotEmpty) {
      Get.snackbar(
        "Missing Fields".tr,
        "${"Please fill in: ".tr}${missingFields.join(', ')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
      );
      return;
    }

    final startDt = DateTime.tryParse(startDate.value);
    final endDt = DateTime.tryParse(endDate.value);
    if (startDt != null && endDt != null && endDt.isBefore(startDt)) {
      Get.snackbar(
        "Invalid Dates".tr,
        "End date must be on or after start date.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Constructs payload matching backend requirements strictly
      final Map<String, dynamic> requestBody = {
        "businessName": businessNameController.text.trim().isNotEmpty
            ? businessNameController.text.trim()
            : "TechCorp",
        "city": selectedCity.value,
        "description": needController.text.trim(),
        "neighborhood": selectedLocation.value,
        "remuneration": int.tryParse(remunerationController.text.trim()) ?? 0,
        "skills": selectedMetiers.toList(),
        "title": titleController.text.trim(),
        "urgencyLevel": selectedUrgencyLevel.value,
        "visibilityEndDate": _toIso8601String(endDate.value, isEnd: true),
        "visibilityStartDate": _toIso8601String(startDate.value, isEnd: false),
        "whatsApp": formattedContact,
        "work_hours": _parseWorkHours(selectedDuration.value),
      };

      final response = await networkCaller.postRequest(
        AppUrls.publishMission,
        token: AuthService.token,
        body: requestBody,
      );

      if (response.isSuccess) {
        Get.snackbar(
          "Success".tr,
          "Your mission has been published successfully!".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: AppColors.whiteColor,
        );
        await Future.delayed(const Duration(seconds: 1));
        Get.back(result: true);
        Get.back();
      } else {
        Get.snackbar(
          "Error".tr,
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: AppColors.whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to publish mission".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.whiteColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    needController.dispose();
    remunerationController.dispose();
    businessNameController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
