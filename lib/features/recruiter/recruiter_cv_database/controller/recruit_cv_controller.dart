import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/cv_list_model.dart';

class RecruitCvController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();
  final ScrollController scrollController = ScrollController();

  final cvProfilesList = <CandidateProfile>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLibraryUnlocked = false.obs;

  // Selected Filters
  final selectedSkills = <String>[].obs;
  final selectedCities = <String>[].obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 10;

  bool get hasMoreData => _currentPage <= _totalPages;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    fetchCvProfiles(isRefresh: true);
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchCvProfiles();
      }
    });
  }

  Future<void> fetchCvProfiles({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _totalPages = 1;
      isLoading.value = true;
    } else {
      if (isLoadingMore.value || !hasMoreData) return;
      isLoadingMore.value = true;
    }

    try {
      // Fallback to user profile city/neighborhood if no active filter selected
      final List<String> cityParam = selectedCities.isNotEmpty
          ? selectedCities.toList()
          : (AuthService.city ?? []);
      final List<String> neighborhoodParam = AuthService.neighborhood ?? [];

      final String url = AppUrls.cvList(
        queryParameters: {
          'neighborhood': neighborhoodParam,
          'page': _currentPage,
          'limit': _limit,
          'city': cityParam,
          if (selectedSkills.isNotEmpty) 'skills': selectedSkills.toList(),
        },
      );

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedResponse = CvListResponse.fromJson(response.responseData);

        if (isRefresh) {
          cvProfilesList.assignAll(parsedResponse.result.data);
        } else {
          cvProfilesList.assignAll(parsedResponse.result.data);
        }

        _totalPages = parsedResponse.result.meta.totalPages;
        _currentPage++;
      } else {
        Get.snackbar("Error".tr, response.errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error".tr, "An unexpected error occurred: $e".tr);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
  }

  void toggleCity(String city) {
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
    } else {
      selectedCities.add(city);
    }
  }

  void clearFilters() {
    selectedSkills.clear();
    selectedCities.clear();
    fetchCvProfiles(isRefresh: true);
  }

  void applyFilters() {
    fetchCvProfiles(isRefresh: true);
  }

  Future<void> refreshCvProfiles() async {
    await fetchCvProfiles(isRefresh: true);
  }

  void handleUnlockSingleProfile(String youthId) {
    // Action for single profile unlock
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
