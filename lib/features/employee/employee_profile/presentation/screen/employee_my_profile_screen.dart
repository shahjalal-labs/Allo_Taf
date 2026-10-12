import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:allo_taf/core/global/custom_back_button.dart';
import 'package:allo_taf/core/global/custom_image_picker_bottom_sheet.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../authentication/presentation/widget/selection_selector_field.dart';
import '../../controller/employee_profile_controller.dart';

class EmployeeMyProfileScreen extends StatelessWidget {
  EmployeeMyProfileScreen({super.key});

  final EmployeeProfileController controller =
      Get.find<EmployeeProfileController>();

  final List<String> spokenLanguagesList = [
    "English",
    "French",
    "Spanish",
    "German",
    "Arabic",
  ];

  final List<Map<String, String>> skillsList = [
    {"title": "Hostess", "icon": "💁‍♀️"},
    {"title": "Waitress(es)", "icon": "🍽️"},
    {"title": "Vendor(s)", "icon": "🛍️"},
    {"title": "Reception", "icon": "🏨"},
    {"title": "Sales", "icon": "💰"},
    {"title": "Apprentice(s)", "icon": "🔧"},
    {"title": "Babysitter", "icon": "👶"},
    {"title": "Delivery(ies)", "icon": "🏍️"},
    {"title": "Recruit. Desk", "icon": "📋"},
    {"title": "Event-based", "icon": "🎉"},
    {"title": "Salon", "icon": "💇‍♀️"},
    {"title": "Garage", "icon": "🛠️"},
    {"title": "Other".tr, "icon": "📌"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Title Block
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Row(
                children: [
                  CustomBackButton(),
                  SizedBox(width: 8.w),
                  CustomText(
                    "My Profile".tr,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                  Gap(6.w),
                  CustomText("🚀", fontSize: 22.sp),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Info Box (Name + Status Badges)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F4EB),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Obx(
                                () => CustomText(
                                  controller.employeeName.value.isNotEmpty
                                      ? controller.employeeName.value
                                      : (controller.userNameController.text
                                                .trim()
                                                .isNotEmpty
                                            ? controller.userNameController.text
                                            : "Your full name".tr),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                            Gap(12.h),
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 8.h,
                              children: [
                                _buildProfileBadge(
                                  "🛠️ Profile Verified".tr,
                                  const Color(0xFFEAF5F0),
                                  const Color(0xFF2E7D32),
                                ),
                                _buildProfileBadge(
                                  "Available today".tr,
                                  const Color(0xFFFCEAEB),
                                  AppColors.primaryColor,
                                ),
                                _buildProfileBadge(
                                  "🚀 24 hrs active boost".tr,
                                  const Color(0xFFFFF4EB),
                                  AppColors.orangeColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),

                      // 3. Neighborhood Dropdown Section
                      CustomText(
                        "Your neighborhood".tr,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      Gap(8.h),
                      Obx(
                        () => SelectionSelectorField(
                          hintText: controller.selectedCity.value.isEmpty
                              ? "Select City/Neighborhood".tr
                              : "Select Neighborhood".tr,
                          displayValue:
                              controller.selectedNeighborhood.value.isNotEmpty
                              ? "${controller.selectedCity.value.isNotEmpty ? "${controller.selectedCity.value}, " : ""}${controller.selectedNeighborhood.value}"
                              : (controller.selectedCity.value.isNotEmpty
                                    ? controller.selectedCity.value
                                    : null),
                          onTap: () => _showNeighborhoodSelector(context),
                        ),
                      ),
                      Gap(20.h),

                      // 4. Availability Date-picker Block
                      // CustomText("Availability".tr, fontSize: 15.sp, fontWeight: FontWeight.w700),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Available from".tr,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                                Gap(6.h),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () => controller.selectDate(
                                      context,
                                      controller.selectedStartDate,
                                    ),
                                    child: _buildDateSelectorField(
                                      controller.selectedStartDate.value.isEmpty
                                          ? "Available from".tr
                                          : controller.selectedStartDate.value,
                                      hasValue: controller
                                          .selectedStartDate
                                          .value
                                          .isNotEmpty,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "End date".tr,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                                Gap(6.h),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () => controller.selectDate(
                                      context,
                                      controller.selectedEndDate,
                                    ),
                                    child: _buildDateSelectorField(
                                      controller.selectedEndDate.value.isEmpty
                                          ? "End date".tr
                                          : controller.selectedEndDate.value,
                                      hasValue: controller
                                          .selectedEndDate
                                          .value
                                          .isNotEmpty,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(20.h),

                      // 5. Skills Grid View Block
                      CustomText(
                        "Your Skills".tr,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      Gap(10.h),
                      Obx(() {
                        // Accessing length ensures that Obx registers a dependency on selectedSkills RxList
                        // even if itemBuilder is called lazily.
                        final _ = controller.selectedSkills.length;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: skillsList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 8.w,
                                childAspectRatio: 0.88,
                              ),
                          itemBuilder: (context, index) {
                            final skill = skillsList[index];
                            final String title = skill["title"]!;

                            // Reactive check inside Obx
                            final bool isSelected = controller.selectedSkills
                                .contains(title);

                            return GestureDetector(
                              onTap: () => controller.toggleSkill(title),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFF4EB)
                                      : AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.orangeColor
                                        : Colors.transparent,
                                    width: 1.5.r,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(skill["icon"]!, fontSize: 20.sp),
                                    Gap(4.h),
                                    CustomText(
                                      title.tr,
                                      fontSize: 11.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.orangeColor
                                          : AppColors.blackColor,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      Gap(20.h),

                      // 6. CV Management Frame Container
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: const Color(0xFFFFFBEF),
                                  child: Icon(
                                    Icons.description_outlined,
                                    color: AppColors.goldColor,
                                    size: 20.r,
                                  ),
                                ),
                                Gap(12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        final hasCv =
                                            controller
                                                .cvPath
                                                .value
                                                .isNotEmpty ||
                                            controller.cvUrl.value.isNotEmpty;
                                        return CustomText(
                                          hasCv
                                              ? "CV Added".tr
                                              : "No CV Added".tr,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                        );
                                      }),
                                      Gap(2.h),
                                      CustomText(
                                        "Visible to employers who contact you"
                                            .tr,
                                        fontSize: 12.sp,
                                        color: AppColors.blackColor.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(16.h),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      CustomImagePickerBottomSheet(
                                        onCameraTap: () => controller
                                            .pickCVFile(ImageSource.camera),
                                        onGalleryTap: () => controller
                                            .pickCVFile(ImageSource.gallery),
                                        title: 'Upload CV Image'.tr,
                                      ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Center(
                                  child: Obx(() {
                                    final hasCv =
                                        controller.cvPath.value.isNotEmpty ||
                                        controller.cvUrl.value.isNotEmpty;
                                    return CustomText(
                                      hasCv
                                          ? "Replace my CV".tr
                                          : "Upload my CV".tr,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),

                      // 7. Save & Update Button
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : () => controller.handleConfirmUpdate(),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.h,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.whiteColor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : CustomText(
                                      "Save Changes".tr,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Gap(24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBadge(String text, Color bg, Color textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CustomText(
        text,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: textTheme,
      ),
    );
  }

  Widget _buildDateSelectorField(String textHint, {bool hasValue = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              textHint,
              fontSize: 13.sp,
              color: hasValue
                  ? AppColors.blackColor
                  : AppColors.blackColor.withValues(alpha: 0.4),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.blackColor.withValues(alpha: 0.4),
            size: 18.r,
          ),
        ],
      ),
    );
  }

  void _showNeighborhoodSelector(BuildContext context) {
    // If no city selected yet, allow picking a city first
    final bool hasCity = controller.selectedCity.value.isNotEmpty;
    final List<String> listToDisplay = hasCity
        ? (controller.filteredNeighborhoods.isNotEmpty
              ? controller.filteredNeighborhoods
              : AppItemsList.cities)
        : AppItemsList.cities;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(
          hasCity ? "Select Neighborhood".tr : "Select City".tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listToDisplay.length,
            itemBuilder: (context, index) {
              final item = listToDisplay[index];
              return ListTile(
                title: CustomText(item.tr, fontSize: 14.sp),
                onTap: () {
                  if (!hasCity) {
                    controller.selectedCity.value = item;
                  } else {
                    controller.selectedNeighborhood.value = item;
                  }
                  Get.back();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
