import 'package:allo_taf/core/global/custom_back_button.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/recruiter_employee_profile_controller.dart';
import '../widget/review_item_tile.dart';
import '../widget/youth_profile_card.dart';

class RecruiterEmployeeProfileScreen extends StatelessWidget {
  RecruiterEmployeeProfileScreen({super.key});

  final RecruiterEmployeeProfileController recruiterEmployeeProfileController =
      Get.find<RecruiterEmployeeProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          // --- Loading State ---
          if (recruiterEmployeeProfileController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          final employee =
              recruiterEmployeeProfileController.employeeDetails.value;

          // --- Empty State ---
          if (employee == null) {
            return Center(
              child: CustomText(
                "Profile not found.".tr,
                font: AppFont.inter,
                fontSize: 14.sp,
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBackButton(),
                SizedBox(height: 16.h),

                // Dynamic Youth/Candidate Profile Header Card
                YouthProfileCard(employee: employee),
                SizedBox(height: 24.h),

                // --- Reviews Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "${'Reviews'.tr} (${employee.reviewStats.totalReviews})",
                      font: AppFont.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                    if (employee.recentReviews.isNotEmpty)
                      GestureDetector(
                        onTap: recruiterEmployeeProfileController
                            .handleViewAllReviews,
                        child: CustomText(
                          "View All".tr,
                          font: AppFont.inter,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),

                // --- Recent Reviews List ---
                if (employee.recentReviews.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: CustomText(
                      "No reviews yet.".tr,
                      font: AppFont.inter,
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: employee.recentReviews.length,
                    itemBuilder: (context, index) {
                      final review = employee.recentReviews[index];
                      return ReviewItemTile(review: review);
                    },
                  ),

                SizedBox(height: 12.h),

                // --- Add Review Button ---
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.recruiterLeaveAReviewScreen,
                      arguments: employee.id,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: CustomText(
                        "Add Review".tr,
                        font: AppFont.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
