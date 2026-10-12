import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/icon_path/icon_path.dart';
import '../../model/alert_model.dart';

class AlertCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const AlertCard({super.key, required this.notification, required this.onTap});

  /// Helper method to format creation time into relative display text
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now'.tr;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ${'ago'.tr}';
    if (diff.inHours < 24) return '${diff.inHours}h ${'ago'.tr}';
    if (diff.inDays < 7) return '${diff.inDays}d ${'ago'.tr}';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = notification.isRead == false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primaryColor.withValues(alpha: 0.04)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          border: isUnread
              ? Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.015),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon Circle wrapper with unread dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    IconPath.notification,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blackColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          (notification.title ?? '').tr,
                          font: AppFont.inter,
                          fontSize: 15,
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: AppColors.blackColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (notification.createdAt != null) ...[
                        SizedBox(width: 8.w),
                        CustomText(
                          _formatTime(notification.createdAt),
                          font: AppFont.inter,
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    (notification.body ?? '').tr,
                    font: AppFont.inter,
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
