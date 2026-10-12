import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/global/custom_text.dart';

class BoostPackTile extends StatelessWidget {
  final String title;
  final String description;
  final String priceLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const BoostPackTile({
    super.key,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBEA) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFF3C444) : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_outlined,
                        size: 16.sp,
                        color: isSelected
                            ? const Color(0xFFB06000)
                            : Colors.grey,
                      ),
                      SizedBox(width: 6.w),
                      CustomText(
                        title,
                        font: AppFont.inter,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    description,
                    font: AppFont.inter,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            CustomText(
              priceLabel,
              font: AppFont.inter,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: priceLabel.contains("Free")
                  ? Colors.grey[600]
                  : AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
