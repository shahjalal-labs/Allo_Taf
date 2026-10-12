import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UrgentMissionListHelper extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final String amount;
  const UrgentMissionListHelper({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.onTap,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      dense: true,

      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),

      minVerticalPadding: 0,
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppColors.blackColor.withValues(alpha: 0.04),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          imagePath,
          height: 16.h,
          width: 16.w,
          fit: BoxFit.contain,
        ),
      ),
      title: CustomText(
        title,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.blackColor,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: CustomText(
        description,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor.withValues(alpha: 0.7),
      ),
      trailing: CustomText(
        amount.toString(),
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
      ),
    );
  }
}
