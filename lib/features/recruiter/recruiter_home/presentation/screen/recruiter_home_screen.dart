import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/service/auth_service.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/icon_path/icon_path.dart';
import '../../../../../routes/app_routes.dart';
import '../../controller/recruiter_home_controller.dart';
import '../widget/recruiter_header.dart';
import '../widget/recruiter_subscription_sheet.dart';
import '../widget/youth_card.dart';

class RecruiterHomeScreen extends StatelessWidget {
  RecruiterHomeScreen({super.key});

  final RecruiterHomeController recruiterHomeController =
      Get.find<RecruiterHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            children: [
              RecruiterHeader(
                subtitle: 'Find the right job at the right time.'.tr,
              ),
              SizedBox(height: 12.h),

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    await recruiterHomeController.fetchYouthsList();
                  },
                  child: SingleChildScrollView(
                    controller: recruiterHomeController.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        CustomText(
                          "Find the right person, today in Douala".tr,
                          font: AppFont.inter,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        SizedBox(height: 8.h),
                        CustomText(
                          "Post your need, find a serious and available youth in a few minutes."
                              .tr,
                          font: AppFont.inter,
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 24.h),

                        // --- Quick Action Row ---
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionButton(
                                title: "Post a mission".tr,
                                iconPath: IconPath.rocket,
                                color: AppColors.primaryColor,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                onTap:
                                    recruiterHomeController.handlePostMission,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildQuickActionButton(
                                title: "View CV library".tr,
                                iconPath: IconPath.squareLibrary,
                                color: AppColors.goldColor,
                                textColor: Colors.black,
                                iconColor: Colors.black,
                                onTap:
                                    recruiterHomeController.handleViewCvLibrary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // --- Section Header ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                "Available now".tr,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                font: AppFont.inter,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: recruiterHomeController.handleSeeAllYouths,
                              child: Row(
                                children: [
                                  CustomText(
                                    "See all".tr,
                                    font: AppFont.inter,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12.r,
                                    color: AppColors.goldColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // 🚀 --- Reactive & Dynamic Youths Profile Cards Grid ---
                        Obx(() {
                          if (recruiterHomeController.isYouthsLoading.value &&
                              recruiterHomeController.youthsList.isEmpty) {
                            return SizedBox(
                              height: 200.h,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            );
                          }

                          if (recruiterHomeController.youthsList.isEmpty) {
                            return SizedBox(
                              height: 200.h,
                              child: Center(
                                child: CustomText(
                                  "No active youths available today.".tr,
                                  font: AppFont.inter,
                                  fontSize: 14.sp,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    recruiterHomeController.youthsList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.68,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                    ),
                                itemBuilder: (context, index) {
                                  final candidate =
                                      recruiterHomeController.youthsList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      final bool isSubscribed =
                                          AuthService.isSubscribed ?? false;

                                      if (isSubscribed) {
                                        Get.toNamed(
                                          AppRoutes
                                              .recruiterEmployeeProfileScreen,
                                          arguments: candidate,
                                        );
                                      } else {
                                        showRecruiterSubscriptionSheet(context);
                                      }
                                    },
                                    child: YouthCard(
                                      candidate: candidate,
                                      onUnlockProfile: () =>
                                          recruiterHomeController
                                              .handleUnlockProfile(
                                                candidate.id,
                                              ),
                                    ),
                                  );
                                },
                              ),
                              if (recruiterHomeController
                                  .isMoreLoading
                                  .value) ...[
                                SizedBox(height: 16.h),
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ],
                          );
                        }),
                        SizedBox(height: 24.h),

                        _buildPeaceOfMindBanner(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required String iconPath,
    required Color color,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(height: 12.h),
            CustomText(
              title,
              font: AppFont.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeaceOfMindBanner() {
    return Container(
      padding: EdgeInsets.all(12.0.r),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF37474F), size: 18.r),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              "\"Verified\" profiles have been checked by the Allô Taf team — peace of mind for hiring."
                  .tr,
              font: AppFont.inter,
              fontSize: 11.sp,
              color: const Color(0xFF37474F),
              height: 1.3.h,
            ),
          ),
        ],
      ),
    );
  }
}
