import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_missions/controller/employee_payment_controller.dart';
import 'package:allo_taf/features/employee/employee_missions/data/buy_plan_model.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
void BuyPlanBottomSheet(BuildContext context) {
  final EmployeePaymentController controller = Get.find();
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
          Gap(20),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            "Our packages".tr,
                            fontSize: 14,
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
                  Gap(20),
                  Column(
                    children: controller.plans
                        .map(
                          (plan) => Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: _buildPackageCard(
                              plan: plan,
                              title: plan.title,
                              badge: plan.badge,
                              price: plan.price,
                              currency: plan.currency,
                              features: plan.features,
                              buttonText: plan.isFree
                                  ? "Active plan".tr
                                  : "Choose this plan".tr,
                              isFree: plan.isFree,
                              onTap: () {
                                if (!plan.isFree) {
                                  // Pass the model to the next screen
                                  Get.toNamed(
                                    AppRoutes.employeeBuyPlan,
                                    arguments: plan,
                                  );
                                } else {
                                  Get.back();
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
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

/// Helper
Widget _buildPackageCard({
  required BuyPlanModel plan,
  required String title,
  String? badge,
  required String price,
  required String currency,
  required List<String> features,
  required String buttonText,
  bool isFree = false,
  VoidCallback? onTap,
}) {
  return Container(
    padding: EdgeInsets.all(13.r),
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
            Row(
              children: [
                CustomText(
                  title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                if (badge != null) ...[
                  Gap(10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: CustomText(
                      badge,
                      fontSize: 10,
                      color: AppColors.orangeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),

            /// Done icon shows ONLY in the free plan
            if (isFree)
              Icon(Icons.verified_rounded, color: AppColors.primaryColor),
          ],
        ),
        Gap(10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: price,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              TextSpan(
                text: " $currency",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.blackColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Gap(15),
        ...features.map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.check, size: 18.r, color: AppColors.blackColor),
                Gap(10),
                Expanded(
                  child: CustomText(
                    feature,
                    fontSize: 12,
                    color: AppColors.blackColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(10),
        CustomButton(
          height: 30.h,
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
                  ? AppColors.blackColor.withValues(alpha: 0.5)
                  : AppColors.whiteColor,
              BlendMode.srcIn,
            ),
          ),
          text: buttonText,
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,

            color: isFree
                ? AppColors.blackColor.withValues(alpha: 0.5)
                : AppColors.whiteColor,
          ),

          onTap: () {
            if (!isFree) {
              Get.toNamed(AppRoutes.employeeBuyPlan, arguments: plan);
            } else {
              Get.back();
            }
          },
        ),
      ],
    ),
  );
}
