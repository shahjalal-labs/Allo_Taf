import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayMethodHelper extends StatelessWidget {
  final String title;
  //final String description;
  final String leadingText;
  final Color leadingColor;
  final VoidCallback onTap;
  final bool isSelected;

  const PayMethodHelper({
    super.key,
    required this.title,
    //required this.description,
    required this.leadingText,
    required this.leadingColor,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 7.h),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          // Change border color based on selection
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.blackColor.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Leading Icon Container
            Container(
              padding: EdgeInsets.all(6.r),
              height: 40.r,
              width: 40.r,
              decoration: BoxDecoration(
                color: leadingColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              alignment: Alignment.center,
              child: CustomText(
                leadingText,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.whiteColor,
              ),
            ),
            Gap(15.w),
            Expanded(
              child: CustomText(
                title,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            // Trailing Radio/Done Icon
            // Icon(
            //   isSelected ? Icons.check_circle_outline : Icons.circle_outlined,
            //   color:  AppColors.blackColor.withValues(alpha: 0.5),
            //   size: 20.r,
            // ),
          ],
        ),
      ),
    );
  }
}
