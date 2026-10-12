import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class RecruiterSubscriptionController extends GetxController {
  final isLoading = false.obs;

  // List to hold up to 2 proof images
  final RxList<File> selectedImages = <File>[].obs;

  final ImagePicker _picker = ImagePicker();

  /// Pick Image from Camera or Gallery with 2-image limit
  Future<void> pickImage(ImageSource source) async {
    debugPrint("=== [RecruiterSubscription] Picking Image ===");
    debugPrint("Source: $source");
    debugPrint("Current Selected Images Count: ${selectedImages.length}");

    if (selectedImages.length >= 2) {
      debugPrint("⚠️ Limit reached: Cannot select more than 2 images.");
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
        debugPrint("✅ Image picked successfully: ${pickedFile.path}");
        selectedImages.add(File(pickedFile.path));
        debugPrint("Updated Selected Images Count: ${selectedImages.length}");
      } else {
        debugPrint("ℹ️ Image picking cancelled by user.");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error picking image: $e");
      debugPrint("StackTrace: $stackTrace");
      Get.snackbar(
        "Error".tr,
        "${'Failed to pick image'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Remove image at index
  void removeImageAt(int index) {
    debugPrint("=== [RecruiterSubscription] Removing Image ===");
    debugPrint("Index to remove: $index");

    if (index >= 0 && index < selectedImages.length) {
      final removedFile = selectedImages.removeAt(index);
      debugPrint("✅ Removed image: ${removedFile.path}");
      debugPrint("Remaining Images Count: ${selectedImages.length}");
    } else {
      debugPrint(
        "⚠️ Invalid index $index for list length ${selectedImages.length}",
      );
    }
  }

  /// Submit payment and proof images using http.MultipartRequest
  Future<bool> onPaymentConfirmed({
    required String paymentMethod,
    required String phoneNumber,
    required String transactionId,
  }) async {
    debugPrint(
      "\n================ [Recruiter Payment Submission Started] ================",
    );
    debugPrint("Payment Method : $paymentMethod");
    debugPrint("Phone Number   : $phoneNumber");
    debugPrint("Transaction ID : $transactionId");
    debugPrint(
      "Proof Images   : ${selectedImages.map((f) => f.path).toList()}",
    );

    try {
      isLoading.value = true;

      final uri = Uri.parse(AppUrls.subscription());
      debugPrint("Target URI      : $uri");

      final request = http.MultipartRequest('POST', uri);

      if (AuthService.token != null && AuthService.token!.isNotEmpty) {
        request.headers['Authorization'] = AuthService.token.toString();
        debugPrint("Authorization Header attached.");
      } else {
        debugPrint("⚠️ AuthService.token is null or empty!");
      }

      request.headers['Content-Type'] = 'application/json';

      final String formattedPhone = _formatPhoneForBackend(phoneNumber);
      debugPrint('Formatted Phone Number for backend: $formattedPhone');

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
      debugPrint("Field 'bodyData': $bodyDataString");

      // Attach all selected images under 'proofImages' key
      for (int i = 0; i < selectedImages.length; i++) {
        final imageFile = selectedImages[i];
        debugPrint("Attaching File [$i]: ${imageFile.path}");

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

      debugPrint("Sending Multipart Request...");
      final stopwatch = Stopwatch()..start();

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      stopwatch.stop();
      debugPrint("Request Completed in ${stopwatch.elapsedMilliseconds} ms");
      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Body       : ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("✅ [Subscription Payment Success]");
        Get.snackbar(
          "Success".tr,
          "Subscription submitted successfully!".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        debugPrint(
          "❌ [Subscription Payment Failed] Status: ${response.statusCode}",
        );

        String errorMessage = "Failed to submit subscription.".tr;
        try {
          final responseData = jsonDecode(response.body);
          if (responseData is Map && responseData.containsKey('message')) {
            errorMessage = responseData['message'];
          }
        } catch (e) {
          debugPrint("Could not parse error response JSON: $e");
        }

        debugPrint("Error Message to User: $errorMessage");

        Get.snackbar(
          "Error".tr,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } on SocketException catch (e, stackTrace) {
      debugPrint("❌ [SocketException]: $e");
      debugPrint("StackTrace: $stackTrace");
      Get.snackbar(
        "Connection Error".tr,
        "Server connection was interrupted. Please check your network or upload smaller image files."
            .tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } on TimeoutException catch (e, stackTrace) {
      debugPrint("❌ [TimeoutException]: $e");
      debugPrint("StackTrace: $stackTrace");
      Get.snackbar(
        "Timeout Error".tr,
        "The server took too long to respond. Please check your internet connection and try again."
            .tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e, stackTrace) {
      debugPrint("❌ [Subscription Payment Exception]: $e");
      debugPrint("StackTrace: $stackTrace");

      Get.snackbar(
        "Error".tr,
        "${'An unexpected error occurred'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
      debugPrint(
        "================ [Recruiter Payment Submission Finished] ================\n",
      );
    }
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
}
