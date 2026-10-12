import 'dart:developer';

import 'package:get/get.dart';
import '../../../../core/service/app_urls.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/network_caller.dart';
import '../model/employee_job_posts_model.dart';

class EmployeeHomeController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // Observable States
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<EmployeeJobPostsModel> jobPostsModel = Rxn<EmployeeJobPostsModel>();
  final RxList<JobPostData> jobPostsList = <JobPostData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobPosts();
  }

  /// Fetch job posts from the API
  Future<void> fetchJobPosts({int limit = 10, String? urgencyLevel}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Pass AuthService.city and AuthService.neighborhood directly.
      // If null, fallback to an empty list [].
      final String url = AppUrls.getJobPosts(
        limit: limit,
        urgencyLevel: urgencyLevel,
        city: AuthService.city ?? [],
        neighborhood: AuthService.neighborhood ?? [],
      );
      log("URL : $url");

      final response = await _networkCaller.getRequest(
        url,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedModel = EmployeeJobPostsModel.fromJson(
          response.responseData,
        );

        jobPostsModel.value = parsedModel;

        if (parsedModel.result?.data != null) {
          jobPostsList.assignAll(parsedModel.result!.data!);
        } else {
          jobPostsList.clear();
        }
      } else {
        errorMessage.value = response.errorMessage;
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
