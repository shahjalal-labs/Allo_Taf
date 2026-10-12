import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/service/app_urls.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/network_caller.dart';
import '../../../../routes/app_routes.dart';
import '../model/recruiter_missions_model.dart';

class RecruiterMissionsController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();

  // Scroll Controller
  final ScrollController scrollController = ScrollController();

  // Data List & General States
  final missionsList = <MissionItem>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final currentPlan = "Free".obs;

  // Locks duplicate execution
  bool _isFetching = false;

  // Pagination Controls
  int currentPage = 1;
  final int limit = 10;
  int totalPages = 1;
  final hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchMissions(isRefresh: true);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreMissions();
    }
  }

  /// Fetches job posts from the backend API.
  Future<void> fetchMissions({bool isRefresh = false}) async {
    // Strict guard to prevent duplicate concurrent network requests
    if (_isFetching) return;

    if (isRefresh) {
      currentPage = 1;
      hasMoreData.value = true;
      if (missionsList.isEmpty) {
        isLoading.value = true;
      }
    } else {
      if (!hasMoreData.value) return;
      isMoreLoading.value = true;
    }

    _isFetching = true;

    try {
      final response = await networkCaller.getRequest(
        AppUrls.getMyMissions(currentPage, limit),
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final recruiterMissionsModel = RecruiterMissionsModel.fromJson(
          response.responseData!,
        );

        final newMissions = recruiterMissionsModel.result?.data ?? [];
        final meta = recruiterMissionsModel.result?.meta;

        if (meta != null) {
          totalPages = meta.totalPages ?? 1;
          hasMoreData.value = currentPage < totalPages;
        } else {
          hasMoreData.value = newMissions.length >= limit;
        }

        if (isRefresh) {
          missionsList.assignAll(newMissions);
        } else {
          // Deduplicate incoming items against existing ones using item IDs
          final existingIds = missionsList.map((e) => e.id).toSet();
          final uniqueNewMissions = newMissions
              .where((item) => !existingIds.contains(item.id))
              .toList();

          missionsList.addAll(uniqueNewMissions);
        }

        if (hasMoreData.value && newMissions.isNotEmpty) {
          currentPage++;
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
        "${"Could not fetch missions".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      _isFetching = false;
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> deleteMission(String? id) async {
    if (id == null || id.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Invalid mission ID".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: AppColors.whiteColor,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await networkCaller.deleteRequest(
        AppUrls.deleteMission(id),
        AuthService.token,
      );

      if (response.isSuccess) {
        missionsList.removeWhere((item) => item.id == id);

        Get.snackbar(
          "Success".tr,
          "Mission deleted successfully".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: AppColors.whiteColor,
        );
      } else {
        Get.snackbar(
          "Error".tr,
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : "Failed to delete mission".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: AppColors.whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${"Failed to delete mission".tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.whiteColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Triggered when the user scrolls near the bottom of the list
  void loadMoreMissions() {
    if (!isLoading.value && !isMoreLoading.value && hasMoreData.value) {
      fetchMissions(isRefresh: false);
    }
  }

  void handlePublishMission() async {
    final result = await Get.toNamed(AppRoutes.recruiterMissionPublishedScreen);
    if (result == true || result == null) {
      fetchMissions(isRefresh: true);
    }
  }

  void handleUpgradeToPro() {
    currentPlan.value = "Pro";
  }
}
