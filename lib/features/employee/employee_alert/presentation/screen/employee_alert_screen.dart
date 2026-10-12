import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../recruiter/recruiter_alart/controller/recruiter_alert_controller.dart';
import '../../../../recruiter/recruiter_alart/presentation/widget/alert_card.dart';

class EmployeeAlertScreen extends StatelessWidget {
  EmployeeAlertScreen({super.key});

  final RecruiterAlertController recruiterAlertController =
      Get.find<RecruiterAlertController>();
  final ScrollController _scrollController = ScrollController();

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        recruiterAlertController.loadMoreAlerts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setupScrollListener();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    "Alerts".tr,
                    font: AppFont.inter,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  Obx(() {
                    final hasUnread =
                        recruiterAlertController.unreadCount.value > 0 ||
                        recruiterAlertController.alertsList.any(
                          (item) => item.isRead == false,
                        );

                    if (!hasUnread) return const SizedBox.shrink();

                    return TextButton(
                      onPressed: () => recruiterAlertController.markAllAsRead(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: CustomText(
                        "Mark all as read".tr,
                        font: AppFont.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Obx(
                    () => FilterChip(
                      label: Text("All".tr),
                      selected: !recruiterAlertController.showOnlyUnread.value,
                      onSelected: (_) =>
                          recruiterAlertController.toggleUnreadFilter(false),
                      selectedColor: AppColors.primaryColor.withValues(
                        alpha: 0.15,
                      ),
                      checkmarkColor: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => FilterChip(
                      label: Text("Unread".tr),
                      selected: recruiterAlertController.showOnlyUnread.value,
                      onSelected: (_) =>
                          recruiterAlertController.toggleUnreadFilter(true),
                      selectedColor: AppColors.primaryColor.withValues(
                        alpha: 0.15,
                      ),
                      checkmarkColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: recruiterAlertController.refreshAlerts,
                  child: Obx(() {
                    if (recruiterAlertController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    final list = recruiterAlertController.alertsList;

                    if (list.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 150.h),
                          Center(
                            child: CustomText(
                              recruiterAlertController.showOnlyUnread.value
                                  ? "No unread alerts.".tr
                                  : "No new alerts right now.".tr,
                              font: AppFont.inter,
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          list.length +
                          (recruiterAlertController.isLoadingMore.value
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index == list.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        final alert = list[index];
                        return AlertCard(
                          notification: alert,
                          onTap: () =>
                              recruiterAlertController.handleAlertTap(alert),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
