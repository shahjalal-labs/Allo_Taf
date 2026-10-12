import 'dart:developer';

import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/service/app_urls.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/network_caller.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../model/recruiter_mission_details_model.dart';

class RecruiterJobDetailsController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();

  final isLoading = false.obs;

  /// Holds the root result containing job details and recent applicants
  final jobDetailsResult = Rxn<RecruiterJobDetailResult>();

  /// Convenience getters for UI access
  JobInfo? get job => jobDetailsResult.value?.job;
  List<RecentApplicant> get applicants =>
      jobDetailsResult.value?.recentApplicants ?? [];
  int get applicantCount => jobDetailsResult.value?.applicantCount ?? 0;

  // --- Form Controllers & Selection States for Editing ---
  final titleController = TextEditingController();
  final needController = TextEditingController();
  final remunerationController = TextEditingController();
  final businessNameController = TextEditingController();
  final contactController = TextEditingController();

  final selectedMetiers = <String>[].obs;
  final startDate = "".obs;
  final endDate = "".obs;
  final selectedUrgencyLevel = "URGENT".obs;
  final selectedCity = "Douala".obs;
  final selectedLocation = "Bonamoussadi".obs;
  final selectedDuration = "8".obs;

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

    // Reset neighborhood if it's not present in selected city
    ever(selectedCity, (String city) {
      final available = filteredNeighborhoods;
      if (!available.contains(selectedLocation.value)) {
        selectedLocation.value = available.isNotEmpty ? available.first : "";
      }
    });

    final String? missionId = Get.arguments as String?;
    if (missionId != null && missionId.isNotEmpty) {
      fetchJobDetails(missionId);
    }
  }

  /// Toggles métier selection on or off
  void toggleMetier(String metierName) {
    if (selectedMetiers.contains(metierName)) {
      selectedMetiers.remove(metierName);
    } else {
      selectedMetiers.add(metierName);
    }
  }

  /// Date Picker Helper
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

  /// Fetches job details and populates form fields automatically
  Future<void> fetchJobDetails(String missionId) async {
    try {
      isLoading.value = true;

      final response = await networkCaller.getRequest(
        AppUrls.missionDetails(missionId),
        token: AuthService.token,
      );
      log(response.responseData.toString());
      if (response.isSuccess && response.responseData != null) {
        final data =
            response.responseData!['result'] ?? response.responseData!['data'];

        if (data != null) {
          jobDetailsResult.value = RecruiterJobDetailResult.fromJson(data);

          // Auto-assign fetched data to form controllers
          _populateFormFields();
        }
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
        "${"Failed to fetch job details".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.whiteColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Populates all form fields from fetched `job`
  void _populateFormFields() {
    final currentJob = job;
    if (currentJob == null) return;

    titleController.text = currentJob.title ?? '';
    needController.text = currentJob.description ?? '';
    businessNameController.text = currentJob.businessName ?? '';
    remunerationController.text = currentJob.remuneration.toString();
    contactController.text = currentJob.whatsApp ?? '';

    selectedMetiers.clear();
    if (currentJob.skills!.isNotEmpty) {
      selectedMetiers.assignAll(currentJob.skills ?? []);
    }

    if (currentJob.city!.isNotEmpty) {
      selectedCity.value = currentJob.city ?? '';
    }
    if (currentJob.neighborhood!.isNotEmpty) {
      selectedLocation.value = currentJob.neighborhood ?? '';
    }
    if (currentJob.urgencyLevel!.isNotEmpty) {
      selectedUrgencyLevel.value = currentJob.urgencyLevel ?? '';
    }
    selectedDuration.value = currentJob.workHours.toString();

    if (currentJob.visibilityStartDate!.isNotEmpty) {
      startDate.value = _extractDateOnly(currentJob.visibilityStartDate ?? '');
    }
    if (currentJob.visibilityEndDate!.isNotEmpty) {
      endDate.value = _extractDateOnly(currentJob.visibilityEndDate ?? '');
    }
  }

  /// Sends the PUT request to save changes
  Future<void> handleUpdateMission(String missionId) async {
    final formattedContact = _formatWhatsAppNumber(
      contactController.text.trim(),
    );

    if (titleController.text.trim().isEmpty ||
        needController.text.trim().isEmpty ||
        remunerationController.text.trim().isEmpty ||
        startDate.value.isEmpty ||
        endDate.value.isEmpty ||
        formattedContact.isEmpty) {
      Get.snackbar(
        "Missing Fields".tr,
        "Please fill in all mandatory fields before saving.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final Map<String, dynamic> requestBody = {
        "title": titleController.text.trim(),
        "description": needController.text.trim(),
        "businessName": businessNameController.text.trim(),
        "city": selectedCity.value,
        "neighborhood": selectedLocation.value,
        "remuneration": num.tryParse(remunerationController.text.trim()) ?? 0,
        "skills": selectedMetiers.toList(),
        "urgencyLevel": selectedUrgencyLevel.value,
        "visibilityStartDate": _toIso8601String(startDate.value, isEnd: false),
        "visibilityEndDate": _toIso8601String(endDate.value, isEnd: true),
        "whatsApp": formattedContact,
        "work_hours": _parseWorkHours(selectedDuration.value),
      };

      final response = await networkCaller.patchRequest(
        AppUrls.updateMission(missionId),
        token: AuthService.token,
        body: requestBody,
      );

      if (response.isSuccess) {
        Get.snackbar(
          "Success".tr,
          "Mission updated successfully!".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: AppColors.whiteColor,
        );
        await Future.delayed(const Duration(seconds: 1));
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
        "${"Failed to update mission".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.whiteColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Formats date to ISO-8601 UTC
  String _toIso8601String(String dateStr, {bool isEnd = false}) {
    try {
      final parsedDate = DateTime.parse(dateStr);
      final dateTime = isEnd
          ? DateTime.utc(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              23,
              59,
              59,
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

  String _extractDateOnly(String isoString) {
    try {
      final parsed = DateTime.parse(isoString);
      return "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return isoString.split("T").first;
    }
  }

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

  int _parseWorkHours(String duration) {
    final numStr = RegExp(r'\d+').stringMatch(duration);
    return numStr != null ? int.parse(numStr) : 8;
  }

  /// Opens WhatsApp chat using dynamic recipient number
  Future<void> openWhatsAppChat(String number) async {
    final cleanedPhone = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanedPhone.isEmpty) {
      Get.snackbar(
        "Invalid Number".tr,
        "WhatsApp number is not available.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
      );
      return;
    }

    final message =
        "Hello, I am contacting you regarding your job application.".tr;

    final Uri url = Uri.parse(
      "https://wa.me/${cleanedPhone.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error".tr,
          "Could not launch WhatsApp.".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Could not open WhatsApp".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
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
