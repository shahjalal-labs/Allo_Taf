import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';

class RecruiterEmptyMissionView extends StatelessWidget {
  final VoidCallback onActionTap;

  const RecruiterEmptyMissionView({super.key, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        // Centralized custom circular outline box icon wrapper
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200]!.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mail_outline, size: 36, color: Colors.grey[400]),
        ),
        const SizedBox(height: 20),
        CustomText(
          "You haven't published anything yet.".tr,
          font: AppFont.inter,
          fontSize: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.recruiterMissionPublishedScreen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: CustomText(
              "Publish a mission".tr,
              font: AppFont.inter,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
