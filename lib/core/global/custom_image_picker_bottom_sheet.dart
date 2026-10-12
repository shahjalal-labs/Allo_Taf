import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/constants/app_colors.dart';
import 'custom_text.dart';

class CustomImagePickerBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback? onCvTap;
  final bool showCvOption;

  const CustomImagePickerBottomSheet({
    super.key,
    required this.title,
    required this.onCameraTap,
    required this.onGalleryTap,
    this.onCvTap,
    this.showCvOption = false,
  });

  static void show({
    required BuildContext context,
    required String title,
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    VoidCallback? onCvTap,
    bool showCvOption = false,
  }) {
    Get.bottomSheet(
      CustomImagePickerBottomSheet(
        title: title,
        onCameraTap: onCameraTap,
        onGalleryTap: onGalleryTap,
        onCvTap: onCvTap,
        showCvOption: showCvOption,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            title,
            font: AppFont.inter,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Camera Option
              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  Get.back();
                  onCameraTap();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(18.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded, // Camera icon
                          color: AppColors.primaryColor,
                          size: 32.r,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        "Camera".tr,
                        font: AppFont.inter,
                        fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
              ),

              // Gallery Option
              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  Get.back();
                  onGalleryTap();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(18.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.photo_library_rounded, // Stacked images icon
                          color: AppColors.primaryColor,
                          size: 32.r,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        "Gallery".tr,
                        font: AppFont.inter,
                        fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
              ),

              // CV / Document Option (Optional)
              if (showCvOption)
                InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    Get.back();
                    onCvTap?.call();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(18.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons
                                .description_rounded, // Document icon from your image
                            color: AppColors.primaryColor,
                            size: 32.r,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          "CV".tr,
                          font: AppFont.inter,
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
