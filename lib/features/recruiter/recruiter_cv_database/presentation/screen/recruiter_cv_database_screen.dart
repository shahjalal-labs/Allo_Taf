import 'dart:developer';

import 'package:allo_taf/features/recruiter/recruiter_cv_database/presentation/widget/cv_card.dart';
import 'package:allo_taf/features/recruiter/recruiter_profile/controller/recruiter_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/service/auth_service.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../../../recruiter_home/presentation/widget/recruiter_header.dart';
import '../../../recruiter_home/presentation/widget/recruiter_subscription_sheet.dart';
import '../../controller/recruit_cv_controller.dart';
import '../widget/cv_database_filter.dart';
import '../widget/unlock_library_banner.dart';

class RecruiterCvDatabaseScreen extends StatelessWidget {
  RecruiterCvDatabaseScreen({super.key});

  final RecruitCvController recruiterCvController =
      Get.find<RecruitCvController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              RecruiterHeader(
                subtitle: "Find the right job at the right time.".tr,
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    await recruiterCvController.refreshCvProfiles();
                  },
                  child: SingleChildScrollView(
                    controller: recruiterCvController.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),

                        // Title & Icon Row
                        Row(
                          children: [
                            CustomText(
                              "CV Library".tr,
                              font: AppFont.inter,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.assignment_outlined,
                              size: 24.sp,
                              color: Colors.grey[700],
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          "Serious young people available, with CV and verified profile."
                              .tr,
                          font: AppFont.inter,
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                        SizedBox(height: 20.h),

                        // Dynamic Top Banner (Shown if not subscribed or library is locked)
                        Obx(() {
                          final isSubscribed =
                              Get.find<RecruiterProfileController>()
                                  .isSubscribed
                                  .value;
                          log(isSubscribed.toString());
                          return !isSubscribed
                              ? Column(
                                  children: [
                                    UnlockLibraryBanner(),
                                    SizedBox(height: 20.h),
                                  ],
                                )
                              : SizedBox.shrink();
                        }),

                        // Search Bar & No  active Trigger Button (Hidden if not subscribed)
                        Obx(() {
                          final hasActiveFilters =
                              recruiterCvController.selectedSkills.isNotEmpty ||
                              recruiterCvController.selectedCities.isNotEmpty;
                          final bool isSubscribed =
                              AuthService.isSubscribed ?? false;

                          if (!isSubscribed) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        recruiterCvController.fetchCvProfiles(
                                          isRefresh: true,
                                        );
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Search candidates...".tr,
                                        hintStyle: TextStyle(
                                          fontSize: 13.sp,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[400],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: 20.sp,
                                          color: Colors.grey[500],
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),

                                  // Filter Button
                                  InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        CvDatabaseFilter(),
                                        isScrollControlled: true,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Container(
                                      width: 48.w,
                                      height: 48.h,
                                      decoration: BoxDecoration(
                                        color: hasActiveFilters
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        border: Border.all(
                                          color: hasActiveFilters
                                              ? AppColors.primaryColor
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.tune,
                                          size: 22.sp,
                                          color: hasActiveFilters
                                              ? Colors.white
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          );
                        }),

                        // Dynamic CV Cards Grid Layout
                        Obx(() {
                          // Initial Loading State
                          if (recruiterCvController.isLoading.value &&
                              recruiterCvController.cvProfilesList.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 80.h),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            );
                          }

                          // Empty State
                          if (recruiterCvController.cvProfilesList.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: Center(
                                child: CustomText(
                                  "No CV profiles available at the moment.".tr,
                                  font: AppFont.inter,
                                  fontSize: 14,
                                  color: Colors.grey[500],
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
                                    recruiterCvController.cvProfilesList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.68,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                    ),
                                itemBuilder: (context, index) {
                                  final candidate = recruiterCvController
                                      .cvProfilesList[index];
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
                                    child: CvCard(
                                      candidate: candidate,
                                      onUnlockProfile: () {
                                        recruiterCvController
                                            .handleUnlockSingleProfile(
                                              candidate.id,
                                            );
                                      },
                                    ),
                                  );
                                },
                              ),

                              // Bottom Loading Spinner for Pagination
                              if (recruiterCvController.isLoadingMore.value)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                        SizedBox(height: 20.h),
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
}
