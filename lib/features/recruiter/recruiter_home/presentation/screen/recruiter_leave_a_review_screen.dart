import 'package:allo_taf/core/global/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/recruiter_employee_profile_controller.dart';

class RecruiterLeaveAReviewScreen extends StatelessWidget {
  RecruiterLeaveAReviewScreen({super.key});

  final RecruiterEmployeeProfileController recruiterLeaveAReviewController =
      Get.find<RecruiterEmployeeProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Custom Navigation Bar (No Native AppBar) ---
              Row(
                children: [
                  CustomBackButton(),
                  const Spacer(),
                  CustomText(
                    "Leave Review".tr,
                    font: AppFont.inter,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  const Spacer(),
                  SizedBox(width: 32.w), // Balance visual alignment
                ],
              ),
              SizedBox(height: 32.h),

              // --- Heading & Description ---
              Center(
                child: Column(
                  children: [
                    CustomText(
                      "How was the experience?".tr,
                      font: AppFont.inter,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomText(
                        "share your experience, so next time we can suggest you even better"
                            .tr,
                        font: AppFont.inter,
                        fontSize: 14,
                        color: Colors.grey[500],
                        textAlign: TextAlign.center,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // --- Rating Header ---
              CustomText(
                "Rating".tr,
                font: AppFont.inter,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(height: 16.h),

              // --- Interactive Star Row ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return Obx(() {
                      final isSelected =
                          recruiterLeaveAReviewController
                              .selectedRating
                              .value >=
                          starValue;
                      return GestureDetector(
                        onTap: () {
                          recruiterLeaveAReviewController.selectedRating.value =
                              starValue;
                        },
                        child: Container(
                          width: 52.w,
                          height: 52.h,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors
                                      .primaryColor // Theme color (the deep red)
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.star,
                            size: 24.sp,
                            color: isSelected
                                ? AppColors
                                      .goldColor // Gold star when active
                                : AppColors.goldColor.withValues(
                                    alpha: 0.6,
                                  ), // Light gold when inactive
                          ),
                        ),
                      );
                    });
                  }),
                ),
              ),
              SizedBox(height: 32.h),

              // --- Comment Input Block ---
              CustomText(
                "Write comment".tr,
                font: AppFont.inter,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 12.h),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  controller: recruiterLeaveAReviewController.commentController,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    color: AppColors.blackColor,
                  ),
                  decoration: InputDecoration(
                    hintText: "Please share your experience with us.".tr,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      color: Colors.grey[400],
                    ),
                    contentPadding: EdgeInsets.all(16.w),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // --- Submit Action Button ---
              Obx(() {
                final isSubmitting =
                    recruiterLeaveAReviewController.isSubmitting.value;
                return GestureDetector(
                  onTap: isSubmitting
                      ? null
                      : recruiterLeaveAReviewController.submitReview,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: isSubmitting
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: AppColors.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : CustomText(
                              "Submit".tr,
                              font: AppFont.inter,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
