import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/payment_submitted_helper.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PayConfirmScreen extends StatelessWidget {
  PayConfirmScreen({super.key});
  final Map<String, dynamic> data = Get.arguments ?? {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      body: _mainContent(),
    );
  }

  Widget _mainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  IconPath.paySuccess,
                  height: 100.h,
                  width: 100.w,
                ),
              ),
              Gap(10),
              CustomText(
                "Payment submitted!".tr,
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              Gap(10),
              CustomText(
                "Welcome among the founders.".tr,
                color: AppColors.blackColor.withValues(alpha: 0.6),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              PaymentSubmittedHelper(
                plan: data["plan"],

                method: data["method"],

                transactionId: data["transactionId"],

                status: data["status"],
              ),
              Gap(20),
              CustomButton(
                backgroundColor: AppColors.orangeColor.withValues(alpha: 0.8),
                text: "Back to my space".tr,
                textStyle: TextStyle(color: AppColors.redColor),
                onTap: () {
                  Get.offAllNamed(AppRoutes.employeeNav);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
