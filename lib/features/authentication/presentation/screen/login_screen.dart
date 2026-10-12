import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../../../core/global/custom_button.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/cutom_text_from_field.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/icon_path/icon_path.dart';
import '../../../language/controller/language_change_controller.dart';
import '../../../language/presentation/tr_screen/language_change.dart';
import '../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final LanguageChangeController languageChangeController =
        Get.find<LanguageChangeController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 12.h),

                        // Top Header Row with Language Switcher
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              languageChangeController.openDialog();
                              LanguageChange(context: context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1.r,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => CustomText(
                                      languageChangeController
                                          .selectedLanguage
                                          .value,
                                      font: AppFont.inter,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const Gap(6),
                                  Icon(
                                    Icons.translate_rounded,
                                    color: AppColors.primaryColor,
                                    size: 16.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Logo
                        Image.asset(
                          IconPath.splashLogo,
                          width: 120.w,
                          height: 120.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 28.h),

                        // Main Heading Title
                        Center(
                          child: CustomText(
                            "Log In or Sign up".tr,
                            font: AppFont.inter,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 36.h),

                        // Email Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            "E-mail Address".tr,
                            font: AppFont.inter,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: controller.emailController,
                          hintText: "Enter your e-mail address".tr,
                          font: AppFont.inter,
                          keyboardType: TextInputType.emailAddress,
                          fillColor: AppColors.whiteColor,
                          borderRadius: 12.0.r,
                          textStyle: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 15,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email address is required".tr;
                            }
                            if (!GetUtils.isEmail(value.trim())) {
                              return "Please enter a valid email address".tr;
                            }
                            return null;
                          },
                        ),

                        // Dynamically pushes bottom controls when space allows
                        const Spacer(),
                        SizedBox(height: 24.h),

                        // Action Button
                        Obx(
                          () => CustomButton(
                            text: "Continue".tr,
                            font: AppFont.inter,
                            backgroundColor: AppColors.primaryColor,
                            width: double.infinity,
                            borderRadius: 14.0.r,
                            isLoading: controller.isLoading.value,
                            onTap: () => controller.handleContinue(_formKey),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Terms & Conditions
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CustomText(
                              "By continuing, you agree to our ".tr,
                              font: AppFont.inter,
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            GestureDetector(
                              onTap: () {
                                launcher.launchUrl(
                                  Uri.parse(
                                    "https://allo-taf-frontend.vercel.app/terms",
                                  ),
                                );
                              },
                              child: CustomText(
                                "Terms & Condition".tr,
                                font: AppFont.inter,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
