// lib/features/employee/employee_missions/presentation/widgets/select_profession_helper.dart
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectProfessionHelper extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectProfessionHelper({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
        margin: EdgeInsets.only(right: 5.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.redColor.withValues(alpha: 0.1)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            // Border color changes to Red when selected
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Center(
          child: CustomText(
            text.tr,
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
