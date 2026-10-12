import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/features/employee/employee_missions/data/buy_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class EmployeePaymentController extends GetxController {
  final isLoading = false.obs;
  var selectedMethod = 0.obs;

  // List to hold up to 2 proof images
  final RxList<File> selectedImages = <File>[].obs;

  // Controllers for input fields
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();

  RxString transactionId = "".obs;

  final ImagePicker _picker = ImagePicker();

  List<BuyPlanModel> plans = [
    BuyPlanModel(
      title: "Free",
      price: "0",
      currency: "FCFA",
      features: [
        "Create a profile",
        "Browse available jobs",
        "Apply for jobs",
        "Be contacted via WhatsApp",
      ],
      isFree: true,
    ),
    BuyPlanModel(
      title: "Priority Profile",
      badge: "Be seen first",
      price: "2,000",
      currency: "FCFA/month",
      features: [
        "Continusly boosted profile",
        "Featured CV",
        "Priority access to new job opportunities",
        // "CV featured",
        // "CV Visible in the CV Database",
        // "Profile Boost – 24 hours",
        // "Profile Boost – 7 days"
      ],
      isFree: false,
    ),
  ];

  /// Pick Image from Camera or Gallery with downscaling & compression to avoid connection resets
  Future<void> pickImage(ImageSource source) async {
    log('--- [pickImage] Starting image pick from source: $source ---');

    if (selectedImages.length >= 2) {
      log('[pickImage] Image limit reached (2 max).');
      Get.snackbar(
        "Limit Reached".tr,
        "You can only upload a maximum of 2 proof images.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 30, // Stricter compression to fit 100KB limit
        maxWidth: 500, // Smaller dimensions
        maxHeight: 500,
      );
      if (pickedFile != null) {
        log('[pickImage] Selected file path: ${pickedFile.path}');
        selectedImages.add(File(pickedFile.path));
      }
    } catch (e, stackTrace) {
      log(
        '[pickImage] Error picking image: $e',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar(
        "Error".tr,
        "${'Failed to pick image'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Remove image at index
  void removeImageAt(int index) {
    if (index >= 0 && index < selectedImages.length) {
      final removed = selectedImages.removeAt(index);
      log('[removeImageAt] Removed file: ${removed.path}');
    }
  }

  /// Submit payment and proof images using http.MultipartRequest
  Future<bool> onPaymentConfirmed({
    required String paymentMethod,
    required String phoneNumber,
    required String transactionId,
  }) async {
    log('==================================================');
    log('--- [onPaymentConfirmed] PAYMENT SUBMISSION INIT ---');
    log('Payment Method: $paymentMethod');
    log('Phone Number: $phoneNumber');
    log('Transaction ID: $transactionId');
    log('Attached Images Count: ${selectedImages.length}');

    try {
      isLoading.value = true;

      final urlString = AppUrls.subscription();
      final uri = Uri.parse(urlString);
      log('Target URL: $urlString');

      final request = http.MultipartRequest('POST', uri);

      // Attach Authorization Header (No Bearer prefix as per project requirement)
      if (AuthService.token != null && AuthService.token!.isNotEmpty) {
        request.headers['Authorization'] = AuthService.token.toString();
        log('Authorization Header attached.');
      } else {
        log('WARNING: AuthService.token is empty or null');
      }

      request.headers['Accept'] = 'application/json';

      final String formattedPhone = _formatPhoneForBackend(phoneNumber);
      log('Formatted Phone Number for backend: $formattedPhone');

      // Map payment method to enum values expected by backend
      String backendPaymentMethod = paymentMethod;
      if (paymentMethod == "Orange Money") {
        backendPaymentMethod = "ORANGE_MONEY";
      } else if (paymentMethod == "MTN Mobile Money") {
        backendPaymentMethod = "MTN_MOBILE_MONEY";
      }

      final Map<String, dynamic> jsonPayload = {
        "paymentMethod": backendPaymentMethod,
        "phoneNumber": formattedPhone,
        "plan": "MONTHLY",
        "transactionId": transactionId,
      };

      final String bodyDataString = jsonEncode(jsonPayload);
      request.fields['bodyData'] = bodyDataString;
      log('Field bodyData payload: $bodyDataString');

      // Attach proof images
      for (int i = 0; i < selectedImages.length; i++) {
        final imageFile = selectedImages[i];
        log('Attaching image [$i]: ${imageFile.path}');

        final String? mimeType = lookupMimeType(imageFile.path);
        final MediaType? contentType = mimeType != null
            ? MediaType.parse(mimeType)
            : null;

        final multipartFile = await http.MultipartFile.fromPath(
          'proofImages',
          imageFile.path,
          contentType: contentType,
        );
        request.files.add(multipartFile);
      }

      log('Sending HTTP Multipart request...');
      final stopwatch = Stopwatch()..start();

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      stopwatch.stop();
      log('--- API Response Received ---');
      log('Status Code: ${response.statusCode}');
      log('Execution Time: ${stopwatch.elapsedMilliseconds} ms');
      log('Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        log('Payment submitted successfully.');
        Get.snackbar(
          "Success".tr,
          "Subscription submitted successfully!".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        log('==================================================');
        return true;
      } else {
        log(
          'Payment submission failed with status code ${response.statusCode}.',
        );
        final responseData = jsonDecode(response.body);
        final errorMessage =
            responseData['message'] ?? "Failed to submit subscription.".tr;

        log('Parsed Error Message: $errorMessage');
        Get.snackbar(
          "Error".tr,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
        log('==================================================');
        return false;
      }
    } on SocketException catch (e, stackTrace) {
      log(
        '--- SocketException (Connection Reset) ---',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar(
        "Connection Error".tr,
        "Server connection was interrupted. Please check your network or upload smaller image files."
            .tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      log('==================================================');
      return false;
    } on TimeoutException catch (e, stackTrace) {
      log('--- TimeoutException ---', error: e, stackTrace: stackTrace);
      Get.snackbar(
        "Timeout Error".tr,
        "The server took too long to respond. Please check your internet connection and try again."
            .tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      log('==================================================');
      return false;
    } catch (e, stackTrace) {
      log(
        '--- EXCEPTION IN [onPaymentConfirmed] ---',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar(
        "Error".tr,
        "${'An unexpected error occurred'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      log('==================================================');
      return false;
    } finally {
      isLoading.value = false;
      log('[onPaymentConfirmed] isLoading set back to false.');
    }
  }

  String generateTransactionId() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    transactionId.value = id;
    log('Generated Transaction ID: $id');
    return id;
  }

  String _formatPhoneForBackend(String rawPhone) {
    String cleanPhone = rawPhone.trim().replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.isEmpty) return "";
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    if (!cleanPhone.startsWith('237')) {
      cleanPhone = "237$cleanPhone";
    }
    return "+$cleanPhone";
  }

  @override
  void onClose() {
    log(
      '--- [EmployeePaymentController] onClose called. Cleaning resources... ---',
    );
    selectedMethod.value = 0;
    selectedImages.clear();
    phoneController.dispose();
    transactionIdController.dispose();
    super.onClose();
  }
}
