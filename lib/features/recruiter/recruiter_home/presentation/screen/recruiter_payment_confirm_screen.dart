import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/payment_submitted_helper.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecruiterPaymentConfirmScreen extends StatelessWidget {
  RecruiterPaymentConfirmScreen({super.key});
  final Map<String, dynamic> data = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Container(
                    height: 70.r,
                    width: 70.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: const Color(0xFF2E7D32),
                      size: 35.r,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                CustomText(
                  "Payment submitted!".tr,
                  color: AppColors.blackColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 6.h),

                CustomText(
                  "Welcome among the founders.".tr,
                  color: AppColors.blackColor.withValues(alpha: 0.5),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 24.h),

                // Data Details Overview Helper Layout Block (Renders internal Badge layout)
                PaymentSubmittedHelper(
                  plan: data["plan"],
                  method: data["method"],
                  transactionId: data["transactionId"],
                  status: data["status"],
                ),
                SizedBox(height: 24.h),

                /// Primary Space Redirect Component Trigger CTA
                CustomButton(
                  height: 48.h,
                  backgroundColor: AppColors.goldColor,
                  borderRadius: 15.r,
                  text: "Back to my space".tr,
                  textStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  onTap: () {
                    Get.offAllNamed(AppRoutes.recruiterNav);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
