import 'package:allo_taf/core/global/app_item_list.dart'; // Import AppItemsList
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/global/custom_text.dart';
import '../../../../../../core/global/cutom_text_from_field.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/icon_path/icon_path.dart';
import '../../../controller/recruiter_mission_published_controller.dart';

class VisibilitySection extends StatelessWidget {
  const VisibilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecruiterMissionPublishedController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Missions Visibility".tr,
          font: AppFont.inter,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.blackColor,
        ),
        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: Obx(() {
                final date = controller.startDate.value;
                return _buildDatePickerButton(
                  context,
                  label: date.isEmpty ? "Start date".tr : date,
                  isFilled: date.isNotEmpty,
                  onTap: () =>
                      controller.chooseDate(context, isStartDate: true),
                );
              }),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(() {
                final date = controller.endDate.value;
                return _buildDatePickerButton(
                  context,
                  label: date.isEmpty ? "End date".tr : date,
                  isFilled: date.isNotEmpty,
                  onTap: () =>
                      controller.chooseDate(context, isStartDate: false),
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // City Selector Dropdown
        Obx(() {
          return _buildDropdownSelection(
            hintText: "Select City".tr,
            selectedValue: controller.selectedCity.value,
            // Use cities from AppItemsList
            items: AppItemsList.cities,
            onChanged: (val) {
              if (val != null) {
                controller.selectedCity.value = val;
                // Location reset is handled in the controller's worker
              }
            },
          );
        }),
        SizedBox(height: 12.h),

        // Sub-location and Duration selectors
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return _buildDropdownSelection(
                  hintText: "Location".tr,
                  selectedValue: controller.selectedLocation.value,
                  items: controller.filteredNeighborhoods,
                  onChanged: (val) =>
                      controller.selectedLocation.value = val ?? "",
                );
              }),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(() {
                return _buildDropdownSelection(
                  hintText: "Duration".tr,
                  selectedValue: controller.selectedDuration.value,
                  items: [
                    "1 hrs/day".tr,
                    "2 hrs/day".tr,
                    "4 hrs/day".tr,
                    '6 hrs/day'.tr,
                    "Full-time".tr,
                  ],
                  onChanged: (val) =>
                      controller.selectedDuration.value = val ?? "1 hrs/day",
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Remuneration Input
        CustomTextField(
          controller: controller.remunerationController,
          hintText: "Remuneration (ex. 10 000 FCFA)".tr,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12.h),

        // Contact info inputs
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller.businessNameController,
                hintText: "Your name / business".tr,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                controller: controller.contactController,
                hintText: "Your number/WhatsApp".tr,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownSelection({
    required String hintText,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final String? effectiveValue = items.contains(selectedValue)
        ? selectedValue
        : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: effectiveValue,
          hint: CustomText(
            hintText,
            font: AppFont.inter,
            fontSize: 13.sp,
            color: Colors.grey[400],
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 18.sp,
            color: AppColors.greyColor,
          ),
          onChanged: onChanged,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(
                value,
                font: AppFont.inter,
                fontSize: 13.sp,
                color: AppColors.blackColor,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton(
    BuildContext context, {
    required String label,
    required bool isFilled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                label,
                font: AppFont.inter,
                fontSize: 13.sp,
                color: isFilled ? Colors.black87 : Colors.grey[400],
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SvgPicture.asset(
              IconPath.calendars,
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              height: 18.h,
              width: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}
