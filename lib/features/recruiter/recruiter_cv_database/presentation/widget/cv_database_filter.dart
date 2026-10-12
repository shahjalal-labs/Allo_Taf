import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/recruit_cv_controller.dart';

class CvDatabaseFilter extends StatelessWidget {
  CvDatabaseFilter({super.key});

  final RecruitCvController controller = Get.find<RecruitCvController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle Indicator
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Filter CV Database".tr,
                font: AppFont.inter,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              TextButton(
                onPressed: () {
                  controller.clearFilters();
                  Get.back();
                },
                child: CustomText(
                  "Reset".tr,
                  font: AppFont.inter,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const Divider(),
          SizedBox(height: 8.h),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City Section
                  CustomText(
                    "City".tr,
                    font: AppFont.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: AppItemsList.cities.map((city) {
                        final isSelected = controller.selectedCities.contains(
                          city,
                        );
                        return FilterChip(
                          label: Text(
                            city.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => controller.toggleCity(city),
                          selectedColor: AppColors.primaryColor.withValues(
                            alpha: 0.15,
                          ),
                          checkmarkColor: AppColors.primaryColor,
                          backgroundColor: Colors.grey.shade100,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Skills Section
                  CustomText(
                    "Skills".tr,
                    font: AppFont.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: AppItemsList.skillsList.map((skill) {
                        final isSelected = controller.selectedSkills.contains(
                          skill,
                        );
                        return FilterChip(
                          label: Text(
                            skill.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => controller.toggleSkill(skill),
                          selectedColor: AppColors.primaryColor.withValues(
                            alpha: 0.15,
                          ),
                          checkmarkColor: AppColors.primaryColor,
                          backgroundColor: Colors.grey.shade100,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                controller.applyFilters();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: CustomText(
                "Apply Filters".tr,
                font: AppFont.inter,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
