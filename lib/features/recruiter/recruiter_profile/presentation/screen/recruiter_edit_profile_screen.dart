import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_back_button.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/global/cutom_text_from_field.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/recruiter_profile_controller.dart';

class RecruiterEditProfileScreen extends StatelessWidget {
  RecruiterEditProfileScreen({super.key});

  final RecruiterProfileController recruiterProfileController =
      Get.find<RecruiterProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // --- Main Scrollable Form Content ---
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
              child: Column(
                children: [
                  // App Bar / Header Row
                  Row(
                    children: [
                      const CustomBackButton(),
                      const Spacer(),
                      CustomText(
                        "Edit Profile".tr,
                        font: AppFont.inter,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                      const Spacer(),
                      SizedBox(width: 40.w),
                    ],
                  ),

                  // Form Fields
                  Expanded(
                    child: SingleChildScrollView(
                      // Add bottom padding so the submit button doesn't cover content
                      padding: EdgeInsets.only(bottom: 90.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 28.h),

                          // Business Name
                          _buildFieldLabel("Business Name".tr),
                          CustomTextField(
                            hintText: "Enter Business Name".tr,
                            controller: recruiterProfileController
                                .businessNameController,
                            borderRadius: 16.r,
                            fillColor: const Color(0xFFFDF8F5),
                          ),
                          SizedBox(height: 18.h),

                          // Contact Person
                          _buildFieldLabel("Contact person".tr),
                          CustomTextField(
                            hintText: "Contact person".tr,
                            controller: recruiterProfileController
                                .contactPersonController,
                            borderRadius: 16.r,
                            fillColor: const Color(0xFFFDF8F5),
                          ),
                          SizedBox(height: 18.h),

                          // Phone Number
                          _buildFieldLabel("Phone Number".tr),
                          CustomTextField(
                            hintText: "Enter phone no.".tr,
                            controller: recruiterProfileController
                                .phoneNumberController,
                            keyboardType: TextInputType.phone,
                            borderRadius: 16.r,
                            fillColor: const Color(0xFFFDF8F5),
                          ),
                          SizedBox(height: 18.h),

                          // City & Neighborhood Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel("City".tr),
                                    Obx(
                                      () => _buildCustomDropdownField(
                                        value: recruiterProfileController
                                            .selectedCity
                                            .value,
                                        items:
                                            recruiterProfileController.cities,
                                        onChanged: (val) {
                                          if (val != null) {
                                            recruiterProfileController
                                                    .selectedCity
                                                    .value =
                                                val;
                                          }
                                        },
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
                                    Obx(() {
                                      final availableNeighborhoods =
                                          recruiterProfileController
                                              .filteredNeighborhoods;
                                      final currentValue =
                                          availableNeighborhoods.contains(
                                            recruiterProfileController
                                                .selectedNeighborhood
                                                .value,
                                          )
                                          ? recruiterProfileController
                                                .selectedNeighborhood
                                                .value
                                          : (availableNeighborhoods.isNotEmpty
                                                ? availableNeighborhoods.first
                                                : null);

                                      return _buildCustomDropdownField(
                                        value: currentValue,
                                        items: availableNeighborhoods,
                                        onChanged: (val) {
                                          if (val != null) {
                                            recruiterProfileController
                                                    .selectedNeighborhood
                                                    .value =
                                                val;
                                          }
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),

                          // Description
                          _buildFieldLabel("Description".tr),
                          CustomTextField(
                            hintText: "Type something...".tr,
                            controller: recruiterProfileController
                                .descriptionController,
                            maxLines: 4,
                            borderRadius: 16.r,
                            fillColor: const Color(0xFFFDF8F5),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Floating Confirm Button ---
            Positioned(
              bottom: 16.h,
              left: 20.w,
              right: 20.w,
              child: Obx(
                () => GestureDetector(
                  onTap: recruiterProfileController.isLoading.value
                      ? null
                      : recruiterProfileController.handleConfirmUpdate,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Center(
                      child: recruiterProfileController.isLoading.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : CustomText(
                              "Confirm".tr,
                              font: AppFont.inter,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

  Widget _buildFieldLabel(String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.h, left: 2.w),
      child: CustomText(
        text,
        font: AppFont.inter,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.blackColor,
      ),
    );
  }

  Widget _buildCustomDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final Color defaultBorderColor = AppColors.primaryColor.withValues(
      alpha: 0.15,
    );
    final Color focusBorderColor = AppColors.primaryColor;

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.blackColor,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        fillColor: const Color(0xFFFDF8F5),
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: defaultBorderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: defaultBorderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: focusBorderColor, width: 1.5),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val.tr, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
