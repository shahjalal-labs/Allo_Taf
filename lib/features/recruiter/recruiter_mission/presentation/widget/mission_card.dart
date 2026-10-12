import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../model/recruiter_missions_model.dart';

class MissionCard extends StatelessWidget {
  final MissionItem mission;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MissionCard({
    super.key,
    required this.mission,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String urgency = mission.urgencyLevel ?? "STANDARD";
    final bool isBoosted = urgency == "BOOSTED";
    final bool isUrgent = urgency == "URGENT";

    // Setup color palettes according to badges in UI
    final Color badgeBgColor = isBoosted
        ? const Color(0xFFFFF7EB)
        : isUrgent
        ? const Color(0xFFFDF0F2)
        : Colors.grey[100]!;

    final Color badgeTextColor = isBoosted
        ? AppColors.secondaryColor
        : isUrgent
        ? AppColors.primaryColor
        : Colors.grey[700]!;

    // Location & Duration Formatting
    final String locationText = [
      if (mission.neighborhood != null && mission.neighborhood!.isNotEmpty)
        mission.neighborhood,
      if (mission.city != null && mission.city!.isNotEmpty) mission.city,
    ].join(", ");

    final String durationText = mission.workHours != null
        ? "${mission.workHours} hrs/day"
        : "";

    final String locationAndDuration = [
      if (locationText.isNotEmpty) locationText,
      if (durationText.isNotEmpty) durationText,
    ].join(" · ");

    // Remuneration Formatting
    final String remunerationText = mission.remuneration != null
        ? "${mission.remuneration} FCFA"
        : "N/A";

    // Timeframe calculation from start date
    final String timeframeText = _getTimeframeLabel(
      mission.visibilityStartDate,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (urgency != "STANDARD")
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isBoosted
                              ? Icons.rocket_launch_rounded
                              : Icons.bolt_rounded,
                          size: 12.sp,
                          color: badgeTextColor,
                        ),
                        SizedBox(width: 4.w),
                        CustomText(
                          urgency,
                          font: AppFont.inter,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // 3-Dot Action Menu Button
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(width: 120.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey[600],
                    size: 20.sp,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      height: 38.h,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 18.sp,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            "Edit".tr,
                            font: AppFont.inter,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      height: 38.h,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            IconPath.delete,
                            colorFilter: ColorFilter.mode(
                              Colors.red,
                              BlendMode.srcIn,
                            ),
                            width: 18.w,
                            height: 18.h,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            "Delete".tr,
                            font: AppFont.inter,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (urgency != "STANDARD") SizedBox(height: 6.h),

            // Mission Context Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        mission.title ?? "Untitled Mission",
                        font: AppFont.inter,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                      if (locationAndDuration.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        CustomText(
                          locationAndDuration,
                          font: AppFont.inter,
                          fontSize: 13,
                          color: Colors.grey[500]!,
                        ),
                      ],
                    ],
                  ),
                ),
                // Timeframe Due Tag
                if (timeframeText.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: timeframeText == "This week"
                          ? const Color(0xFFEAEFEF)
                          : const Color(0xFFFDF0F2),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (timeframeText == "Today") ...[
                          Icon(
                            Icons.access_time_filled_rounded,
                            size: 10.sp,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 2.w),
                        ],
                        CustomText(
                          timeframeText,
                          font: AppFont.inter,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: timeframeText == "This week"
                              ? const Color(0xFF334E4E)
                              : AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 14.h),

            // Bottom agency & cost layout summary strip
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF5F0),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    locationText.isNotEmpty ? locationText : "Location N/A",
                    font: AppFont.inter,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  CustomText(
                    remunerationText,
                    font: AppFont.inter,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to convert UTC ISO String into relative labels ("Today", "This week")
  String _getTimeframeLabel(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    final startDate = DateTime.tryParse(dateStr)?.toLocal();
    if (startDate == null) return "";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final missionDay = DateTime(startDate.year, startDate.month, startDate.day);

    if (missionDay.isAtSameMomentAs(today)) {
      return "Today";
    } else if (missionDay.isAfter(today) &&
        missionDay.isBefore(today.add(const Duration(days: 7)))) {
      return "This week";
    }
    return "";
  }
}
