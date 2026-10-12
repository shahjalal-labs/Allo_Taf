import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/global/custom_text.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../controller/recruiter_mission_published_controller.dart';
import 'boost_pack_tile.dart';

class BoostProfileSection extends StatelessWidget {
  const BoostProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecruiterMissionPublishedController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              "Boost your profile".tr,
              font: AppFont.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            GestureDetector(
              onTap: () {
                // Action for viewing all boost packs if needed
              },
              child: CustomText(
                "View all".tr,
                font: AppFont.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.goldColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Obx(() {
          final selectedPack = controller.selectedUrgencyLevel.value;

          return Column(
            children: [
              BoostPackTile(
                title: "Standard".tr,
                description: "Standard publication - Free".tr,
                priceLabel: "Free".tr,
                isSelected: selectedPack == "STANDARD",
                onTap: () => controller.selectedUrgencyLevel.value = "STANDARD",
              ),
              SizedBox(height: 8.h),
              BoostPackTile(
                title: "Urgent".tr,
                description: "Urgent badge, best visibility for 24h".tr,
                priceLabel: "+2,000 FCFA".tr,
                isSelected: selectedPack == "URGENT",
                onTap: () => controller.selectedUrgencyLevel.value = "URGENT",
              ),
              SizedBox(height: 8.h),
              BoostPackTile(
                title: "Boosted".tr,
                description: "At the top of results for 3 days".tr,
                priceLabel: "+3,000 FCFA".tr,
                isSelected: selectedPack == "BOOSTED",
                onTap: () => controller.selectedUrgencyLevel.value = "BOOSTED",
              ),
            ],
          );
        }),
        SizedBox(height: 8.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.bolt, size: 14.sp, color: AppColors.goldColor),
            SizedBox(width: 6.w),
            Expanded(
              child: CustomText(
                "The Pro Pack includes all discount nightlights".tr,
                font: AppFont.inter,
                fontSize: 11.sp,
                color: AppColors.goldColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
