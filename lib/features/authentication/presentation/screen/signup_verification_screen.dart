import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/global/custom_back_button.dart';
import '../../../../core/global/custom_button.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/icon_path/icon_path.dart';
import '../../controller/auth_controller.dart';

class SignupVerificationScreen extends StatelessWidget {
  SignupVerificationScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Shared Pin Theme Base
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.blackColor,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.5.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primaryColor, width: 2.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.5),
          width: 1.5.r,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent, width: 1.5.r),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar Navigation
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0.h),
                child: const Row(children: [CustomBackButton()]),
              ),

              Gap(12.h),

              // App Logo
              Image.asset(
                IconPath.splashLogo,
                width: 110.w,
                height: 110.h,
                fit: BoxFit.contain,
              ),

              Gap(20.h),

              // Screen Title & Subtitle
              CustomText(
                "Verification Code".tr,
                font: AppFont.inter,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),

              Gap(8.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomText(
                  "Enter the 4-digit code sent to your email address".tr,
                  font: AppFont.inter,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  textAlign: TextAlign.center,
                ),
              ),

              Gap(32.h),

              // Pinput Input Field
              Obx(
                () => Pinput(
                  length: 4,
                  controller: controller.otpController,
                  enabled: !controller.isLoading.value,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  errorPinTheme: errorPinTheme,
                  showCursor: true,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onCompleted: (pin) => controller.handleSignupVerifyOtp(),
                ),
              ),

              Gap(32.h),

              // Timer / Resend Status Badge
              Obx(() {
                final bool canResend = controller.canResend.value;
                final double progress = controller.resendSeconds.value / 59;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: canResend
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 16.r,
                                color: AppColors.primaryColor,
                              ),
                              Gap(6.w),
                              CustomText(
                                "You can now resend the code".tr,
                                font: AppFont.inter,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 2.5.r,
                                backgroundColor: Colors.grey[200],
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Gap(10.w),
                            CustomText(
                              "${"Resend code in".tr} ${controller.formattedTimer}",
                              font: AppFont.inter,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ],
                        ),
                );
              }),

              Gap(16.h),

              // Resend Code Action Text
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "Didn't receive the code? ".tr,
                      font: AppFont.inter,
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                    GestureDetector(
                      onTap:
                          (controller.canResend.value &&
                              !controller.isLoading.value)
                          ? controller.handleResendSignupOtpWithTimer
                          : null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: CustomText(
                          "Resend code".tr,
                          font: AppFont.inter,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: controller.canResend.value
                              ? AppColors.primaryColor
                              : Colors.grey[400],
                          decoration: controller.canResend.value
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(32.h),

              // Continue Button
              Obx(
                () => CustomButton(
                  text: "Continue".tr,
                  font: AppFont.inter,
                  backgroundColor: AppColors.primaryColor,
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: 14.0.r,
                  isLoading: controller.isLoading.value,
                  onTap: controller.handleSignupVerifyOtp,
                ),
              ),

              Gap(24.h),

              // Security & Privacy Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16.r,
                    color: Colors.grey[600],
                  ),
                  Gap(6.w),
                  CustomText(
                    "Your data remains private and secure.".tr,
                    font: AppFont.inter,
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),

              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }
}
