import 'package:allo_taf/features/recruiter/recruiter_home/presentation/widget/recruiter_subscription_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/service/auth_service.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/icon_path/icon_path.dart';
import '../../../recruiter_alart/controller/recruiter_alert_controller.dart';
import '../../../recruiter_nav/recruiter_nav_controller.dart';

class RecruiterHeader extends StatelessWidget {
  final String subtitle;
  final VoidCallback? onCrownTap;
  final VoidCallback? onNotificationTap;

  RecruiterHeader({
    super.key,
    required this.subtitle,
    this.onCrownTap,
    this.onNotificationTap,
  });

  final RecruiterAlertController recruiterNotificationController =
      Get.find<RecruiterAlertController>();

  @override
  Widget build(BuildContext context) {
    final bool isSubscribed = AuthService.isSubscribed ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(IconPath.appLogo),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Allô ",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                          TextSpan(
                            text: "Taf",
                            style: TextStyle(color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      subtitle,
                      font: AppFont.inter,
                      fontSize: 11.sp,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Action Icons Row
        Row(
          children: [
            /// Crown Icon — Shown only if the user is NOT subscribed
            if (!isSubscribed) ...[
              GestureDetector(
                onTap:
                    onCrownTap ?? () => showRecruiterSubscriptionSheet(context),
                child: SvgPicture.asset(
                  IconPath.crown,
                  width: 28.w,
                  height: 28.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.goldColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
            ],

            GestureDetector(
              onTap:
                  onNotificationTap ??
                  () {
                    final RecruiterNavController recruiterNavController =
                        Get.find<RecruiterNavController>();
                    recruiterNavController.changeIndex(2);
                  },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    IconPath.notification,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blackColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  Obx(() {
                    final count =
                        recruiterNotificationController.unreadCount.value;
                    if (count <= 0) return const SizedBox.shrink();

                    return Positioned(
                      right: -4.w,
                      top: -4.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: count > 99 ? 3.w : 4.w,
                          vertical: 1.h,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          count > 99 ? '99+' : count.toString(),
                          font: AppFont.inter,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
