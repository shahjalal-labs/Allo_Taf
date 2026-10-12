import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../employee_home/model/employee_job_posts_model.dart';

class JobGridHelper extends StatelessWidget {
  const JobGridHelper({super.key, required this.job});

  final JobPostData job;

  @override
  Widget build(BuildContext context) {
    Future<void> launchWhatsApp() async {
      final phone = job.whatsApp?.replaceAll(RegExp(r'\D'), '') ?? "";
      if (phone.isEmpty) {
        Get.snackbar(
          "Error".tr,
          "WhatsApp number not available".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final message =
          "Hello, I am interested in '${job.title ?? "this mission"}'";
      final Uri url = Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error".tr,
          "Could not launch WhatsApp".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    // Determine badge display based on urgencyLevel
    final bool isUrgent =
        job.urgencyLevel != null &&
        job.urgencyLevel!.toLowerCase() != 'normal' &&
        job.urgencyLevel!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Urgency / Boosted Badge (Conditional)
          if (isUrgent)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: AppColors.orangeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department_outlined,
                    color: AppColors.orangeColor,
                    size: 12.r,
                  ),
                  const Gap(4),
                  CustomText(
                    job.urgencyLevel?.capitalizeFirst ?? "Urgent",
                    color: AppColors.orangeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),

          /// Title
          CustomText(
            job.title ?? "Untitled Mission",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),

          /// Location & Work Hours
          const Gap(4),
          CustomText(
            "${job.city ?? ''}${job.city != null && job.neighborhood != null ? ', ' : ''}${job.neighborhood ?? ''}${job.workHours != null ? ' . ${job.workHours} hrs' : ''}",
            color: AppColors.greyColor,
            fontSize: 13,
          ),

          /// Info Bar (Business Name & Price)
          const Gap(10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    job.businessName ?? "Direct Recruiter",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                ),
                CustomText(
                  job.remuneration != null ? "${job.remuneration} FCFA" : "N/A",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),

          /// Action Buttons (Apply & WhatsApp)
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: 36.h,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 22.r,
                  text: job.isApplied == true
                      ? "Applied".tr
                      : "Apply now  →".tr,
                  textStyle: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  onTap: () {
                    Get.toNamed(AppRoutes.employeeJobDetails, arguments: job);
                  },
                ),
              ),
              const Gap(10),
              InkWell(
                onTap: launchWhatsApp,
                child: SvgPicture.asset(
                  IconPath.chatsIcon,
                  height: 36.h,
                  width: 36.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
