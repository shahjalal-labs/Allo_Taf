import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/global/custom_text.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../controller/recruiter_mission_published_controller.dart';

class PublishButton extends StatelessWidget {
  const PublishButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecruiterMissionPublishedController>();

    return Obx(() {
      final submitting = controller.isLoading.value;
      return GestureDetector(
        onTap: submitting ? null : controller.handlePublishMission,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Center(
            child: submitting
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        "Publish Now".tr,
                        font: AppFont.inter,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
