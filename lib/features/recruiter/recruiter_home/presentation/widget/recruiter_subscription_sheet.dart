import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/recruiter/recruiter_home/controller/recruiter_home_controller.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../employee/employee_missions/data/buy_plan_model.dart';

void showRecruiterSubscriptionSheet(BuildContext context) {
  final RecruiterHomeController _ = Get.find<RecruiterHomeController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Top pill handle indicator
          Container(
            height: 3.h,
            width: 35.w,
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Boost your experience".tr,
                            color: AppColors.goldColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            "Our packages".tr,
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.blackColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Free Package Card
                  _buildPackageCard(
                    title: "Free".tr,
                    price: "0",
                    currency: "FCFA",
                    features: [
                      "1 free publication during the launch".tr,
                      "Receiving applications".tr,
                      "Urgent/boosted missions on demand".tr,
                    ],
                    buttonText: "Active plan".tr,
                    isFree: true,
                    onTap: () => Get.back(),
                  ),
                  SizedBox(height: 20.h),

                  // Premium Package Card
                  _buildPackageCard(
                    title: "Premium Package".tr,
                    badge: "The most profitable".tr,
                    price: "25,000",
                    currency: "FCFA/${'month'.tr}",
                    features: [
                      "Unlimited job posting".tr,
                      "Unlock employee profile".tr,
                      "Unlimited access to CV database".tr,
                    ],
                    buttonText: "Choose this plan".tr,
                    isFree: false,
                    onTap: () {
                      Get.back();
                      Get.toNamed(
                        AppRoutes.recruiterSubscriptionBuyScreen,
                        arguments: BuyPlanModel(
                          title: "Premium Package".tr,
                          badge: "The most profitable".tr,
                          price: "25,000",
                          currency: "FCFA/month",
                          features: [
                            "Unlimited job posting".tr,
                            "Unlock employee profile.".tr,
                            "Unlimited access to CV database".tr,
                          ],
                          isFree: false,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Card layout widget helper engine
/// Card layout widget helper engine
Widget _buildPackageCard({
  required String title,
  String? badge,
  required String price,
  required String currency,
  required List<String> features,
  required String buttonText,
  bool isFree = false,
  required VoidCallback
  onTap, // Changed from VoidCallback? to required VoidCallback
}) {
  return Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColors.primaryColor, width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      title,
                      fontSize: 16.sp,
                      maxLines: 5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  if (badge != null) ...[
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: CustomText(
                        badge,
                        fontSize: 10.sp,
                        color: AppColors.orangeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isFree)
              Icon(
                Icons.verified_outlined,
                color: AppColors.primaryColor,
                size: 20.r,
              ),
          ],
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: price,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              TextSpan(
                text: " $currency",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        ...features.map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, size: 18.r, color: AppColors.blackColor),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomText(
                    feature,
                    fontSize: 13.sp,
                    color: AppColors.blackColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          height: 38.h,
          backgroundColor: isFree
              ? AppColors.blackColor.withValues(alpha: 0.05)
              : AppColors.primaryColor,
          borderRadius: 12.r,
          suffixWidget: SvgPicture.asset(
            IconPath.arrowRight,
            height: 14.h,
            width: 14.w,
            colorFilter: ColorFilter.mode(
              isFree
                  ? AppColors.blackColor.withValues(alpha: 0.4)
                  : AppColors.whiteColor,
              BlendMode.srcIn,
            ),
          ),
          text: buttonText,
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isFree
                ? AppColors.blackColor.withValues(alpha: 0.5)
                : AppColors.whiteColor,
          ),
          onTap: onTap, // No more type mismatch error
        ),
      ],
    ),
  );
}
