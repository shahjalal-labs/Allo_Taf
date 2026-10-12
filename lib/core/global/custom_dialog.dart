import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
void CustomDialog({
  required String imagePath,
  required String title,
  required String content,
  required String cancelText,
  required String onConfirm,
  required VoidCallback onTap,
  required double? imageHeight,
  required double? imageWidth,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Center(
        child: Image.asset(
          imagePath,
          height: imageHeight ?? 70.h,
          width: imageWidth ?? 70.w,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            title,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
          ),
          Gap(10.h),
          CustomText(
            content,
            color: AppColors.blackColor.withValues(alpha: 0.6),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // First Button: Confirmation Action
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color: AppColors.redColor,
                  borderRadius: BorderRadius.circular(35.r),
                ),
                child: CustomText(
                  onConfirm,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            ),

            // Second Button: Default Dismiss Action (Get.back)
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(35.r),
                  border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.5),
                    width: 1.r,
                  ),
                ),
                child: CustomText(
                  cancelText,
                  color: AppColors.blackColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
