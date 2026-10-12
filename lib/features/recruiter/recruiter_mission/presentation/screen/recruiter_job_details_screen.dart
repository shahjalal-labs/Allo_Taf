import 'package:allo_taf/core/global/cv_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_back_button.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/icon_path/icon_path.dart';
import '../../controller/recruiter_job_details_controller.dart';

class RecruiterJobDetailsScreen extends StatelessWidget {
  RecruiterJobDetailsScreen({super.key});

  final RecruiterJobDetailsController controller =
      Get.find<RecruiterJobDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          final job = controller.job;

          if (controller.isLoading.value || job == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final applicants = controller.applicants;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation header
                Row(
                  children: [
                    const CustomBackButton(),
                    const Spacer(),
                    CustomText(
                      "Job details".tr,
                      font: AppFont.inter,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                    const Spacer(),
                    SizedBox(width: 40.w), // Balance back arrow spacing
                  ],
                ),
                SizedBox(height: 24.h),

                // 1. Title & Urgency Banner Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (job.urgencyLevel!.toUpperCase() == "URGENT") ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            "URGENT".tr,
                            font: AppFont.inter,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                      CustomText(
                        job.title ?? '',
                        font: AppFont.inter,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      if (job.businessName!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        CustomText(
                          job.businessName ?? '',
                          font: AppFont.inter,
                          fontSize: 13,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // 2. Location Indicator Strip
                _buildInfoStrip(
                  icon: Icons.location_on_outlined,
                  iconColor: AppColors.secondaryColor,
                  iconBgColor: const Color(0xFFFFF7EB),
                  text: "${job.neighborhood}, ${job.city}",
                ),
                SizedBox(height: 12.h),

                // 3. Time Details Strip
                _buildInfoStrip(
                  icon: Icons.access_time_outlined,
                  iconColor: AppColors.secondaryColor,
                  iconBgColor: const Color(0xFFFFF7EB),
                  text: "${job.workHours} Hours",
                ),
                SizedBox(height: 12.h),

                // 4. Budget & Payout details
                _buildInfoStrip(
                  icon: Icons.monetization_on_outlined,
                  iconColor: AppColors.secondaryColor,
                  iconBgColor: const Color(0xFFFFF7EB),
                  text: "${job.remuneration} FCFA",
                ),
                SizedBox(height: 24.h),

                // 5. Description Section
                CustomText(
                  "Description".tr,
                  font: AppFont.inter,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  job.description!.isNotEmpty
                      ? job.description ?? ''
                      : "No description provided.".tr,
                  font: AppFont.inter,
                  fontSize: 14,
                  color: Colors.grey[600]!,
                  height: 1.5,
                ),
                SizedBox(height: 24.h),

                // 6. Applicants Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Applicants".tr,
                      font: AppFont.inter,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: CustomText(
                        "${controller.applicantCount}",
                        font: AppFont.inter,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Applicant List
                if (applicants.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: CustomText(
                        "No applicants yet.".tr,
                        font: AppFont.inter,
                        fontSize: 14,
                        color: Colors.grey[500]!,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: applicants.length,
                    itemBuilder: (context, index) {
                      final recentApplicant = applicants[index];
                      final applicant = recentApplicant.applicant;
                      final rating = applicant?.reviewStats?.averageRating!
                          .toDouble();

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            // Profile Image or Initials
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: const Color(0xFFF6E8EB),
                              backgroundImage:
                                  applicant!.profileImage!.isNotEmpty
                                  ? CachedNetworkImageProvider(
                                      applicant.profileImage ?? '',
                                    )
                                  : null,
                              child: applicant.profileImage!.isEmpty
                                  ? CustomText(
                                      _getInitials(applicant.fullName ?? ''),
                                      font: AppFont.inter,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 14.w),

                            // Profile Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    applicant.fullName ?? '',
                                    font: AppFont.inter,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blackColor,
                                  ),
                                  SizedBox(height: 3.h),
                                  CustomText(
                                    applicant.designation!.isNotEmpty
                                        ? applicant.designation!.join(", ")
                                        : "Applicant".tr,
                                    font: AppFont.inter,
                                    fontSize: 12,
                                    color: Colors.grey[500]!,
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      ...List.generate(5, (starIdx) {
                                        return Icon(
                                          Icons.star,
                                          size: 14.sp,
                                          color: starIdx < rating!.floor()
                                              ? AppColors.secondaryColor
                                              : Colors.grey[200],
                                        );
                                      }),
                                      SizedBox(width: 6.w),
                                      CustomText(
                                        rating!.toStringAsFixed(1),
                                        font: AppFont.inter,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // WhatsApp Chat Button
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (applicant.cv != null &&
                                    applicant.cv!.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => CvViewerScreen(
                                          cvUrl: applicant.cv!,
                                          applicantName:
                                              applicant.fullName ?? "Applicant",
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.r),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        size: 22.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),

                                SizedBox(width: 8.w),

                                GestureDetector(
                                  onTap: () => controller.openWhatsAppChat(
                                    applicant.phoneNumber ?? '',
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10.r),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      IconPath.whatsapp,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.greenColor,
                                        BlendMode.srcIn,
                                      ),
                                      width: 20.r,
                                      height: 20.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Helper row builder for detail items
  Widget _buildInfoStrip({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: CustomText(
              text,
              font: AppFont.inter,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "";
    List<String> names = name.trim().split(" ");
    String initials = "";
    int numInitials = names.length > 2 ? 2 : names.length;
    for (var i = 0; i < numInitials; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }
    return initials.toUpperCase();
  }
}
