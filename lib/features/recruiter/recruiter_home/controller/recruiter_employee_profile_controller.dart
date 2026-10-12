import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../recruiter_cv_database/model/cv_list_model.dart';
import '../model/employee_details_model.dart';
import '../model/user_reviews_model.dart';

class RecruiterEmployeeProfileController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  final employeeDetails = Rxn<EmployeeDetailsResult>();
  final reviewsList = <ReviewData>[].obs;

  final isLoading = false.obs;
  final isReviewsLoading = false.obs;
  final isMoreReviewsLoading = false.obs;

  // --- Pagination State ---
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final int pageLimit = 10;

  // --- Leave a Review Form State ---
  final selectedRating = 5.obs;
  final commentController = TextEditingController();
  final isSubmitting = false.obs;

  String? candidateId;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args != null) {
      if (args is String) {
        candidateId = args;
      } else if (args is CandidateProfile) {
        candidateId = args.id;
      } else if (args is Map<String, dynamic> && args.containsKey('id')) {
        candidateId = args['id'];
      }
    }

    if (candidateId != null && candidateId!.isNotEmpty) {
      fetchYouthProfile(candidateId!);
      fetchReviews(page: 1, isRefresh: true);
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  /// 🚀 Fetch Candidate Details via API
  Future<void> fetchYouthProfile([String? id]) async {
    final targetId = id ?? candidateId;
    if (targetId == null || targetId.isEmpty) return;

    try {
      isLoading.value = true;

      final String url = AppUrls.userDetails(targetId, "true");

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedData = EmployeeDetailsModel.fromJson(response.responseData);
        employeeDetails.value = parsedData.result;
      } else {
        Get.snackbar(
          "Error".tr,
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${'Could not load youth profile'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🚀 Fetch Paginated Reviews for Specific User
  Future<void> fetchReviews({int page = 1, bool isRefresh = false}) async {
    if (candidateId == null || candidateId!.isEmpty) return;

    try {
      if (isRefresh) {
        isReviewsLoading.value = true;
        currentPage.value = 1;
      } else {
        isMoreReviewsLoading.value = true;
      }

      final response = await _networkCaller.getRequest(
        AppUrls.reviewsForSpecificUser(candidateId!, page, pageLimit),
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedReviews = UserReviewsModel.fromJson(response.responseData);

        // Update total pages meta
        totalPages.value = parsedReviews.result.meta.totalPages;
        currentPage.value = parsedReviews.result.meta.page;

        if (isRefresh) {
          reviewsList.assignAll(parsedReviews.result.data);
        } else {
          reviewsList.addAll(parsedReviews.result.data);
        }
      } else {
        Get.snackbar(
          "Error".tr,
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${'Failed to fetch reviews'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isReviewsLoading.value = false;
      isMoreReviewsLoading.value = false;
    }
  }

  /// 🔄 Handles loading the next page when viewing all reviews
  void handleViewAllReviews() {
    Get.toNamed(AppRoutes.viewAllReviews, arguments: candidateId);
    if (currentPage.value < totalPages.value && !isMoreReviewsLoading.value) {
      fetchReviews(page: currentPage.value + 1, isRefresh: false);
    } else if (currentPage.value >= totalPages.value) {
      Get.snackbar(
        "Notice".tr,
        "All reviews loaded.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- Submit Review Action ---
  Future<void> submitReview() async {
    if (commentController.text.trim().isEmpty) {
      Get.snackbar(
        "Required".tr,
        "Please write a comment before submitting.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;
      final response = await _networkCaller.postRequest(
        AppUrls.review(),
        token: AuthService.token,
        body: {
          "revieweeId": candidateId,
          "rating": selectedRating.value,
          "comment": commentController.text,
        },
      );
      if (!response.isSuccess) {
        Get.snackbar(
          "Error".tr,
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      Get.back();
      Get.snackbar(
        "Success".tr,
        "Thank you! Your review has been submitted.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (candidateId != null) {
        fetchYouthProfile(candidateId!);
        fetchReviews(page: 1, isRefresh: true);
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${'Failed to submit review'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
