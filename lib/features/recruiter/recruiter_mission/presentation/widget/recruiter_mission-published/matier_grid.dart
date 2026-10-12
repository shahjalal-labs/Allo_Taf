import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/global/custom_text.dart';
import '../../../controller/recruiter_mission_published_controller.dart';
import '../marit_card.dart';

class MetierGrid extends StatelessWidget {
  const MetierGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecruiterMissionPublishedController>();
    final List<Map<String, String>> metiers = [
      {"label": "Hostess".tr, "icon": "👑"},
      {"label": "Waitress(es)".tr, "icon": "🍽️"},
      {"label": "Vendor(s)".tr, "icon": "🛍️"},
      {"label": "Reception".tr, "icon": "🏢"},
      {"label": "Sales".tr, "icon": "💰"},
      {"label": "Apprentice(s)".tr, "icon": "🔧"},
      {"label": "Babysitter".tr, "icon": "👶"},
      {"label": "Delivery(ies)".tr, "icon": "🏍️"},
      {"label": "Recruit. Desk".tr, "icon": "📋"},
      {"label": "Event-based".tr, "icon": "🎉"},
      {"label": "Salon".tr, "icon": "💇"},
      {"label": "Garage".tr, "icon": "🛠️"},
      {"label": "Other".tr, "icon": "📌"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              "Choose métier(s)".tr,
              font: AppFont.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            Obx(() {
              final count = controller.selectedMetiers.length;
              if (count == 0) return const SizedBox.shrink();
              return CustomText(
                "$count ${"selected".tr}",
                font: AppFont.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              );
            }),
          ],
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metiers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final item = metiers[index];
            final label = item["label"]!;

            return Obx(() {
              // Checks whether this item is included in the list of selected items
              final isSelected = controller.selectedMetiers.contains(label);
              return MetierCard(
                label: label,
                iconPath: item["icon"]!,
                isSelected: isSelected,
                onTap: () => controller.toggleMetier(label),
              );
            });
          },
        ),
      ],
    );
  }
}
