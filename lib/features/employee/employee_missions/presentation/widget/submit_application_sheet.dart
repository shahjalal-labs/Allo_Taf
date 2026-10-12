import 'dart:io';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class SubmitApplicationSheet extends StatelessWidget {
  final String categoryTitle;
  final String jobTitle;

  final Rxn<File> selectedFile;
  final RxBool isSubmitting;

  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;
  final VoidCallback onSubmit;

  const SubmitApplicationSheet({
    super.key,
    required this.categoryTitle,
    required this.jobTitle,
    required this.selectedFile,
    required this.isSubmitting,
    required this.onPickFile,
    required this.onRemoveFile,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 12.h,
        bottom: 24.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Gap(16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      categoryTitle,
                      font: AppFont.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldColor,
                    ),
                    Gap(4.h),
                    CustomText(
                      jobTitle,
                      font: AppFont.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, color: Colors.grey[600], size: 22.sp),
              ),
            ],
          ),
          Gap(20.h),

          // PDF Picker Layer
          Obx(() {
            final file = selectedFile.value;
            final isSelected = file != null;

            return GestureDetector(
              onTap: isSelected ? null : onPickFile,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[50] : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor.withValues(alpha: 0.3)
                        : Colors.grey[200]!,
                    width: 1.r,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: isSelected ? Colors.redAccent : Colors.grey[400],
                      size: 24.sp,
                    ),
                    Gap(12.w),
                    Expanded(
                      child: CustomText(
                        isSelected
                            ? file.path.split('/').last
                            : "Upload your CV (PDF file type)".tr,
                        font: AppFont.inter,
                        fontSize: 13.sp,
                        color: isSelected ? Colors.black87 : Colors.grey[400],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      GestureDetector(
                        onTap: onRemoveFile,
                        child: SvgPicture.asset(
                          IconPath.delete,
                          colorFilter: ColorFilter.mode(
                            AppColors.redColor,
                            BlendMode.srcIn,
                          ),
                          width: 20.w,
                          height: 20.h,
                        ),
                      )
                    else
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.grey[400],
                        size: 20.sp,
                      ),
                  ],
                ),
              ),
            );
          }),
          Gap(24.h),

          // Submit Button
          Obx(() {
            final bool submitting = isSubmitting.value;
            final bool hasFile = selectedFile.value != null;

            return GestureDetector(
              onTap: (submitting || !hasFile) ? null : onSubmit,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: hasFile
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Center(
                  child: submitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Submit my Application".tr,
                              font: AppFont.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            Gap(8.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
