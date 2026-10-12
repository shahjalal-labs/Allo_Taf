import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:allo_taf/core/global/custom_dialog.dart';
import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:file_picker/file_picker.dart'; // <--- IMPORTED FILE PICKER
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_routes.dart';
import '../model/my_profile_model.dart';

class EmployeeProfileController extends GetxController {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final businessNameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  final employeeName = "".obs;
  final profileImageUrl = "".obs;
  final cvUrl = "".obs;

  final selectedCity = "".obs;
  final selectedNeighborhood = "".obs;
  final selectedDesignation = "".obs;
  final selectedSkills = <String>[].obs;

  final profileImagePath = ''.obs;
  final cvPath = ''.obs;

  final ImagePicker _picker = ImagePicker();
  final NetworkCaller networkCaller = NetworkCaller();

  final selectedStartDate = ''.obs;
  final selectedEndDate = ''.obs;

  final isLoading = false.obs;
  final isFetching = false.obs;

  MyProfileModel? profileModel;

  List<String> get filteredNeighborhoods {
    if (selectedCity.value == "Douala") {
      return AppItemsList.neighborhoodsOfDouala;
    } else if (selectedCity.value == "Yaoundé") {
      return AppItemsList.neighborhoodsOfYaounde;
    }
    return [];
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    isFetching.value = true;
    try {
      final response = await networkCaller.getRequest(
        AppUrls.getMe,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        profileModel = MyProfileModel.fromJson(response.responseData);

        final data = profileModel?.result;
        if (data != null) {
          if (data.city != null) {
            await AuthService.saveCity([data.city!]);
          }
          if (data.neighborhood != null) {
            await AuthService.saveNeighborhood([data.neighborhood!]);
          }

          if (data.isSubscribed != null) {
            await AuthService.saveIsSubscribed(data.isSubscribed!);
          }
          if (data.subscriptionExpireAt != null) {
            await AuthService.saveSubscriptionExpireAt(
              data.subscriptionExpireAt!,
            );
          }
          if (data.subscriptionStatus != null) {
            await AuthService.saveSubscriptionStatus(data.subscriptionStatus!);
          }
        }
        populateFieldsForEdit();
      } else {
        Get.snackbar(
          "Error".tr,
          response.displayMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to load profile data".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFetching.value = false;
    }
  }

  void toggleSkill(String skillTitle) {
    if (selectedSkills.contains(skillTitle)) {
      selectedSkills.remove(skillTitle);
    } else {
      selectedSkills.add(skillTitle);
    }
  }

  void populateFieldsForEdit() {
    final data = profileModel?.result;
    if (data == null) return;

    profileImagePath.value = '';
    cvPath.value = '';

    employeeName.value = data.fullName ?? "";
    userNameController.text = data.fullName ?? "";
    emailController.text = data.email ?? "";
    phoneNumberController.text = data.phoneNumber ?? "";
    descriptionController.text = data.bio ?? "";

    profileImageUrl.value = data.profileImage ?? "";
    cvUrl.value = data.cv ?? "";

    selectedCity.value = data.city ?? "";
    selectedNeighborhood.value = data.neighborhood ?? "";

    if (data.designation != null && data.designation!.isNotEmpty) {
      selectedDesignation.value = data.designation!.first;
    } else {
      selectedDesignation.value = "";
    }

    if (data.skills != null) {
      selectedSkills.assignAll(data.skills!);
    } else {
      selectedSkills.clear();
    }

    if (data.availabilityStart != null) {
      selectedStartDate.value = DateFormat(
        'dd/MM/yyyy',
      ).format(data.availabilityStart!);
    } else {
      selectedStartDate.value = "";
    }

    if (data.availabilityEnd != null) {
      selectedEndDate.value = DateFormat(
        'dd/MM/yyyy',
      ).format(data.availabilityEnd!);
    } else {
      selectedEndDate.value = "";
    }
  }

  Future<void> handleConfirmUpdate() async {
    isLoading.value = true;
    try {
      var uri = Uri.parse(AppUrls.updateProfile);
      var request = http.MultipartRequest('PATCH', uri);

      String? token = AuthService.token;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = token;
      }

      String formattedStartDate = _convertToIsoString(selectedStartDate.value);
      String formattedEndDate = _convertToIsoString(selectedEndDate.value);
      final String formattedPhone = _formatPhoneForBackend(
        phoneNumberController.text,
      );

      final Map<String, dynamic> bodyDataMap = {
        "fullName": userNameController.text.trim(),
        "phoneNumber": formattedPhone,
        "city": selectedCity.value,
        "neighborhood": selectedNeighborhood.value,
        "bio": descriptionController.text.trim(),
        "skills": selectedSkills.toList(),
        "designation": selectedDesignation.value.isNotEmpty
            ? [selectedDesignation.value]
            : [],
        "availability": {
          "startDate": formattedStartDate,
          "endDate": formattedEndDate,
        },
      };

      request.fields['bodyData'] = jsonEncode(bodyDataMap);

      if (profileImagePath.value.isNotEmpty) {
        final profileFile = File(profileImagePath.value);
        if (await profileFile.exists()) {
          final extension = profileImagePath.value
              .split('.')
              .last
              .toLowerCase();
          final mimeType = (extension == 'png') ? 'png' : 'jpeg';
          request.files.add(
            await http.MultipartFile.fromPath(
              'profileImage',
              profileFile.path,
              contentType: MediaType('image', mimeType),
            ),
          );
        }
      }

      if (cvPath.value.isNotEmpty) {
        final cvFile = File(cvPath.value);
        if (await cvFile.exists()) {
          final extension = cvPath.value.split('.').last.toLowerCase();
          MediaType contentType;

          if (extension == 'pdf') {
            contentType = MediaType('application', 'pdf');
          } else if (extension == 'png') {
            contentType = MediaType('image', 'png');
          } else {
            contentType = MediaType('image', 'jpeg');
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'cv',
              cvFile.path,
              contentType: contentType,
            ),
          );
        }
      }

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
            "Server took too long to respond. Please try again.".tr,
          );
        },
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success".tr,
          "Profile updated successfully".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchProfileData();
        Get.back();
      } else {
        String errorMessage = "Failed to update profile".tr;
        try {
          final body = jsonDecode(response.body);
          if (body['message'] != null) {
            errorMessage = body['message'];
          }
        } catch (_) {}
        Get.snackbar(
          "Error".tr,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to update profile".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) profileImagePath.value = image.path;
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Failed to pick image: $e".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickCVFile(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (file != null) cvPath.value = file.path;
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Failed to pick file: $e".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // <--- ADDED METHOD TO PICK CV DOCUMENTS (PDF/IMAGES) --->
  Future<void> pickCVDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        cvPath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Failed to pick document: $e".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> selectDate(
    BuildContext context,
    RxString dateRx, {
    DateTime? initialDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: const ColorScheme.light(primary: Colors.blue)),
        child: child!,
      ),
    );
    if (picked != null) dateRx.value = DateFormat('dd/MM/yyyy').format(picked);
  }

  String _convertToIsoString(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now().toUtc().toIso8601String();
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      return parsedDate.toUtc().toIso8601String();
    } catch (_) {
      try {
        return DateTime.parse(dateStr).toUtc().toIso8601String();
      } catch (_) {
        return DateTime.now().toUtc().toIso8601String();
      }
    }
  }

  String _formatPhoneForBackend(String rawPhone) {
    String cleanPhone = rawPhone.trim().replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.isEmpty) return "";
    if (cleanPhone.startsWith('0')) cleanPhone = cleanPhone.substring(1);
    if (!cleanPhone.startsWith('237')) cleanPhone = "237$cleanPhone";
    return "+$cleanPhone";
  }

  void navigateToEditProfile() {
    populateFieldsForEdit();
    Get.toNamed(AppRoutes.employeeEditProfile);
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      final response = await networkCaller.deleteRequest(
        AppUrls.deleteAccount(),
        AuthService.token,
        body: {},
      );
      log(response.responseData.toString());
      if (response.statusCode == 200 || response.isSuccess) {
        AuthService.logoutUser();
      } else {
        log("Failed to delete account: ${response.errorMessage}");
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUserF() async {
    isLoading.value = true;
    try {
      final response = await networkCaller.postRequest(
        AppUrls.logoutAccount(),
        body: {},
        token: AuthService.token,
      );
      log(response.responseData.toString());
      if (response.statusCode == 200 || response.isSuccess) {
        AuthService.logoutUser();
      } else {
        log("Failed to logout: ${response.errorMessage}");
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void handleDeleteAccount() {
    CustomDialog(
      imagePath: IconPath.appLogo,
      title: "Delete Account".tr,
      content: "Are you sure you want to delete your account?".tr,
      cancelText: "Cancel".tr,
      onConfirm: "Delete".tr,
      onTap: () => deleteAccount(),
      imageHeight: 70.h,
      imageWidth: 70.w,
    );
  }

  void handleLogout() {
    CustomDialog(
      imagePath: IconPath.appLogo,
      title: "Logout".tr,
      content: "Are you sure you want to logout?".tr,
      cancelText: "Cancel".tr,
      onConfirm: "Logout".tr,
      onTap: () => logoutUserF(),
      imageHeight: 70.h,
      imageWidth: 70.w,
    );
  }

  @override
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    contactPersonController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
