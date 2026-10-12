import 'package:allo_taf/core/global/app_item_list.dart';
import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_image_picker_bottom_sheet.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/global/cutom_text_from_field.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_profile/presentation/widgets/build_image_helper.dart';
import 'package:allo_taf/features/employee/employee_profile/presentation/widgets/build_upload_cv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../authentication/presentation/widget/selection_selector_field.dart';
import '../../controller/employee_profile_controller.dart';

class EmployeeEditProfile extends StatelessWidget {
  EmployeeEditProfile({super.key});

  final EmployeeProfileController controller =
      Get.find<EmployeeProfileController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _designationsList = AppItemsList.designationsList;
  final List<String> _cities = AppItemsList.cities;

  // ignore: unused_element
  bool _isImage(String path) {
    final mimeType = path.toLowerCase();
    return mimeType.endsWith(".jpg") ||
        mimeType.endsWith(".jpeg") ||
        mimeType.endsWith(".png") ||
        mimeType.endsWith(".webp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: AppColors.blackColor,
                        size: 16.r,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomText(
                    "Edit Profile".tr,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                  const Spacer(),
                  Gap(22.w),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel("Profile Picture".tr),
                        Gap(10.h),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    CustomImagePickerBottomSheet(
                                      onCameraTap: () => controller
                                          .pickProfileImage(ImageSource.camera),
                                      onGalleryTap: () =>
                                          controller.pickProfileImage(
                                            ImageSource.gallery,
                                          ),
                                      title: 'Upload Profile Image'.tr,
                                    ),
                              );
                            },
                            child: buildImageHelper(
                              imagePath: controller.profileImagePath.value,
                              imageUrl: controller.profileImageUrl.value,
                            ),
                          ),
                        ),
                        Gap(12.h),

                        _buildSectionLabel("User Name".tr),
                        Gap(10.h),
                        CustomTextField(
                          borderRadius: 12.r,
                          hintText: "Enter username".tr,
                          controller: controller.userNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Required".tr;
                            }
                            if (value.trim().length < 3) {
                              return "At least 3 characters".tr;
                            }
                            return null;
                          },
                        ),
                        Gap(12.h),

                        _buildSectionLabel("Profession".tr),
                        Gap(10.h),
                        Obx(
                          () => SelectionSelectorField(
                            hintText: "Select Profession".tr,
                            displayValue:
                                controller.selectedDesignation.value.isEmpty
                                ? null
                                : controller.selectedDesignation.value,
                            onTap: () => _showSingleSelectPopup(
                              title: "Profession".tr,
                              items: _designationsList,
                              onSelected: (val) =>
                                  controller.selectedDesignation.value = val,
                            ),
                          ),
                        ),
                        Gap(12.h),

                        _buildSectionLabel("Phone Number".tr),
                        Gap(10.h),
                        CustomTextField(
                          borderRadius: 12.r,
                          hintText: "Enter phone no.".tr,
                          keyboardType: TextInputType.phone,
                          controller: controller.phoneNumberController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Required".tr;
                            }
                            if (!RegExp(r'^[0-9+ ]+$').hasMatch(value.trim())) {
                              return "Only numbers are allowed".tr;
                            }
                            if (value.trim().length < 9) {
                              return "Enter valid phone number".tr;
                            }
                            return null;
                          },
                        ),
                        Gap(12.h),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel("City".tr),
                                  Gap(10.h),
                                  Obx(
                                    () => SelectionSelectorField(
                                      hintText: "Select City".tr,
                                      displayValue:
                                          controller.selectedCity.value.isEmpty
                                          ? null
                                          : controller.selectedCity.value,
                                      onTap: () => _showSingleSelectPopup(
                                        title: "City".tr,
                                        items: _cities,
                                        onSelected: (val) {
                                          controller.selectedCity.value = val;
                                          controller
                                                  .selectedNeighborhood
                                                  .value =
                                              "";
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel("Neighborhood".tr),
                                  Gap(10.h),
                                  Obx(
                                    () => SelectionSelectorField(
                                      hintText:
                                          controller.selectedCity.value.isEmpty
                                          ? "Select city first".tr
                                          : "Select Neighborhood".tr,
                                      displayValue:
                                          controller
                                              .selectedNeighborhood
                                              .value
                                              .isEmpty
                                          ? null
                                          : controller
                                                .selectedNeighborhood
                                                .value,
                                      onTap:
                                          controller.selectedCity.value.isEmpty
                                          ? null
                                          : () => _showSingleSelectPopup(
                                              title: "Neighborhood".tr,
                                              items: controller
                                                  .filteredNeighborhoods,
                                              onSelected: (val) =>
                                                  controller
                                                          .selectedNeighborhood
                                                          .value =
                                                      val,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(12.h),

                        _buildSectionLabel("Skills".tr),
                        Gap(10.h),
                        Obx(
                          () => SelectionSelectorField(
                            hintText: "Select Skills".tr,
                            displayValue: controller.selectedSkills.isEmpty
                                ? null
                                : controller.selectedSkills.join(", "),
                            onTap: () => _showMultiSelectSkillsPopup(
                              title: "Skills".tr,
                              items: AppItemsList.skillsList,
                            ),
                          ),
                        ),
                        Gap(12.h),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "Available from".tr,
                                    color: AppColors.blackColor,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap(10.h),
                                  Obx(
                                    () => _buildDateSelector(
                                      hintText: "Available from".tr,
                                      value: controller.selectedStartDate.value,
                                      onTap: () => controller.selectDate(
                                        context,
                                        controller.selectedStartDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "End date".tr,
                                    color: AppColors.blackColor,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Gap(10.h),
                                  Obx(
                                    () => _buildDateSelector(
                                      hintText: "End date".tr,
                                      value: controller.selectedEndDate.value,
                                      onTap: () => controller.selectDate(
                                        context,
                                        controller.selectedEndDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(12.h),

                        _buildSectionLabel("CV".tr),
                        Gap(10.h),

                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => CustomImagePickerBottomSheet(
                                  onCameraTap: () =>
                                      controller.pickCVFile(ImageSource.camera),
                                  onGalleryTap: () => controller.pickCVFile(
                                    ImageSource.gallery,
                                  ),
                                  onCvTap: controller
                                      .pickCVDocument, // <--- ADDED CV TAP FUNCTIONALITY HERE
                                  showCvOption: true, // <--- ENABLED 3rd BUTTON
                                  title: 'Upload CV'.tr,
                                ),
                              );
                            },
                            child: buildCvHelper(
                              imagePath: controller.cvPath.value,
                              imageUrl: controller.cvUrl.value,
                            ),
                          ),
                        ),
                        Gap(12.h),

                        _buildSectionLabel("Bio / About".tr),
                        Gap(10.h),
                        CustomTextField(
                          maxLines: 4,
                          minLines: 4,
                          borderRadius: 12.r,
                          hintText: "Type something...".tr,
                          controller: controller.descriptionController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Required".tr;
                            }
                            if (value.trim().length < 10) {
                              return "Must be at least 10 characters".tr;
                            }
                            return null;
                          },
                        ),
                        Gap(24.h),

                        Obx(
                          () => CustomButton(
                            borderRadius: 12.r,
                            backgroundColor: AppColors.primaryColor,
                            textStyle: TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                            text: "Confirm".tr,
                            isLoading: controller.isLoading.value,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                controller.handleConfirmUpdate();
                              }
                            },
                          ),
                        ),
                        Gap(40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String hintText,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                value.isEmpty ? hintText : value,
                fontSize: 14.sp,
                color: value.isEmpty ? Colors.grey[500] : AppColors.blackColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(IconPath.calendars, width: 18.w, height: 18.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return CustomText(
      text,
      color: AppColors.blackColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    );
  }

  void _showSingleSelectPopup({
    required String title,
    required List<String> items,
    required Function(String) onSelected,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(title, fontSize: 16.sp, fontWeight: FontWeight.bold),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: CustomText(item.tr, fontSize: 14.sp),
                onTap: () {
                  onSelected(item);
                  Get.back();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMultiSelectSkillsPopup({
    required String title,
    required List<String> items,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(title, fontSize: 16.sp, fontWeight: FontWeight.bold),
        content: SizedBox(
          width: double.maxFinite,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = controller.selectedSkills.contains(
                          item,
                        );
                        return CheckboxListTile(
                          activeColor: AppColors.primaryColor,
                          title: CustomText(item.tr, fontSize: 14.sp),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            if (checked == true) {
                              controller.selectedSkills.add(item);
                            } else {
                              controller.selectedSkills.remove(item);
                            }
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  Gap(12.h),
                  CustomButton(
                    text: "Done".tr,
                    borderRadius: 10.r,
                    backgroundColor: AppColors.primaryColor,
                    onTap: () => Get.back(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
