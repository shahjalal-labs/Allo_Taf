import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/global/app_item_list.dart';
import '../../../../core/global/custom_back_button.dart';
import '../../../../core/global/custom_button.dart';
import '../../../../core/global/custom_image_picker_bottom_sheet.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/global/cutom_text_from_field.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/icon_path/icon_path.dart';
import '../../controller/auth_controller.dart';
import '../widget/date_picker_field.dart';
import '../widget/selection_selector_field.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  final List<String> _cities = AppItemsList.cities;

  // Helper to check if the file is an image for display purposes
  bool _isImage(String path) {
    final mimeType = path.toLowerCase();
    return mimeType.endsWith(".jpg") ||
        mimeType.endsWith(".jpeg") ||
        mimeType.endsWith(".png") ||
        mimeType.endsWith(".webp");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [CustomBackButton()],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      Image.asset(
                        IconPath.splashLogo,
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 16.h),

                      CustomText(
                        "Profile Setup".tr,
                        font: AppFont.inter,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 24.h),

                      // 1. Profile Picture Field
                      _buildFieldLabel("Profile Picture".tr),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => CustomImagePickerBottomSheet.show(
                          context: context,
                          title: "Select Profile Picture".tr,
                          onCameraTap: controller.pickProfileImageFromCamera,
                          onGalleryTap: controller.pickProfileImageFromGallery,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Obx(() {
                            return controller.profileImagePath.value.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.gallery,
                                        width: 24.w,
                                        height: 24.h,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      CustomText(
                                        "Upload image".tr,
                                        font: AppFont.inter,
                                        fontSize: 14.sp,
                                        color: Colors.grey[500],
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(11.r),
                                    child: Image.file(
                                      File(controller.profileImagePath.value),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                          }),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 2. User Name Field
                      _buildFieldLabel("User Name".tr),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: controller.nameController,
                        hintText: "Enter User Name".tr,
                        font: AppFont.inter,
                        fillColor: AppColors.whiteColor,
                        borderRadius: 12.0.r,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Name required".tr
                            : null,
                      ),
                      SizedBox(height: 16.h),

                      // 3. Phone Number Field
                      _buildFieldLabel("Phone Number".tr),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: controller.phoneController,
                        hintText: "6XXXXXXXX".tr,
                        font: AppFont.inter,
                        keyboardType: TextInputType.number,
                        fillColor: AppColors.whiteColor,
                        borderRadius: 12.0.r,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Phone number is required".tr;
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(v.trim())) {
                            return "Please enter numbers only".tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 4. City & Neighborhood Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("City".tr),
                                SizedBox(height: 8.h),
                                Obx(
                                  () => SelectionSelectorField(
                                    hintText: "Select City".tr,
                                    displayValue:
                                        controller.selectedCity.value.isEmpty
                                        ? null
                                        : controller.selectedCity.value,
                                    onTap: () => _showSingleSelectPopup(
                                      title: "Select City".tr,
                                      items: _cities,
                                      onSelected: (val) {
                                        controller.selectedCity.value = val;
                                        controller.selectedNeighborhood.value =
                                            "";
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Neighborhood".tr),
                                SizedBox(height: 8.h),
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
                                        : controller.selectedNeighborhood.value,
                                    onTap: controller.selectedCity.value.isEmpty
                                        ? null
                                        : () => _showSingleSelectPopup(
                                            title: "Select Neighborhood".tr,
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
                      SizedBox(height: 16.h),

                      // 5. Skills Section
                      _buildFieldLabel("Skills".tr),
                      SizedBox(height: 8.h),
                      Obx(() {
                        final rawItems = controller.skillsList.isNotEmpty
                            ? controller.skillsList
                            : AppItemsList.skillsList;

                        return SelectionSelectorField(
                          hintText: "Select Skills".tr,
                          displayValue: controller.selectedSkills.isEmpty
                              ? null
                              : controller.selectedSkills.join(', '),
                          onTap: () => _showMultiSelectPopup(
                            title: "Select Skills".tr,
                            items: rawItems,
                            initialSelectedItems: controller.selectedSkills,
                            onConfirmed: (selected) {
                              controller.selectedSkills.assignAll(selected);
                            },
                          ),
                        );
                      }),
                      SizedBox(height: 20.h),

                      // 6. Availability Date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Available from".tr),
                                SizedBox(height: 8.h),
                                Obx(
                                  () => DatePickerField(
                                    context: context,
                                    hintText: "Available from".tr,
                                    displayDate:
                                        controller
                                            .selectedStartDate
                                            .value
                                            .isEmpty
                                        ? null
                                        : controller.selectedStartDate.value,
                                    onTap: () =>
                                        controller.selectStartDate(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // 7. CV Field (Fixed to show like images & attached CV Picker)
                      _buildFieldLabel("CV".tr),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => CustomImagePickerBottomSheet.show(
                          context: context,
                          title: "Select CV".tr,
                          onCameraTap: controller.pickCVImageFromCamera,
                          onGalleryTap: controller.pickCVImageFromGallery,
                          onCvTap: controller
                              .pickCVDocument, // <--- ADDED CV TAP FUNCTIONALITY HERE
                          showCvOption: true,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Obx(() {
                            final cvPath = controller.cvPath.value;
                            if (cvPath.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    IconPath.gallery,
                                    width: 24.w,
                                    height: 24.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomText(
                                    "Upload CV".tr,
                                    fontSize: 14.sp,
                                    color: Colors.grey[500],
                                  ),
                                ],
                              );
                            } else if (_isImage(cvPath)) {
                              // If CV is an image, show it like the Profile Picture
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(11.r),
                                child: Image.file(
                                  File(cvPath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              // If CV is a document (PDF), show file name with icon
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.description,
                                      color: AppColors.primaryColor,
                                      size: 32,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomText(
                                        cvPath.split('/').last,
                                        fontSize: 14.sp,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 8. Description Field
                      _buildFieldLabel("Description(Optional)".tr),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: controller.descriptionController,
                        hintText: "Type something...".tr,
                        font: AppFont.inter,
                        fillColor: Colors.white,
                        borderRadius: 12.0.r,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 32.h),

                      // Confirm Button
                      Obx(() {
                        final loadingState = controller.isLoading.value;
                        return CustomButton(
                          text: "Confirm".tr,
                          font: AppFont.inter,
                          backgroundColor: AppColors.primaryColor,
                          width: double.infinity,
                          height: 54.h,
                          borderRadius: 14.0.r,
                          isLoading: loadingState,
                          onTap: () =>
                              controller.handleConfirmProfile(_formKey),
                        );
                      }),
                      SizedBox(height: 24.h),
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

  Widget _buildFieldLabel(String labelText) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        labelText,
        font: AppFont.inter,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  void _showMultiSelectPopup({
    required String title,
    required List<String> items,
    required List<String> initialSelectedItems,
    required Function(List<String>) onConfirmed,
  }) {
    final selectedItems = <String>[...initialSelectedItems].obs;
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: CustomText(
          title,
          font: AppFont.inter,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            return ListView(
              shrinkWrap: true,
              children: items.map((item) {
                final isChecked = selectedItems.contains(item);
                return CheckboxListTile(
                  title: CustomText(
                    item.tr,
                    font: AppFont.inter,
                    fontSize: 14.sp,
                  ),
                  value: isChecked,
                  activeColor: AppColors.primaryColor,
                  onChanged: (checked) {
                    if (checked == true) {
                      selectedItems.add(item);
                    } else {
                      selectedItems.remove(item);
                    }
                  },
                );
              }).toList(),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CustomText(
              "Cancel".tr,
              font: AppFont.inter,
              color: Colors.grey,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {
              onConfirmed(selectedItems);
              Get.back();
            },
            child: CustomText(
              "Confirm".tr,
              font: AppFont.inter,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
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
        title: CustomText(
          title,
          font: AppFont.inter,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: CustomText(
                  item.tr,
                  font: AppFont.inter,
                  fontSize: 14.sp,
                ),
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
}
