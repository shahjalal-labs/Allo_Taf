import 'dart:developer';

import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:allo_taf/core/global/custom_dialog.dart';
import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../model/employeor_profile_model.dart';

class RecruiterProfileController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();

  final businessNameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  final recruiterName = "Darlene Robertson".obs;
  final profileImageUrl = "".obs;

  final selectedCity = "Douala".obs;
  final selectedNeighborhood = "Bonapriso".obs;

  // Subscription reactive variables
  final isSubscribed = false.obs;
  final subscriptionExpireAt = Rxn<DateTime>();
  final subscriptionStatus = Rxn<String>();

  final isLoading = false.obs;

  List<String> get cities => AppItemsList.cities;

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
    contactPersonController.text = recruiterName.value;
    ever(selectedCity, (String city) {
      final available = filteredNeighborhoods;
      if (!available.contains(selectedNeighborhood.value)) {
        selectedNeighborhood.value = available.isNotEmpty
            ? available.first
            : "";
      }
    });

    fetchProfileData();
  }

  final profileData = <EmployerProfileData>[].obs;

  /// Fetch Employer Profile using AppUrls.getMe
  Future<void> fetchProfileData() async {
    isLoading.value = true;
    try {
      final response = await networkCaller.getRequest(
        AppUrls.getMe,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final profileModel = EmployerProfileModel.fromJson(
          response.responseData,
        );

        if (profileModel.success && profileModel.result != null) {
          final data = profileModel.result!;
          profileData.assignAll([data]);

          businessNameController.text = data.fullName;
          contactPersonController.text = data.contactPerson;
          phoneNumberController.text = data.phoneNumber;
          descriptionController.text = data.bio;

          recruiterName.value = data.fullName;
          profileImageUrl.value = data.profileImage;

          // Save and set Subscription details
          isSubscribed.value = data.isSubscribed ?? false;
          subscriptionExpireAt.value = data.subscriptionExpireAt;
          subscriptionStatus.value = data.subscriptionStatus;

          await AuthService.saveIsSubscribed(isSubscribed.value);
          await AuthService.saveSubscriptionExpireAt(
            subscriptionExpireAt.value,
          );
          await AuthService.saveSubscriptionStatus(subscriptionStatus.value);

          if (cities.contains(data.city)) {
            selectedCity.value = data.city;
            await AuthService.saveCity([data.city]);
          }
          if (filteredNeighborhoods.contains(data.neighborhood)) {
            selectedNeighborhood.value = data.neighborhood;
            await AuthService.saveNeighborhood([data.neighborhood]);
          } else if (filteredNeighborhoods.isNotEmpty) {
            selectedNeighborhood.value = filteredNeighborhoods.first;
            await AuthService.saveNeighborhood([filteredNeighborhoods.first]);
          }
        }
      } else {
        Get.snackbar(
          "Error".tr,
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to load profile".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToEditProfile() {
    Get.toNamed(AppRoutes.recruiterEditProfileScreen);
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

  Future<void> handleConfirmUpdate() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> updateData = {
        "fullName": businessNameController.text.trim(),
        "contactPerson": contactPersonController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "city": selectedCity.value,
        "neighborhood": selectedNeighborhood.value,
        "bio": descriptionController.text.trim(),
      };

      final response = await networkCaller.patchRequest(
        AppUrls.updateProfile,
        token: AuthService.token,
        body: updateData,
      );

      if (response.isSuccess) {
        recruiterName.value = businessNameController.text.trim();

        // Update persistent AuthService values directly
        await AuthService.saveCity([selectedCity.value]);
        await AuthService.saveNeighborhood([selectedNeighborhood.value]);

        // Refetch fresh profile data from backend
        await fetchProfileData();

        Get.snackbar(
          "Success".tr,
          "Profile updated successfully".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: AppColors.whiteColor,
        );

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
        "${"Failed to update profile".tr}: $e",
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
    businessNameController.dispose();
    contactPersonController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
