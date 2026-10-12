import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class HowItWorksHelper extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const HowItWorksHelper({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.01),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: _mainContent(imagePath: imagePath, title: title, onTap: onTap),
    );
  }

  Widget _mainContent({
    required String imagePath,
    required String title,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.goldColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(imagePath, height: 14.h, width: 14.w),
          ),
          Gap(10),
          Expanded(
            child: CustomText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
