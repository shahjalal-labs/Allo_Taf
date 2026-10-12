import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_missions/data/buy_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaymentSubmittedHelper extends StatelessWidget {
  final BuyPlanModel? plan;
  final String? planName;
  final String? amount;
  final String method;
  final String transactionId;
  final String status;

  const PaymentSubmittedHelper({
    super.key,
    this.plan,
    this.planName,
    this.amount,
    required this.method,
    required this.transactionId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve plan name and price cleanly
    final String displayPlanName = plan?.title ?? planName ?? "N/A";
    final String displayAmount = plan != null
        ? "${plan!.price} ${plan!.currency}"
        : amount ?? "N/A";

    return Column(
      children: [
        Gap(20.h),

        // --- Transaction Details Card ---
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.06),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _row(title: "Pack".tr, value: displayPlanName),
              _divider(),
              _row(title: "Amount".tr, value: displayAmount),
              _divider(),
              _row(title: "Method".tr, value: method),
              _divider(),
              _row(title: "Transaction ID".tr, value: transactionId),
              _divider(),
              _row(
                title: "Status".tr,
                value: status,
                valueColor: const Color(0xff1D4D3B),
              ),
            ],
          ),
        ),

        Gap(20.h),

        // --- Unlocked Badge Banner ---
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
            leading: SvgPicture.asset(
              IconPath.unlockBadge,
              height: 33.h,
              width: 33.w,
            ),
            title: CustomText(
              "Badge unlocked".tr,
              color: AppColors.goldColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
            subtitle: CustomText(
              "Founding Partner N° 007 / 050",
              color: AppColors.whiteColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _row({
    required String title,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title,
            color: Colors.grey.shade600,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: CustomText(
              value,
              color: valueColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: AppColors.blackColor.withValues(alpha: 0.1),
    );
  }
}
