import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import '../../../../routes/app_routes.dart';
import '../../recruiter_cv_database/model/cv_list_model.dart';
import '../../recruiter_nav/recruiter_nav_controller.dart';
import '../presentation/widget/recruiter_subscription_sheet.dart';

class RecruiterHomeController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  final youthsList = <CandidateProfile>[].obs;
  final isYouthsLoading = false.obs;
  final isMoreLoading = false.obs;

  // Pagination Variables
  int currentPage = 1;
  int totalPages = 1;
  bool hasMore = true;
  final int pageLimit = 10;

  // Scroll Controller for Automatic Infinite Scroll
  final ScrollController scrollController = ScrollController();

  final selectedMethod = 0.obs;
  final selectedImage = "".obs;
  final phoneController = TextEditingController();
  final transactionIdController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initScrollListener();
    fetchYouths();
  }

  @override
  void onClose() {
    scrollController.dispose();
    phoneController.dispose();
    transactionIdController.dispose();
    super.onClose();
  }

  /// Attach scroll listener to auto-trigger pagination when scrolling near bottom
  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreYouths();
      }
    });
  }

  String get paymentMethodLabel => selectedMethod.value == 0
      ? "Orange Money Number"
      : "MTN Mobile Money Number";

  String generateTransactionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Alias method for fetchYouths so it matches pull-to-refresh calls
  Future<void> fetchYouthsList() async {
    await fetchYouths();
  }

  /// 🚀 Initial Fetch or Full Refresh (Page 1)
  Future<void> fetchYouths() async {
    try {
      isYouthsLoading.value = true;
      currentPage = 1;
      hasMore = true;

      final List<String> cityParam = AuthService.city ?? [];
      final List<String> neighborhoodParam = AuthService.neighborhood ?? [];

      final String url = AppUrls.cvList(
        queryParameters: {
          'neighborhood': neighborhoodParam,
          'page': currentPage,
          'limit': pageLimit,
          'city': cityParam,
        },
      );

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedResponse = CvListResponse.fromJson(response.responseData);
        youthsList.assignAll(parsedResponse.result.data);

        // Access PageMeta totalPages property correctly
        final meta = parsedResponse.result.meta;
        totalPages = meta.totalPages;
        hasMore = currentPage < totalPages;
      } else {
        Get.snackbar("Error".tr, response.errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error".tr, "An unexpected error occurred: $e".tr);
    } finally {
      isYouthsLoading.value = false;
    }
  }

  /// 🔄 Fetch Next Page (Load More)
  Future<void> loadMoreYouths() async {
    if (isMoreLoading.value || !hasMore || isYouthsLoading.value) return;

    try {
      isMoreLoading.value = true;
      currentPage++;

      final List<String> cityParam = AuthService.city ?? [];
      final List<String> neighborhoodParam = AuthService.neighborhood ?? [];

      final String url = AppUrls.cvList(
        queryParameters: {
          'neighborhood': neighborhoodParam,
          'page': currentPage,
          'limit': pageLimit,
          'city': cityParam,
        },
      );

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedResponse = CvListResponse.fromJson(response.responseData);
        final newItems = parsedResponse.result.data;

        if (newItems.isNotEmpty) {
          youthsList.addAll(newItems);
        }

        final meta = parsedResponse.result.meta;
        totalPages = meta.totalPages;
        hasMore = currentPage < totalPages;
      } else {
        currentPage--; // Revert page index on failure
      }
    } catch (e) {
      currentPage--; // Revert page index on error
    } finally {
      isMoreLoading.value = false;
    }
  }

  void handlePostMission() {
    Get.toNamed(AppRoutes.recruiterMissionPublishedScreen);
  }

  void handleViewCvLibrary() {
    final RecruiterNavController recruiterNavController =
        Get.find<RecruiterNavController>();
    recruiterNavController.changeIndex(3);
  }

  void handleSeeAllYouths() {
    handleViewCvLibrary();
  }

  void handleUnlockProfile(String youthId) {
    final bool isSubscribed = AuthService.isSubscribed ?? false;

    if (!isSubscribed) {
      if (Get.context != null) {
        showRecruiterSubscriptionSheet(Get.context!);
      }
    } else {
      final candidate = youthsList.firstWhereOrNull(
        (item) => item.id == youthId,
      );
      if (candidate != null) {
        Get.toNamed(
          AppRoutes.recruiterEmployeeProfileScreen,
          arguments: candidate,
        );
      }
    }
  }
}
