import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import '../widget/selection_selector_field.dart';

class RecruiterSignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RecruiterSignupScreen({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBackButton(),
                SizedBox(height: 10.h),

                // Logo Header
                Center(
                  child: Image.asset(
                    IconPath.splashLogo,
                    width: 90.w,
                    height: 90.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 90.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          IconPath.gallery,
                          colorFilter: const ColorFilter.mode(
                            AppColors.whiteColor,
                            BlendMode.srcIn,
                          ),
                          height: 30.h,
                          width: 30.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                Center(
                  child: CustomText(
                    "Profile Setup".tr,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 20.h),

                // Profile Image Upload Picker Widget
                Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceBottomSheet(context),
                    child: Stack(
                      children: [
                        Obx(() {
                          final imagePath =
                              _authController.profileImagePath.value;
                          return Container(
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFDF8F5),
                              border: Border.all(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                                width: 2.r,
                              ),
                              image: imagePath.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(File(imagePath)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imagePath.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 50.r,
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  )
                                : null,
                          );
                        }),
                        Positioned(
                          bottom: 2.r,
                          right: 2.r,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 16.r,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Business Name Field
                _buildFieldLabel("Business Name".tr),
                SizedBox(height: 6.h),
                CustomTextField(
                  hintText: "Enter Business Name".tr,
                  controller: _authController.businessNameController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? "Business name required".tr
                      : null,
                ),
                SizedBox(height: 16.h),

                // Contact Person Field
                _buildFieldLabel("Contact person".tr),
                SizedBox(height: 6.h),
                CustomTextField(
                  hintText: "Contact person".tr,
                  controller: _authController.contactPersonController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? "Contact person required".tr
                      : null,
                ),
                SizedBox(height: 16.h),

                // Phone Number Field
                _buildFieldLabel("Phone Number".tr),
                SizedBox(height: 6.h),
                CustomTextField(
                  hintText: "Enter phone no.".tr,
                  keyboardType: TextInputType.phone,
                  controller: _authController.recruiterPhoneController,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Required".tr : null,
                ),
                SizedBox(height: 16.h),

                // City & Neighborhood Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("City".tr),
                          SizedBox(height: 6.h),
                          Obx(
                            () => SelectionSelectorField(
                              hintText: "Select City".tr,
                              displayValue:
                                  _authController.selectedCity.value.isEmpty
                                  ? null
                                  : _authController.selectedCity.value,
                              onTap: () => _showSingleSelectPopup(
                                title: "Select City".tr,
                                items: AppItemsList.cities,
                                onSelected: (val) {
                                  _authController.selectedCity.value = val;
                                  _authController.selectedNeighborhood.value =
                                      "";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Neighborhood".tr),
                          SizedBox(height: 6.h),
                          Obx(
                            () => SelectionSelectorField(
                              hintText:
                                  _authController.selectedCity.value.isEmpty
                                  ? "Select city first".tr
                                  : "Select Neighborhood".tr,
                              displayValue:
                                  _authController
                                      .selectedNeighborhood
                                      .value
                                      .isEmpty
                                  ? null
                                  : _authController.selectedNeighborhood.value,
                              onTap: _authController.selectedCity.value.isEmpty
                                  ? null
                                  : () {
                                      _showSingleSelectPopup(
                                        title: "Select Neighborhood".tr,
                                        items: _authController
                                            .filteredNeighborhoods,
                                        onSelected: (val) {
                                          _authController
                                                  .selectedNeighborhood
                                                  .value =
                                              val;
                                        },
                                      );
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Description Field
                _buildFieldLabel("Description(Optional)".tr),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _authController.descriptionController,
                  hintText: "Type something...".tr,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 30.h),

                // Confirm Submit Button
                Obx(() {
                  return CustomButton(
                    borderRadius: 16.r,
                    backgroundColor: AppColors.primaryColor,
                    textStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    text: "Confirm".tr,
                    isLoading: _authController.isLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _authController.registerRecruiter();
                      }
                    },
                  );
                }),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String labelText) {
    return CustomText(
      labelText,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor,
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomImagePickerBottomSheet(
        title: "Upload Profile Image".tr,
        onCameraTap: () => _authController.pickProfileImageFromCamera(),
        onGalleryTap: () => _authController.pickProfileImageFromGallery(),
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
}
