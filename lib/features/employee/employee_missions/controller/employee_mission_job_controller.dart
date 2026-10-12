import 'dart:developer';
import 'package:get/get.dart';

import '../../../../core/service/app_urls.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/network_caller.dart';
import '../../employee_home/model/employee_job_posts_model.dart';
import '../data/rmployee_job_post_details_model.dart';

class EmployeeMissionJobController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Job Details State
  final jobDetails = Rxn<JobPostDetails>();

  /// Set or fetch job details
  void setJobData(JobPostData jobData) {
    if (jobData.id != null) {
      fetchJobDetails(jobData.id!);
    }
  }

  /// Fetch full job post details from endpoint
  Future<void> fetchJobDetails(String jobId) async {
    isLoading.value = true;
    try {
      final response = await _networkCaller.getRequest(
        AppUrls.jobPostDetails(jobId),
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final model = EmployeeJobPostDetailsModel.fromJson(
          response.responseData,
        );
        if (model.result != null) {
          jobDetails.value = model.result;
        }
      } else {
        Get.snackbar(
          "Error".tr,
          response.displayMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log("Error fetching job details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Submit Application API Call (Sends an empty body)
  Future<void> uploadAndSubmitApplication(String jobId) async {
    try {
      isSubmitting.value = true;

      final response = await _networkCaller.postRequest(
        AppUrls.applyJob(jobId),
        body: {}, // Empty body
        token: AuthService.token,
      );

      if (response.isSuccess) {
        Get.back(); // Close bottom sheet or modal
        Get.snackbar(
          "Success".tr,
          "Your application has been submitted successfully!".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error".tr,
          response.displayMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log("Error submitting application: $e");
      Get.snackbar(
        "Error".tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
