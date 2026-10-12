import 'package:allo_taf/core/global/custom_button.dart';
import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_home/controller/employee_home_controller.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/buy_plan_bottom_sheet.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/how_it_works_helper.dart';
import 'package:allo_taf/features/employee/employee_missions/presentation/widget/urgent_mission_list_helper.dart';
import 'package:allo_taf/features/employee/employee_nav/employee_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/service/auth_service.dart';
import '../../../../../routes/app_routes.dart';

class EmployeeHomeScreen extends StatelessWidget {
  EmployeeHomeScreen({super.key});

  /// Inject or find EmployeeHomeController
  final EmployeeHomeController controller = Get.find<EmployeeHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchJobPosts();
          },
          child: _mainContent(context),
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    // Check subscription status safely without Obx
    final bool isSubscribed = AuthService.isSubscribed ?? false;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Custom Header replacing AppBar
            Row(
              children: [
                /// App Logo
                Image.asset(
                  IconPath.appLogo,
                  height: 35.h,
                  fit: BoxFit.contain,
                ),
                const Gap(10),

                /// App Title and Slogan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(IconPath.alloText, height: 17.h),
                      CustomText(
                        "Find the right job at the right time.".tr,
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),

                /// Premium Icon — Shown only if the user is NOT subscribed
                if (!isSubscribed) ...[
                  InkWell(
                    onTap: () {
                      BuyPlanBottomSheet(context);
                    },
                    child: SvgPicture.asset(
                      IconPath.premiumIcon,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                  const Gap(15),
                ],

                /// Notification Icon
                InkWell(
                  onTap: () => Get.find<EmployeeNavController>().changeIndex(2),
                  child: SvgPicture.asset(
                    IconPath.bellIcon,
                    height: 20.h,
                    width: 20.w,
                  ),
                ),
              ],
            ),
            const Gap(20),

            /// Heading
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Find your job\n'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                      fontSize: 21.sp,
                    ),
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'today in'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                      fontSize: 21.sp,
                    ),
                  ),
                  TextSpan(
                    text: ' Douala!'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                      fontSize: 21.sp,
                    ),
                  ),
                ],
              ),
            ),

            /// Job subtitle description
            const Gap(8),
            CustomText(
              "Quick assignments, one-off jobs, internships and serious part-time jobs for available young people"
                  .tr,
              color: AppColors.blackColor.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const Gap(18),
            CustomButton(
              borderRadius: 15.r,
              prefixWidget: SvgPicture.asset(
                IconPath.search,
                height: 18.h,
                width: 18.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
              text: "See Available Missions".tr,
              onTap: () => Get.find<EmployeeNavController>().changeIndex(1),
            ),

            /// Urgent mission header
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    "Urgent missions today".tr,
                    maxLines: 5,
                    color: AppColors.blackColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () => Get.find<EmployeeNavController>().changeIndex(1),
                  child: CustomText(
                    "View all".tr,
                    color: AppColors.goldColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Gap(15),

            /// Reactive Urgent mission list from EmployeeHomeController
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.blackColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: const CircularProgressIndicator(),
                );
              }

              if (controller.jobPostsList.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.blackColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: CustomText(
                    "No urgent missions available".tr,
                    color: AppColors.blackColor.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                );
              }

              return Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.01),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: controller.jobPostsList.map((job) {
                    final isLast = job == controller.jobPostsList.last;
                    return Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.employeeJobDetails,
                              arguments: job,
                            );
                          },
                          child: UrgentMissionListHelper(
                            imagePath: IconPath.dish,
                            title: job.title ?? '',
                            description: job.description ?? '',
                            amount: '${job.remuneration ?? 0} FCFA',
                          ),
                        ),

                        /// Show divider after every item except the last one
                        if (!isLast)
                          Divider(
                            color: AppColors.blackColor.withValues(alpha: 0.1),
                            indent: 5.w,
                            endIndent: 5.w,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }),

            /// How it works section
            const Gap(15),
            CustomText(
              "How it works".tr,
              color: AppColors.blackColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            const Gap(15),
            HowItWorksHelper(
              title: 'Create your profile and add your CV'.tr,
              imagePath: IconPath.dish,
            ),
            HowItWorksHelper(
              title: 'Apply now for available positions'.tr,
              imagePath: IconPath.dish,
            ),
            HowItWorksHelper(
              title: 'The employer contacts you via whatsapp'.tr,
              imagePath: IconPath.dish,
            ),
          ],
        ),
      ),
    );
  }
}
