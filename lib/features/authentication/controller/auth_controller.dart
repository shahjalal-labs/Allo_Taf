import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import 'package:file_picker/file_picker.dart'; // <--- IMPORTED FILE PICKER
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/global/app_item_list.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/utils/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final ImagePicker _picker = ImagePicker();
  final otpController = TextEditingController();
  final resendSeconds = 59.obs;
  final canResend = false.obs;
  Timer? _timer;
  final selectedRole = 'EMPLOYEE'.obs;
  final cityController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final selectedCity = ''.obs;
  final selectedNeighborhood = ''.obs;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();
  final profileImagePath = ''.obs;
  final cvPath = ''.obs;
  final selectedSkills = <String>[].obs;
  final selectedStartDate = ''.obs;
  final selectedEndDate = ''.obs;
  final List<String> skillsList = AppItemsList.skillsList;
  final businessNameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final recruiterPhoneController = TextEditingController();
  final bioController = TextEditingController();

  void startResendTimer() {
    _timer?.cancel();
    resendSeconds.value = 119;
    canResend.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  String get formattedTimer {
    final minutes = (resendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (resendSeconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void handleContinue(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      loginCheck();
    }
  }

  List<String> get filteredNeighborhoods {
    if (selectedCity.value == "Douala") {
      return AppItemsList.neighborhoodsOfDouala;
    } else if (selectedCity.value == "Yaoundé") {
      return AppItemsList.neighborhoodsOfYaounde;
    }
    return [];
  }

  Future<void> pickProfileImageFromCamera() async {
    await _pickImage(
      ImageSource.camera,
      (path) => profileImagePath.value = path,
    );
  }

  Future<void> pickProfileImageFromGallery() async {
    await _pickImage(
      ImageSource.gallery,
      (path) => profileImagePath.value = path,
    );
  }

  Future<void> pickCVImageFromCamera() async {
    await _pickImage(ImageSource.camera, (path) => cvPath.value = path);
  }

  Future<void> pickCVImageFromGallery() async {
    await _pickImage(ImageSource.gallery, (path) => cvPath.value = path);
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
        "${"Failed to pick document".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _pickImage(ImageSource source, Function(String) onPicked) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        onPicked(image.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to pick image".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _formatPhoneForBackend(String rawPhone) {
    String cleanPhone = rawPhone.trim().replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    return "+237$cleanPhone";
  }

  Future<void> loginCheck() async {
    isLoading.value = true;
    try {
      final response = await networkCaller.postRequest(
        AppUrls.login,
        body: {"email": emailController.text.trim()},
      );
      log(response.responseData.toString());
      if (response.isSuccess) {
        Get.toNamed(AppRoutes.verifyOtp);
      } else {
        final responseMap = response.responseData;
        final String apiMessage = responseMap is Map
            ? (responseMap["message"] ?? "")
            : "";
        final String errorMessage = response.errorMessage;

        final bool isUserNotFound =
            apiMessage.toLowerCase().contains("user not found") ||
            errorMessage.toLowerCase().contains("user not found");

        if (isUserNotFound) {
          Get.toNamed(AppRoutes.roleSelection);
        } else {
          Get.snackbar(
            "Error".tr,
            apiMessage.isNotEmpty
                ? apiMessage
                : (errorMessage.isNotEmpty
                      ? errorMessage
                      : "Failed to login".tr),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to login".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleVerifyOtp() async {
    if (otpController.text.length == 4) {
      isLoading.value = true;

      try {
        final response = await networkCaller.postRequest(
          AppUrls.verifyOtp,
          body: {
            "email": emailController.text.trim(),
            "fcmToken": AuthService.fcmToken ?? "FCM_TOKEN",
            "otp": otpController.text.trim(),
          },
        );

        if (response.isSuccess && response.responseData != null) {
          final result = response.responseData["result"];

          if (result != null) {
            final String token = result["accessToken"] ?? "";
            final String role = result["role"] ?? "";
            final String userId = result["userId"] ?? "";

            await AuthService.saveToken(token);
            await AuthService.saveRole(role);
            await AuthService.saveId(userId);

            if (role == "EMPLOYEE") {
              Get.offAllNamed(AppRoutes.employeeNav);
            } else {
              Get.offAllNamed(AppRoutes.recruiterNav);
            }
          }
        } else {
          final responseMap = response.responseData;
          final String apiMessage = responseMap is Map
              ? (responseMap["message"] ?? "")
              : "";
          final String errorMessage = response.errorMessage;

          final bool isUserNotFound =
              apiMessage.toLowerCase().contains("user not found") ||
              errorMessage.toLowerCase().contains("user not found");

          if (isUserNotFound) {
            Get.toNamed(AppRoutes.roleSelection);
          } else {
            Get.snackbar(
              "Error".tr,
              apiMessage.isNotEmpty
                  ? apiMessage
                  : (errorMessage.isNotEmpty
                        ? errorMessage
                        : "Failed to verify OTP".tr),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      } catch (e) {
        Get.snackbar(
          "Error".tr,
          "${"Failed to verify OTP".tr}: $e",
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        "Error".tr,
        "Please enter a valid 4-digit code".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> handleRoleSelectionContinue() async {
    await AuthService.saveRole(selectedRole.value.toUpperCase());
    if (selectedRole.value == 'EMPLOYEE') {
      Get.toNamed(AppRoutes.signup);
    } else {
      Get.toNamed(AppRoutes.recruiterSignup);
    }
  }

  void handleConfirmProfile(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      registerEmployee();
    }
  }

  Future<void> registerEmployee() async {
    isLoading.value = true;
    try {
      var uri = Uri.parse(AppUrls.employeeSignup);
      var request = http.MultipartRequest('POST', uri);

      request.headers['Content-Type'] = 'application/json';

      String formattedStartDate = _convertToIsoString(selectedStartDate.value);
      String formattedEndDate = _convertToIsoString(selectedEndDate.value);

      final Map<String, dynamic> bodyDataMap = {
        "availability": {
          "startDate": formattedStartDate,
          "endDate": formattedEndDate,
        },
        "bio": descriptionController.text.trim(),
        "city": selectedCity.value,
        "email": emailController.text.trim(),
        "fullName": nameController.text.trim(),
        "neighborhood": selectedNeighborhood.value,
        "phoneNumber": _formatPhoneForBackend(phoneController.text),
        "role": "EMPLOYEE",
        "skills": selectedSkills.toList(),
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
              contentType: http.MediaType('image', mimeType),
            ),
          );
        }
      }

      if (cvPath.value.isNotEmpty) {
        final cvFile = File(cvPath.value);
        if (await cvFile.exists()) {
          final extension = cvPath.value.split('.').last.toLowerCase();
          http.MediaType contentType;

          if (extension == 'pdf') {
            contentType = http.MediaType('application', 'pdf');
          } else if (extension == 'png') {
            contentType = http.MediaType('image', 'png');
          } else {
            contentType = http.MediaType('image', 'jpeg');
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
          throw Exception("Server took too long to respond. Please try again.");
        },
      );

      var response = await http.Response.fromStream(streamedResponse);
      log(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final result = body['result'];
        if (result != null) {
          if (result['accessToken'] != null) {
            await AuthService.saveToken(result['accessToken']);
          }
          if (result['userId'] != null) {
            await AuthService.saveId(result['userId']);
          }
        }
        await AuthService.saveRole('EMPLOYEE');
        if (selectedCity.value.isNotEmpty) {
          await AuthService.saveCity([selectedCity.value]);
        }
        if (selectedNeighborhood.value.isNotEmpty) {
          await AuthService.saveNeighborhood([selectedNeighborhood.value]);
        }

        if (Get.currentRoute == AppRoutes.signupVerificationScreen) {
          Get.snackbar(
            "Success".tr,
            "A new verification code has been sent to your email".tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.toNamed(AppRoutes.signupVerificationScreen);
        }
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar(
          "Error".tr,
          body['message'] ?? "Failed to register profile".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Failed to register profile: $e".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _convertToIsoString(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now().toUtc().toIso8601String();
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      return parsedDate.toUtc().toIso8601String();
    } catch (_) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }

  Future<void> registerRecruiter() async {
    isLoading.value = true;
    try {
      var uri = Uri.parse(AppUrls.employeeSignup);
      var request = http.MultipartRequest('POST', uri);

      final Map<String, dynamic> bodyDataMap = {
        "bio": bioController.text.trim(),
        "city": selectedCity.value,
        "contactPerson": contactPersonController.text.trim(),
        "email": emailController.text.trim(),
        "fullName": businessNameController.text.trim(),
        "neighborhood": selectedNeighborhood.value,
        "phoneNumber": _formatPhoneForBackend(recruiterPhoneController.text),
        "role": "EMPLOYER",
      };

      request.fields['bodyData'] = jsonEncode(bodyDataMap);

      if (profileImagePath.value.isNotEmpty) {
        final profileFile = File(profileImagePath.value);
        if (await profileFile.exists()) {
          final extension = profileImagePath.value
              .split('.')
              .last
              .toLowerCase();
          final String subType = (extension == 'png')
              ? 'png'
              : (extension == 'webp' ? 'webp' : 'jpeg');

          request.files.add(
            await http.MultipartFile.fromPath(
              'profileImage',
              profileFile.path,
              contentType: http.MediaType('image', subType),
            ),
          );
        }
      }

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception("Server took too long to respond. Please try again.");
        },
      );

      var response = await http.Response.fromStream(streamedResponse);
      log("RECRUITER SIGNUP RESPONSE: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final result = body['result'];

        if (result != null) {
          if (result['accessToken'] != null) {
            await AuthService.saveToken(result['accessToken']);
          }
          if (result['userId'] != null) {
            await AuthService.saveId(result['userId']);
          }
        }

        await AuthService.saveRole('EMPLOYER');
        if (selectedCity.value.isNotEmpty) {
          await AuthService.saveCity([selectedCity.value]);
        }
        if (selectedNeighborhood.value.isNotEmpty) {
          await AuthService.saveNeighborhood([selectedNeighborhood.value]);
        }

        if (Get.currentRoute == AppRoutes.signupVerificationScreen) {
          Get.snackbar(
            "Success".tr,
            "A new verification code has been sent to your email".tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.toNamed(AppRoutes.signupVerificationScreen);
        }
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar(
          "Error".tr,
          body['message'] ?? "Failed to register recruiter".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to register recruiter".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleSignupVerifyOtp() async {
    if (otpController.text.length == 4) {
      isLoading.value = true;
      try {
        final response = await networkCaller.postRequest(
          AppUrls.signupVerification,
          body: {
            "email": emailController.text.trim(),
            "otp": otpController.text.trim(),
          },
        );

        if (response.isSuccess) {
          final result = response.responseData?["result"];
          if (result != null) {
            final String token = result["accessToken"] ?? "";
            final String userId = result["userId"] ?? "";
            final String role = result["role"] ?? AuthService.userRole ?? "";

            if (token.isNotEmpty) await AuthService.saveToken(token);
            if (userId.isNotEmpty) await AuthService.saveId(userId);
            if (role.isNotEmpty) await AuthService.saveRole(role);

            // Save other potential fields
            if (result["isSubscribed"] != null) {
              await AuthService.saveIsSubscribed(
                result["isSubscribed"] == true,
              );
            }
            if (result["subscriptionStatus"] != null) {
              await AuthService.saveSubscriptionStatus(
                result["subscriptionStatus"],
              );
            }
            if (result["subscriptionExpireAt"] != null) {
              await AuthService.saveSubscriptionExpireAt(
                DateTime.tryParse(result["subscriptionExpireAt"]),
              );
            }

            await AuthService.saveStatus(true);

            if (role == "EMPLOYEE") {
              Get.offAllNamed(AppRoutes.employeeNav);
            } else {
              Get.offAllNamed(AppRoutes.recruiterNav);
            }
          } else {
            Get.offAllNamed(AppRoutes.login);
          }
        } else {
          final responseMap = response.responseData;
          final String apiMessage = responseMap is Map
              ? (responseMap["message"] ?? "")
              : "";
          final String errorMessage = response.errorMessage;
          Get.snackbar(
            "Error".tr,
            apiMessage.isNotEmpty
                ? apiMessage
                : (errorMessage.isNotEmpty
                      ? errorMessage
                      : "Failed to verify OTP".tr),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error".tr,
          "${"Failed to verify OTP".tr}: $e",
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        "Error".tr,
        "Please enter a valid 4-digit code".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void setProfileImage(String path) => profileImagePath.value = path;
  void setCVPath(String path) => cvPath.value = path;
  void updateSkills(List<String> skills) => selectedSkills.assignAll(skills);

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: _buildDatePickerTheme,
    );
    if (picked != null) {
      selectedStartDate.value = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    DateTime start = selectedStartDate.value.isEmpty
        ? DateTime.now()
        : DateFormat('dd/MM/yyyy').parse(selectedStartDate.value);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: start,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: _buildDatePickerTheme,
    );
    if (picked != null) {
      selectedEndDate.value = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Widget _buildDatePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Theme.of(context).primaryColor,
          onPrimary: AppColors.whiteColor,
          onSurface: AppColors.blackColor,
        ),
      ),
      child: child!,
    );
  }

  Future<void> handleResendLoginOtpWithTimer() async {
    if (!canResend.value || isLoading.value) return;

    await resendLoginOtp();
  }

  /// Handles Resend OTP for SIGNUP flow with timer check
  Future<void> handleResendSignupOtpWithTimer() async {
    if (!canResend.value || isLoading.value) return;

    await resendSignupOtp();
  }

  /// Core function to resend Login OTP
  Future<void> resendLoginOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Email address is required to resend OTP".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await networkCaller.postRequest(
        AppUrls.login,
        body: {"email": email},
      );

      log("--- RESEND LOGIN OTP RESPONSE ---");
      log("Response Data: ${response.responseData}");

      if (response.isSuccess) {
        otpController.clear();
        startResendTimer(); // <--- RESET TIMER ON SUCCESS
        Get.snackbar(
          "Success".tr,
          "A new verification code has been sent to your email".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final responseMap = response.responseData;
        final String apiMessage = responseMap is Map
            ? (responseMap["message"] ?? "")
            : "";
        final String errorMessage = response.errorMessage;

        Get.snackbar(
          "Error".tr,
          apiMessage.isNotEmpty
              ? apiMessage
              : (errorMessage.isNotEmpty
                    ? errorMessage
                    : "Failed to resend OTP".tr),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log("--- RESEND LOGIN OTP ERROR ---");
      log("Error: $e");
      Get.snackbar(
        "Error".tr,
        "${"Failed to resend OTP".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Core function to resend Signup OTP
  Future<void> resendSignupOtp() async {
    // Store current route to know if we are in verification screen
    final bool isVerificationScreen =
        Get.currentRoute == AppRoutes.signupVerificationScreen;

    if (selectedRole.value == 'EMPLOYEE') {
      await registerEmployee();
    } else {
      await registerRecruiter();
    }

    // Reset timer if we are already on the verification screen and request completed
    if (isVerificationScreen) {
      otpController.clear();
      startResendTimer(); // <--- RESET TIMER ON SUCCESS
    }
  }

  // Ensure startResendTimer() is called when navigating to OTP verification screens
  void prepareOtpScreen() {
    otpController.clear();
    startResendTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
