import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/widgets/buy_plan_bottom_sheet.dart';
import 'package:allo_taf/features/employee/employee_missions/controller/employee_mission_controller.dart';
import 'package:allo_taf/features/employee/employee_missions/presentation/widget/job_grid_helper.dart';
import 'package:allo_taf/features/employee/employee_missions/presentation/widget/select_profession_helper.dart';
import 'package:allo_taf/features/employee/employee_nav/employee_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EmployeeMissionScreen extends StatelessWidget {
  EmployeeMissionScreen({super.key});
  final EmployeeMissionController missionController =
      Get.find<EmployeeMissionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leadingWidth: 50.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Image.asset(
            IconPath.appLogo,
            fit: BoxFit.contain,
            height: 23.h,
            width: 23.w,
          ),
        ),
        title: Column(
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
        actions: [
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
          const Gap(20),
          InkWell(
            onTap: () => Get.find<EmployeeNavController>().changeIndex(2),
            child: SvgPicture.asset(
              IconPath.bellIcon,
              height: 20.h,
              width: 20.w,
            ),
          ),
          const Gap(20),
        ],
      ),
      body: _mainContent(context),
    );
  }

  Widget _mainContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => missionController.refreshMissions(),
      child: SingleChildScrollView(
        controller: missionController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Missions available in Douala 🎯".tr,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              const Gap(15),

              /// Search Bar
              TextField(
                controller: missionController.searchController,
                decoration: InputDecoration(
                  hintText: "Search a mission...".tr,
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.blackColor.withValues(alpha: 0.4),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Obx(() {
                    bool hasContent =
                        missionController.searchText.value.isNotEmpty ||
                        missionController.startDate.value.isNotEmpty ||
                        missionController.endDate.value.isNotEmpty ||
                        missionController.selectedSkill.value != "Any Skill";

                    return hasContent
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              missionController.clearFilters();
                            },
                          )
                        : const SizedBox.shrink();
                  }),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.blackColor.withValues(alpha: 0.1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.blackColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
              const Gap(15),

              /// Start Date and End Date Row
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: "Start date".tr,
                      dateRx: missionController.startDate,
                      hint: "Start date".tr,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: "End date".tr,
                      dateRx: missionController.endDate,
                      hint: "End date".tr,
                    ),
                  ),
                ],
              ),
              const Gap(15),

              /// Skills Filter Chips
              SizedBox(
                height: 32.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: missionController.skillsList.length,
                  itemBuilder: (context, index) {
                    String skill = missionController.skillsList[index];
                    return Obx(() {
                      bool isSelected =
                          missionController.selectedSkill.value == skill;

                      return SelectProfessionHelper(
                        text: skill.tr,
                        isSelected: isSelected,
                        onTap: () =>
                            missionController.updateSelectedSkill(skill),
                      );
                    });
                  },
                ),
              ),
              const Gap(20),

              /// Job Posts List / Loaders / Empty State
              Obx(() {
                if (missionController.isLoading.value) {
                  return SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (missionController.jobPostsList.isEmpty) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: CustomText(
                        "No missions found".tr,
                        fontSize: 14,
                        color: AppColors.blackColor.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missionController.jobPostsList.length,
                  itemBuilder: (context, index) {
                    final jobPost = missionController.jobPostsList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: JobGridHelper(job: jobPost),
                    );
                  },
                );
              }),

              /// Load More Spinner
              Obx(() {
                if (missionController.isMoreLoading.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Date Field Widget
  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required RxString dateRx,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        const Gap(6),
        InkWell(
          onTap: () => missionController.selectDate(context, dateRx),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.blackColor.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => CustomText(
                    dateRx.value.isNotEmpty ? dateRx.value : hint,
                    fontSize: 12,
                    color: dateRx.value.isNotEmpty
                        ? AppColors.blackColor
                        : AppColors.blackColor.withValues(alpha: 0.4),
                  ),
                ),
                SvgPicture.asset(
                  IconPath.calendars,
                  height: 16.h,
                  width: 16.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blackColor,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
