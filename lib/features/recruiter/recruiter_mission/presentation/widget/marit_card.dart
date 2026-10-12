import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/global/custom_text.dart';

class MetierCard extends StatelessWidget {
  final String label;
  final String iconPath; // Switch to IconData if using standard Material icons
  final bool isSelected;
  final VoidCallback onTap;

  const MetierCard({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF801E3D) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Temporary simple representation using plain text emoji/icons for accuracy
            Text(iconPath, style: TextStyle(fontSize: 20.sp)),
            SizedBox(height: 4.h),
            CustomText(
              label,
              font: AppFont.inter,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
