import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/features/language/controller/language_change_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
void LanguageChange({required BuildContext context}) {
  final LanguageChangeController languageChangeController = Get.find();

  showDialog(
    context: context,
    builder: (context) {
      return Obx(() {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          contentPadding: EdgeInsets.all(20.r),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(15),
              CustomText(
                "Select Language",
                font: AppFont.inter,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
              Gap(25),

              // English Option
              _languageOption(
                label: "English",
                controller: languageChangeController,
              ),

              Gap(12),

              // French Option
              _languageOption(
                label: "French",
                controller: languageChangeController,
              ),

              Gap(24),
              CustomButton(
                backgroundColor: AppColors.primaryColor,
                borderRadius: 15.r,
                textStyle: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                text: "Done", // Added .tr
                onTap: () {
                  languageChangeController.applyLanguage();
                  Get.back();
                },
              ),
            ],
          ),
        );
      });
    },
  );
}

// Helper
Widget _languageOption({
  required String label,
  required LanguageChangeController controller,
}) {
  final bool isSelected = controller.tempLanguage.value == label;

  return GestureDetector(
    onTap: () => controller.selectLanguage(label),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withValues(alpha: .003)
            : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          width: isSelected ? 1.6 : 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.blackColor.withValues(alpha: .3),
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: CustomText(label),
            ),
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor.withValues(alpha: .3)
                    : Colors.grey.shade500,
                width: 1.5,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      key: const ValueKey(true),
                      size: 14.sp,
                      color: AppColors.whiteColor,
                    )
                  : const SizedBox(key: ValueKey(false)),
            ),
          ),
        ],
      ),
    ),
  );
}
