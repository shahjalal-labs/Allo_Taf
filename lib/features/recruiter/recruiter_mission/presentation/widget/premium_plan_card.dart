import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/icon_path/icon_path.dart';
import '../../../recruiter_home/presentation/widget/recruiter_subscription_sheet.dart';

class PremiumPlanCard extends StatelessWidget {
  final String planType;
  final VoidCallback? onUpgradeTap;

  const PremiumPlanCard({super.key, required this.planType, this.onUpgradeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7E6),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  IconPath.premiumIcon,
                  width: 22.w,
                  height: 22.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.goldColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Your plan".tr,
                    font: AppFont.inter,
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                  CustomText(
                    planType,
                    font: AppFont.inter,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showRecruiterSubscriptionSheet(context);
              if (onUpgradeTap != null) {
                onUpgradeTap!();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.rocket_launch, color: Colors.white, size: 14.r),
                  SizedBox(width: 6.w),
                  CustomText(
                    "Go Pro".tr,
                    font: AppFont.inter,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
