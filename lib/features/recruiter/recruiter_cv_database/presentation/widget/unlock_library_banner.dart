import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../recruiter_home/presentation/widget/recruiter_subscription_sheet.dart';

class UnlockLibraryBanner extends StatelessWidget {
  final VoidCallback? onUnlockTap;

  const UnlockLibraryBanner({super.key, this.onUnlockTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor, // Matching dark red/maroon custom token
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Unlock access to CV Library".tr,
                      font: AppFont.inter,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      "Filter by designation, neighborhood, availability and experience"
                          .tr,
                      font: AppFont.inter,
                      fontSize: 12,
                      color: AppColors.whiteColor.withValues(alpha: 0.7),
                      height: 1.3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              showRecruiterSubscriptionSheet(context);
              if (onUnlockTap != null) {
                onUnlockTap!();
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: CustomText(
                  "Unlock".tr,
                  font: AppFont.inter,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
