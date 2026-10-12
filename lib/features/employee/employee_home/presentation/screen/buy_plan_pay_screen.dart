import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/pay_details_helper.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/pay_method_helper.dart';
import 'package:allo_taf/features/employee/employee_missions/controller/employee_payment_controller.dart';
import 'package:allo_taf/features/employee/employee_missions/data/buy_plan_model.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BuyPlanPayScreen extends StatelessWidget {
  BuyPlanPayScreen({super.key});
  final EmployeePaymentController employeePaymentController = Get.find();
  final BuyPlanModel selectedPlan = Get.arguments as BuyPlanModel;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 244, 244),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppColors.blackColor,
            size: 15.r,
          ),
        ),
        centerTitle: true,
        title: CustomText(
          "Payment".tr,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
      body: _mainContent(),
    );
  }

  Widget _mainContent() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bestPriority(),
              Gap(10),

              ///  choose payment method
              // CustomText(
              //   "Choose your payment method".tr,
              //   fontSize: 13,
              //   fontWeight: FontWeight.w600,
              //   color: AppColors.blackColor,
              // ),
              Gap(10),
              CustomText(
                "Pay to +237655873688".tr,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
              Gap(10),
              Obx(
                () => Column(
                  children: [
                    PayMethodHelper(
                      leadingText: "OM".tr,
                      leadingColor: AppColors.orangeColor,
                      title: "Orange Money".tr,
                      // description: "",
                      isSelected:
                          employeePaymentController.selectedMethod.value == 0,
                      onTap: () =>
                          employeePaymentController.selectedMethod.value = 0,
                    ),
                    // PayMethodHelper(
                    //   leadingText: "MM".tr,
                    //   leadingColor: AppColors.goldColor,
                    //   title: "MTN Mobile Money".tr,
                    //   description: "Paiement via *126#".tr,
                    //   isSelected:
                    //       employeePaymentController.selectedMethod.value == 1,
                    //   onTap: () =>
                    //       employeePaymentController.selectedMethod.value = 1,
                    // ),
                  ],
                ),
              ),

              /// todo Other details
              PayDetailsHelper(),
              Gap(20),
              Obx(
                () => CustomButton(
                  isLoading: employeePaymentController.isLoading.value,
                  borderRadius: 15.r,
                  text: "Submit".tr,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (employeePaymentController.selectedImages.isEmpty) {
                        Get.snackbar(
                          "Image required".tr,
                          "Please upload at least 1 proof image".tr,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      final String paymentMethod =
                          employeePaymentController.selectedMethod.value == 0
                          ? "Orange Money"
                          : "MTN Mobile Money";
                      final String phoneNumber = employeePaymentController
                          .phoneController
                          .text
                          .trim();
                      final String transactionId =
                          employeePaymentController
                              .transactionIdController
                              .text
                              .isNotEmpty
                          ? employeePaymentController
                                .transactionIdController
                                .text
                                .trim()
                          : employeePaymentController.generateTransactionId();

                      final bool isSuccess = await employeePaymentController
                          .onPaymentConfirmed(
                            paymentMethod: paymentMethod,
                            phoneNumber: phoneNumber,
                            transactionId: transactionId,
                          );

                      if (isSuccess) {
                        Get.toNamed(
                          AppRoutes.employeePlanConfirm,
                          arguments: {
                            "plan": selectedPlan,
                            "method": paymentMethod,
                            "transactionId": transactionId,
                            "status": "Pending for approval".tr,
                          },
                        );
                      }
                    }
                  },
                ),
              ),
              Gap(8),
              Row(
                children: [
                  Icon(
                    Icons.done,
                    color: AppColors.blackColor.withValues(alpha: 0.6),
                    size: 14.r,
                  ),
                  Gap(4),
                  CustomText(
                    "You will confirm the payment on your phone.".tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// BEst priority widget
  Widget _bestPriority() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
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
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          CustomText(
            selectedPlan.badge ?? "",
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.blackColor.withValues(alpha: 0.6),
          ),
          Gap(2),
          Divider(color: AppColors.blackColor.withValues(alpha: 0.1)),
          Gap(2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Total to pay".tr,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor.withValues(alpha: 0.6),
              ),
              CustomText(
                "${selectedPlan.price} FCFA",
                fontSize: 12,
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
