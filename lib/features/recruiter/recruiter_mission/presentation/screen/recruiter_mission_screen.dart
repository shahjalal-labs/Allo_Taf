import 'package:allo_taf/core/global/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/service/auth_service.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../../../recruiter_home/presentation/widget/recruiter_header.dart';
import '../../controller/recruiter_missions_controller.dart';
import '../widget/mission_card.dart';
import '../widget/premium_plan_card.dart';
import '../widget/recruiter_empty_mission_view.dart';

class RecruiterMissionScreen extends StatelessWidget {
  RecruiterMissionScreen({super.key});

  final RecruiterMissionsController recruiterMissionsController =
      Get.find<RecruiterMissionsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  RecruiterHeader(
                    subtitle: 'Find the right job at the right time.'.tr,
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.whiteColor,
                      onRefresh: () async {
                        await recruiterMissionsController.fetchMissions(
                          isRefresh: true,
                        );
                      },
                      child: SingleChildScrollView(
                        controller:
                            recruiterMissionsController.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),

                            Row(
                              children: [
                                CustomText(
                                  "My missions".tr,
                                  font: AppFont.inter,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackColor,
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 24.r,
                                  color: Colors.grey[700],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // --- Premium Plan Card (Shown only if NOT subscribed) ---
                            Obx(() {
                              final _ =
                                  recruiterMissionsController.isLoading.value;
                              final bool isSubscribed =
                                  AuthService.isSubscribed ?? false;

                              if (isSubscribed) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                children: [
                                  PremiumPlanCard(
                                    planType: recruiterMissionsController
                                        .currentPlan
                                        .value,
                                    onUpgradeTap: recruiterMissionsController
                                        .handleUpgradeToPro,
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              );
                            }),

                            Obx(() {
                              if (recruiterMissionsController.isLoading.value &&
                                  recruiterMissionsController
                                      .missionsList
                                      .isEmpty) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 80.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                );
                              }

                              if (recruiterMissionsController
                                  .missionsList
                                  .isEmpty) {
                                return Center(
                                  child: RecruiterEmptyMissionView(
                                    onActionTap: recruiterMissionsController
                                        .handlePublishMission,
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: recruiterMissionsController
                                        .missionsList
                                        .length,
                                    itemBuilder: (context, index) {
                                      final mission =
                                          recruiterMissionsController
                                              .missionsList[index];
                                      return GestureDetector(
                                        onTap: () => Get.toNamed(
                                          AppRoutes.recruiterJobDetailsScreen,
                                          arguments: mission.id,
                                        ),
                                        child: MissionCard(
                                          mission: mission,
                                          onEdit: () {
                                            Get.toNamed(
                                              AppRoutes.missionEditingScreen,
                                              arguments: mission.id,
                                            );
                                          },
                                          onDelete: () {
                                            Get.dialog(
                                              AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        16.r,
                                                      ),
                                                ),
                                                title: CustomText(
                                                  "Delete Mission".tr,
                                                  font: AppFont.inter,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.blackColor,
                                                ),
                                                content: CustomText(
                                                  "Are you sure you want to delete this mission? This action cannot be undone."
                                                      .tr,
                                                  font: AppFont.inter,
                                                  fontSize: 14.sp,
                                                  color: Colors.grey.shade700,
                                                ),
                                                actionsPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 12.h,
                                                    ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Get.back(),
                                                    child: CustomText(
                                                      "Cancel".tr,
                                                      font: AppFont.inter,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red.shade600,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.r,
                                                            ),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      if (mission.id != null) {
                                                        recruiterMissionsController
                                                            .deleteMission(
                                                              mission.id,
                                                            );
                                                      }
                                                    },
                                                    child: CustomText(
                                                      "Delete".tr,
                                                      font: AppFont.inter,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),

                                  if (recruiterMissionsController
                                      .isMoreLoading
                                      .value)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }),
                            Gap(70.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              if (recruiterMissionsController.missionsList.isEmpty) {
                return const SizedBox.shrink();
              }
              return Positioned(
                bottom: 16.h,
                left: 40.w,
                right: 40.w,
                child: CustomButton(
                  borderRadius: 100.r,
                  text: "Publish a mission".tr,
                  onTap: recruiterMissionsController.handlePublishMission,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
