import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:allo_taf/core/global/app_item_list.dart';
import '../../../../../../core/global/custom_text.dart';
import '../../../../../../core/global/cutom_text_from_field.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/icon_path/icon_path.dart';
import '../../../controller/recruiter_job_details_controller.dart';

class EditVisibilitySection extends StatelessWidget {
  const EditVisibilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecruiterJobDetailsController>();

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

        // Start & End Date Pickers
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
            items: AppItemsList.cities,
            onChanged: (val) {
              if (val != null) {
                controller.selectedCity.value = val;
              }
            },
          );
        }),
        SizedBox(height: 12.h),

        // Location & Duration Selectors
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
                final durationItems = [
                  "1 hrs/day".tr,
                  "2 hrs/day".tr,
                  "4 hrs/day".tr,
                  "6 hrs/day".tr,
                  "8 hrs/day".tr,
                  "Full-time".tr,
                ];

                final currentVal = controller.selectedDuration.value;
                // Ensures numeric values like "8" get matched or mapped properly
                final effectiveValue = durationItems.contains(currentVal)
                    ? currentVal
                    : (durationItems.firstWhereOrNull(
                            (item) => item.contains(currentVal),
                          ) ??
                          durationItems.first);

                return _buildDropdownSelection(
                  hintText: "Duration".tr,
                  selectedValue: effectiveValue,
                  items: durationItems,
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

        // Name & Contact Inputs
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
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              height: 18.h,
              width: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}
