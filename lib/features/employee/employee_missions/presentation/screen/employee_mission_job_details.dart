import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../employee_home/model/employee_job_posts_model.dart';
import '../../controller/employee_mission_job_controller.dart';

class EmployeeMissionJobDetails extends StatelessWidget {
  EmployeeMissionJobDetails({super.key});

  final EmployeeMissionJobController controller = Get.put(
    EmployeeMissionJobController(),
  );

  Future<void> launchWhatsApp(String? whatsAppNum, String jobTitle) async {
    final phone = whatsAppNum?.replaceAll(RegExp(r'\D'), '') ?? "";
    if (phone.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "WhatsApp number not available".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final message = "Hello, I have a question regarding '$jobTitle'.";
    final Uri url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error".tr,
        "Could not open WhatsApp".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Shows confirmation popup informing the user that their profile CV will be used
  void _showApplyConfirmationDialog(BuildContext context, String jobId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: AppColors.whiteColor,
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Logo / Icon
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  IconPath.appLogo,
                  height: 48.h,
                  width: 48.w,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.work_outline_rounded,
                    size: 40.r,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Gap(15.h),
              CustomText(
                "Submit Application".tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              Gap(10.h),
              CustomText(
                "Your CV will be automatically taken from your profile. If you wish to update your CV, please do so from your Edit Profile settings."
                    .tr,
                fontSize: 13.sp,
                textAlign: TextAlign.center,
                color: AppColors.blackColor.withValues(alpha: 0.7),
              ),
              Gap(20.h),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.greyColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: CustomText(
                          "Cancel".tr,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: CustomButton(
                        height: 40.h,
                        borderRadius: 12.r,
                        backgroundColor: AppColors.primaryColor,
                        isLoading: controller
                            .isSubmitting
                            .value, // Handles loading state automatically
                        text: "Confirm".tr,
                        textStyle: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                        onTap: () =>
                            controller.uploadAndSubmitApplication(jobId),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final JobPostData job = Get.arguments;
    controller.setJobData(job);

    final bool isUrgent =
        job.urgencyLevel != null &&
        job.urgencyLevel!.toLowerCase() != 'normal' &&
        job.urgencyLevel!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppColors.blackColor,
            size: 15.r,
          ),
        ),
        centerTitle: true,
        title: CustomText(
          "Job details".tr,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Use fetched job details if available; fall back to passed arguments
          final details = controller.jobDetails.value;
          final title = details?.title ?? job.title ?? "";
          final businessName =
              details?.businessName ?? job.businessName ?? "Direct Recruiter";
          final city = details?.city ?? job.city ?? "";
          final neighborhood = details?.neighborhood ?? job.neighborhood ?? "";
          final remuneration = details?.remuneration ?? job.remuneration;
          final workHours = details?.workHours ?? job.workHours;
          final description =
              details?.description ??
              job.description ??
              "No description provided.";
          final whatsAppNum = details?.whatsApp ?? job.whatsApp;
          final jobId = details?.id ?? job.id ?? "";

          // Format dates if available
          String dateString = "";
          if (details?.visibilityStartDate != null &&
              details?.visibilityEndDate != null) {
            final start = DateFormat(
              'dd MMM',
            ).format(details!.visibilityStartDate!);
            final end = DateFormat('dd MMM').format(details.visibilityEndDate!);
            dateString = "$start - $end";
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isUrgent)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 3.h,
                            ),
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor,
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                            child: CustomText(
                              job.urgencyLevel?.capitalizeFirst ?? "Urgent".tr,
                              color: AppColors.whiteColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        CustomText(
                          title,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                        Gap(15.h),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 17.r,
                              backgroundColor: AppColors.primaryColor
                                  .withValues(alpha: 0.3),
                              child: CustomText(
                                businessName.isNotEmpty
                                    ? businessName[0].toUpperCase()
                                    : "A",
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            Gap(8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  businessName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        color: AppColors.orangeColor,
                                        size: 14.r,
                                      ),
                                    ),
                                    Gap(5.w),
                                    CustomText(
                                      "5.0",
                                      color: AppColors.greyColor,
                                      fontSize: 11,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Gap(15.h),
                  _buildDetailBox(
                    Icons.location_on_outlined,
                    "$city${city.isNotEmpty && neighborhood.isNotEmpty ? ', ' : ''}$neighborhood",
                  ),
                  _buildDetailBox(
                    Icons.calendar_month_outlined,
                    dateString.isNotEmpty
                        ? "$dateString ${workHours != null ? '· $workHours ${"hrs/day".tr}' : ''}"
                        : "${workHours ?? "N/A".tr} ${"hrs/day".tr}",
                  ),
                  _buildDetailBox(
                    Icons.monetization_on_outlined,
                    remuneration != null ? "$remuneration FCFA" : "Negotiable",
                  ),

                  Gap(20.h),
                  CustomText(
                    "Description".tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.blackColor,
                  ),
                  Gap(10.h),
                  CustomText(
                    description,
                    color: AppColors.blackColor.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),

                  Gap(25.h),

                  /// Apply Now Button (Triggers dialog)
                  CustomButton(
                    borderRadius: 15.r,
                    backgroundColor: AppColors.primaryColor,
                    textStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                    text: "Apply now".tr,
                    onTap: () {
                      _showApplyConfirmationDialog(context, jobId);
                    },
                  ),
                  Gap(15.h),

                  /// Ask Question (WhatsApp)
                  CustomButton(
                    borderRadius: 15.r,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.5.r,
                    ),
                    prefixWidget: SvgPicture.asset(
                      IconPath.whatsappGreen,
                      height: 17.h,
                      width: 17.w,
                    ),
                    backgroundColor: AppColors.whiteColor,
                    textStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                    text: "Ask a question".tr,
                    onTap: () async {
                      await launchWhatsApp(whatsAppNum, title);
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDetailBox(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF9E7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.orangeColor, size: 18.r),
          ),
          Gap(15.w),
          Expanded(
            child: CustomText(
              text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
