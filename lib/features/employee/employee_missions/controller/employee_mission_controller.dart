import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/global/app_item_list.dart';
import '../../../../core/service/app_urls.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/network_caller.dart';
import '../../employee_home/model/employee_job_posts_model.dart';

class EmployeeMissionController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final NetworkCaller _networkCaller = NetworkCaller();

  var startDate = "".obs;
  var endDate = "".obs;

  // Set "Any Skill" as the default selected skill
  late final RxString selectedSkill;

  // Loading States
  var isLoading = false.obs;
  var isMoreLoading = false.obs;

  // Pagination Variables
  int currentPage = 1;
  int limit = 10;
  var hasMorePages = true.obs;

  var jobPostsList = <JobPostData>[].obs;

  Timer? _debounce;
  final RxString searchText = "".obs;
  bool _isResetting = false;

  List<String> get skillsList => ["Any Skill", ...AppItemsList.skillsList];

  @override
  void onInit() {
    super.onInit();

    // Initialize default skill to "Any Skill"
    selectedSkill = "Any Skill".obs;

    // Initial fetch
    fetchMissions();

    // Scroll listener for pagination
    scrollController.addListener(_onScroll);

    // Re-fetch from page 1 when skill or dates change
    ever(selectedSkill, (_) => refreshMissions());
    ever(startDate, (_) => refreshMissions());
    ever(endDate, (_) => refreshMissions());

    // Debounce search input to avoid calling API on every keystroke
    searchController.addListener(_onSearchChanged);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoading.value && !isMoreLoading.value && hasMorePages.value) {
        loadMoreMissions();
      }
    }
  }

  void _onSearchChanged() {
    searchText.value = searchController.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      refreshMissions();
    });
  }

  void updateSelectedSkill(String skill) {
    selectedSkill.value = skill;
  }

  // Date picker handler
  Future<void> selectDate(BuildContext context, RxString dateRx) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.redAccent),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dateRx.value = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void clearFilters() {
    _isResetting = true;
    searchController.clear();
    searchText.value = "";
    startDate.value = "";
    endDate.value = "";
    selectedSkill.value = "Any Skill";
    _isResetting = false;
    refreshMissions();
  }

  /// Reset pagination and perform initial fetch
  Future<void> refreshMissions() async {
    if (_isResetting) return;
    currentPage = 1;
    hasMorePages.value = true;
    await fetchMissions();
  }

  /// Initial or Filter-based Data Fetch
  Future<void> fetchMissions() async {
    if (_isResetting) return;
    isLoading.value = true;
    currentPage = 1;

    try {
      final String url = _buildApiUrl(page: currentPage);
      log("--- FETCH MISSIONS REQUEST ---");
      log("URL: $url");

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final model = EmployeeJobPostsModel.fromJson(response.responseData);
        final fetchedData = model.result?.data ?? [];

        jobPostsList.value = fetchedData;

        // Check pagination metadata or item length
        final totalPages = model.result?.meta?.totalPages ?? 1;
        hasMorePages.value =
            currentPage < totalPages && fetchedData.length >= limit;
      } else {
        jobPostsList.clear();
        Get.snackbar(
          "Error".tr,
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log("--- FETCH MISSIONS ERROR ---");
      log("Error: $e");
      jobPostsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch next page of data
  Future<void> loadMoreMissions() async {
    if (isMoreLoading.value || !hasMorePages.value) return;

    isMoreLoading.value = true;
    int nextPage = currentPage + 1;

    try {
      final String url = _buildApiUrl(page: nextPage);
      log("--- LOAD MORE MISSIONS REQUEST ---");
      log("URL: $url");

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final model = EmployeeJobPostsModel.fromJson(response.responseData);
        final fetchedData = model.result?.data ?? [];

        if (fetchedData.isNotEmpty) {
          currentPage = nextPage;
          jobPostsList.addAll(fetchedData);

          final totalPages = model.result?.meta?.totalPages ?? currentPage;
          hasMorePages.value =
              currentPage < totalPages && fetchedData.length >= limit;
        } else {
          hasMorePages.value = false;
        }
      }
    } catch (e) {
      log("--- LOAD MORE ERROR ---");
      log("Error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  /// Helper to generate URL query string

  String _buildApiUrl({required int page}) {
    DateTime? parsedStartDate;
    DateTime? parsedEndDate;

    if (startDate.value.isNotEmpty) {
      try {
        parsedStartDate = DateFormat('dd/MM/yyyy').parse(startDate.value);
      } catch (_) {}
    }

    if (endDate.value.isNotEmpty) {
      try {
        parsedEndDate = DateFormat('dd/MM/yyyy').parse(endDate.value);
      } catch (_) {}
    }

    final List<String>? cityFilter =
        AuthService.city != null && AuthService.city!.isNotEmpty
        ? AuthService.city!
        : null;

    final List<String>? neighborhoodFilter =
        AuthService.neighborhood != null && AuthService.neighborhood!.isNotEmpty
        ? AuthService.neighborhood!
        : null;

    // IMPORTANT:
    // If "Any Skill" is selected, send null.
    // AppUrls.getJobPosts() will then completely omit the skills parameter.
    final List<String>? skillsFilter =
        selectedSkill.value.isEmpty || selectedSkill.value == "Any Skill"
        ? null
        : [selectedSkill.value];

    return AppUrls.getJobPosts(
      searchTerm: searchController.text.trim(),
      skills: skillsFilter,
      city: cityFilter,
      neighborhood: neighborhoodFilter,
      visibilityStartDate: parsedStartDate,
      visibilityEndDate: parsedEndDate,
      page: page,
      limit: limit,
    );
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
