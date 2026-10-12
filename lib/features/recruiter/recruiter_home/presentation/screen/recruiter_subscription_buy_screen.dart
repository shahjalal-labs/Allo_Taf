import 'dart:io';
import 'package:allo_taf/core/global/custom_back_button.dart';
import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_image_picker_bottom_sheet.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/pay_method_helper.dart';
import 'package:allo_taf/features/recruiter/recruiter_home/controller/recruiter_home_controller.dart';
import 'package:allo_taf/features/employee/employee_missions/data/buy_plan_model.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/recruiter_subscription_controller.dart';

class RecruiterSubscriptionBuyScreen extends StatelessWidget {
  RecruiterSubscriptionBuyScreen({super.key});

  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();
  final RecruiterSubscriptionController subscriptionController =
      Get.find<RecruiterSubscriptionController>();

  final BuyPlanModel selectedPlan =
      Get.arguments ??
      BuyPlanModel(
        title: "Premium Package",
        price: "25,000",
        currency: "FCFA/month",
        features: [],
        isFree: false,
      );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  CustomText(
                    "Payment".tr,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(width: 22.w),
                ],
              ),
            ),

            // Scrollable Content
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
                        _buildPlanSummaryCard(),
                        SizedBox(height: 15.h),

                        CustomText(
                          "Choose your payment method".tr,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        SizedBox(height: 10.h),

                        // Payment Methods Selector Block
                        Obx(
                          () => Column(
                            children: [
                              PayMethodHelper(
                                leadingText: "OM".tr,
                                leadingColor: AppColors.orangeColor,
                                title: "Orange Money".tr,
                                //description: "Payment via #150#".tr,
                                isSelected:
                                    homeController.selectedMethod.value == 0,
                                onTap: () =>
                                    homeController.selectedMethod.value = 0,
                              ),
                              SizedBox(height: 10.h),
                              PayMethodHelper(
                                leadingText: "MM".tr,
                                leadingColor: AppColors.goldColor,
                                title: "MTN Mobile Money".tr,
                                //description: "Paiement via *126#".tr,
                                isSelected:
                                    homeController.selectedMethod.value == 1,
                                onTap: () =>
                                    homeController.selectedMethod.value = 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),

                        // Input Fields & Multi-Image Picker
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                homeController.paymentMethodLabel.tr,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: homeController.phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "+237 6 XX XX XX",
                                  fillColor: AppColors.whiteColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                validator: (val) => val == null || val.isEmpty
                                    ? "Required field".tr
                                    : null,
                              ),
                              SizedBox(height: 15.h),

                              CustomText(
                                "Transaction ID".tr,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller:
                                    homeController.transactionIdController,
                                decoration: InputDecoration(
                                  hintText: "15156416320320",
                                  fillColor: AppColors.whiteColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                validator: (val) => val == null || val.isEmpty
                                    ? "Required field".tr
                                    : null,
                              ),
                              SizedBox(height: 15.h),

                              CustomText(
                                "Proof Image (Max 2)".tr,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 8.h),

                              // Custom Proof Image Uploader UI (Supports Up to 2 Images)
                              _buildImageUploaderSection(context),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),

                        // Submit CTA Action with API Integration & Loading
                        Obx(
                          () => CustomButton(
                            borderRadius: 15.r,
                            text: "Submit".tr,
                            isLoading: subscriptionController.isLoading.value,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (subscriptionController
                                    .selectedImages
                                    .isEmpty) {
                                  Get.snackbar(
                                    "Image required".tr,
                                    "Please upload at least 1 proof image".tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                final String paymentMethod =
                                    homeController.selectedMethod.value == 0
                                    ? "Orange Money"
                                    : "MTN Mobile Money";
                                final String phoneNumber = homeController
                                    .phoneController
                                    .text
                                    .trim();
                                final String transactionId =
                                    homeController
                                        .transactionIdController
                                        .text
                                        .isNotEmpty
                                    ? homeController
                                          .transactionIdController
                                          .text
                                          .trim()
                                    : homeController.generateTransactionId();

                                // Call Controller API to upload proof image(s) and submit payment
                                final bool isSuccess =
                                    await subscriptionController
                                        .onPaymentConfirmed(
                                          paymentMethod: paymentMethod,
                                          phoneNumber: phoneNumber,
                                          transactionId: transactionId,
                                        );

                                if (isSuccess) {
                                  // Navigate to Confirmation screen upon success
                                  Get.toNamed(
                                    AppRoutes.recruiterPaymentConfirmScreen,
                                    arguments: {
                                      "plan": selectedPlan,
                                      "method": paymentMethod,
                                      "phoneNumber": phoneNumber,
                                      "transactionId": transactionId,
                                      "status": "Pending for approval".tr,
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Footer Note
                        Row(
                          children: [
                            Icon(
                              Icons.done,
                              color: AppColors.blackColor.withValues(
                                alpha: 0.6,
                              ),
                              size: 14.r,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: CustomText(
                                "You will confirm the payment on your phone."
                                    .tr,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
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

  /// Helper to render image upload state and previews (Max 2 images)
  Widget _buildImageUploaderSection(BuildContext context) {
    return Obx(() {
      final List<File> images = subscriptionController.selectedImages;

      if (images.isEmpty) {
        return GestureDetector(
          onTap: () {
            CustomImagePickerBottomSheet.show(
              context: context,
              title: "Upload Payment Proof".tr,
              onCameraTap: () =>
                  subscriptionController.pickImage(ImageSource.camera),
              onGalleryTap: () =>
                  subscriptionController.pickImage(ImageSource.gallery),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.image_outlined,
                  color: AppColors.blackColor.withValues(alpha: 0.6),
                  size: 28.r,
                ),
                SizedBox(height: 6.h),
                CustomText(
                  "Upload image (Max 2)".tr,
                  fontSize: 12.sp,
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
                    onCameraTap: () =>
                        subscriptionController.pickImage(ImageSource.camera),
                    onGalleryTap: () =>
                        subscriptionController.pickImage(ImageSource.gallery),
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
                      onTap: () => subscriptionController.removeImageAt(index),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: AppColors.blackColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  /// Helper containing plan information summary
  Widget _buildPlanSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            selectedPlan.title,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          if (selectedPlan.badge != null && selectedPlan.badge!.isNotEmpty) ...[
            SizedBox(height: 2.h),
            CustomText(
              selectedPlan.badge!,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor.withValues(alpha: 0.6),
            ),
          ],
          SizedBox(height: 4.h),
          Divider(color: AppColors.blackColor.withValues(alpha: 0.1)),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Total to pay".tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor.withValues(alpha: 0.6),
              ),
              CustomText(
                "${selectedPlan.price} FCFA",
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
