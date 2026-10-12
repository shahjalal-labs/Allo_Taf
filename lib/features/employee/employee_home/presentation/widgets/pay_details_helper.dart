import 'dart:io';

import 'package:allo_taf/core/global/custom_image_picker_bottom_sheet.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/global/cutom_text_from_field.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_missions/controller/employee_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PayDetailsHelper extends StatelessWidget {
  PayDetailsHelper({super.key});

  final EmployeePaymentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Text based on selectedMethod
          CustomText(
            controller.selectedMethod.value == 0
                ? "Orange Money Number".tr
                : "MTN Mobile Money Number".tr,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          Gap(10),
          CustomTextField(
            controller: controller.phoneController,
            borderRadius: 15.r,
            hintText: "Your number eg. +234343".tr,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Required".tr;
              }
              if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                return "Only numbers allowed".tr;
              }
              if (value.trim().length < 9) {
                return "At least 9 digits".tr;
              }
              return null;
            },
          ),
          Gap(10),
          CustomText(
            "Transaction ID".tr,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          Gap(10),
          CustomTextField(
            controller: controller.transactionIdController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Required".tr;
              }
              if (value.trim().length < 10) {
                return "At least 10 characters".tr;
              }
              return null;
            },
            borderRadius: 15.r,
            hintText: "15156416320320".tr,
          ),
          Gap(10),
          CustomText(
            "Proof Image (Max 2)".tr,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          Gap(10),
          _buildImageUploaderSection(context),
        ],
      ),
    );
  }

  Widget _buildImageUploaderSection(BuildContext context) {
    final List<File> images = controller.selectedImages;

    if (images.isEmpty) {
      return GestureDetector(
        onTap: () {
          CustomImagePickerBottomSheet.show(
            context: context,
            title: "Upload Payment Proof".tr,
            onCameraTap: () => controller.pickImage(ImageSource.camera),
            onGalleryTap: () => controller.pickImage(ImageSource.gallery),
          );
        },
        child: Container(
          width: double.infinity,
          height: 80.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconPath.gallery,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.blackColor.withValues(alpha: 0.9),
                  BlendMode.srcIn,
                ),
              ),
              Gap(6),
              CustomText(
                "Upload image (Max 2)".tr,
                font: AppFont.inter,
                fontSize: 14,
                color: AppColors.blackColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length < 2 ? images.length + 1 : images.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          if (index == images.length && images.length < 2) {
            return GestureDetector(
              onTap: () {
                CustomImagePickerBottomSheet.show(
                  context: context,
                  title: "Upload Payment Proof".tr,
                  onCameraTap: () => controller.pickImage(ImageSource.camera),
                  onGalleryTap: () => controller.pickImage(ImageSource.gallery),
                );
              },
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 24.r,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      "Add More".tr,
                      fontSize: 11.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            );
          }

          final File imageFile = images[index];
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13.r),
                  child: Image.file(
                    imageFile,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: InkWell(
                    onTap: () => controller.removeImageAt(index),
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: AppColors.blackColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 14.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
