import 'package:allo_taf/core/global/custom_back_button.dart';
import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/features/recruiter/recruiter_mission/presentation/widget/edit_mission/edit_visiblity_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/global/cutom_text_from_field.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/recruiter_job_details_controller.dart';
import '../widget/edit_mission/edit_metier_grid.dart';

class RecruiterMissionEditScreen extends StatelessWidget {
  RecruiterMissionEditScreen({super.key});

  final RecruiterJobDetailsController controller =
      Get.find<RecruiterJobDetailsController>();

  @override
  Widget build(BuildContext context) {
    final String? missionId = Get.arguments as String?;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomBackButton(),
                    CustomText(
                      "Edit Mission".tr,
                      font: AppFont.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                CustomTextField(
                  controller: controller.titleController,
                  hintText: "Title".tr,
                  borderRadius: 15.0,
                ),
                SizedBox(height: 12.h),

                CustomTextField(
                  controller: controller.needController,
                  hintText: "What do you need? (e.g., waitress tonight)".tr,
                  borderRadius: 15.0,
                ),
                SizedBox(height: 20.h),

                const EditMetierGrid(),
                SizedBox(height: 24.h),

                CustomText(
                  "Urgency Level".tr,
                  font: AppFont.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 12.h),
                _buildUrgencySelector(),
                SizedBox(height: 24.h),

                const EditVisibilitySection(),
                SizedBox(height: 28.h),

                CustomButton(
                  text: "Save Changes".tr,
                  onTap: () {
                    if (missionId != null && missionId.isNotEmpty) {
                      controller.handleUpdateMission(missionId);
                    } else {
                      Get.snackbar(
                        "Error".tr,
                        "Mission ID is missing. Cannot update.".tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade400,
                        colorText: AppColors.whiteColor,
                      );
                    }
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUrgencySelector() {
    final levels = [
      {'key': 'STANDARD', 'label': 'Standard'.tr, 'icon': Icons.schedule},
      {'key': 'URGENT', 'label': 'Urgent'.tr, 'icon': Icons.bolt_rounded},
      {
        'key': 'BOOSTED',
        'label': 'Boosted'.tr,
        'icon': Icons.rocket_launch_rounded,
      },
    ];

    return Obx(() {
      final currentSelected = controller.selectedUrgencyLevel.value;

      return Row(
        children: levels.map((level) {
          final isSelected = currentSelected == level['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                controller.selectedUrgencyLevel.value = level['key'] as String;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      level['icon'] as IconData,
                      size: 20.sp,
                      color: isSelected
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      level['label'] as String,
                      font: AppFont.inter,
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
