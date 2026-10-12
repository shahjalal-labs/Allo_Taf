import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/features/recruiter/recruiter_home/presentation/widget/recruiter_subscription_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../recruiter_cv_database/model/cv_list_model.dart';

class YouthCard extends StatelessWidget {
  final CandidateProfile candidate;
  final VoidCallback onUnlockProfile;

  const YouthCard({
    super.key,
    required this.candidate,
    required this.onUnlockProfile,
  });

  @override
  Widget build(BuildContext context) {
    // Primary display role from skills list or default string
    final String primaryRole = candidate.skills.isNotEmpty
        ? candidate.skills.join(', ')
        : 'Candidate'.tr;

    // Location string formatting
    final String locationText = candidate.neighborhood.isNotEmpty
        ? "${candidate.neighborhood}, ${candidate.city}"
        : candidate.city.isNotEmpty
        ? candidate.city
        : "Cameroon";

    // Boolean checks directly against CandidateProfile fields
    final bool isVerified = candidate.isSubscribed ?? false;
    final bool isAvailable = candidate.availabilityStart != null;
    final bool hasCv = candidate.cv.isNotEmpty;

    // Check recruiter's overall subscription status
    final bool isRecruiterSubscribed = AuthService.isSubscribed ?? false;

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo & Name/Location Row
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: candidate.profileImage,
                  width: 38.w,
                  height: 38.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      width: 38.w,
                      height: 38.h,
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      candidate.fullName,
                      font: AppFont.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 11.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: CustomText(
                            locationText,
                            font: AppFont.inter,
                            fontSize: 10.sp,
                            maxLines: 2,
                            color: Colors.grey[600],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Badge Tag Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (isVerified) ...[
                  _buildTagChip(
                    "Verified".tr,
                    const Color(0xFFE6F4EA),
                    const Color(0xFF137333),
                  ),
                  SizedBox(width: 4.w),
                ],
                if (isAvailable) ...[
                  _buildTagChip(
                    "Available".tr,
                    const Color(0xFFE8F0FE),
                    const Color(0xFF1A73E8),
                  ),
                  SizedBox(width: 4.w),
                ],
                if (hasCv)
                  _buildTagChip(
                    "CV",
                    const Color(0xFFFFF7E6),
                    const Color(0xFFB06000),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // Role Description Text
          CustomText(
            primaryRole,
            font: AppFont.inter,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          SizedBox(height: 4.h),

          // Ratings Row directly using reviewStats
          Row(
            children: [
              Icon(Icons.star, color: AppColors.goldColor, size: 13.sp),
              SizedBox(width: 3.w),
              CustomText(
                candidate.reviewStats.averageRating.toStringAsFixed(1),
                font: AppFont.inter,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              CustomText(
                " • ${candidate.reviewStats.totalReviews} ${'reviews'.tr}",
                font: AppFont.inter,
                fontSize: 10.sp,
                color: Colors.grey[500],
              ),
            ],
          ),

          const Spacer(),

          // "Unlock Profile" Action Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!isRecruiterSubscribed) {
                  showRecruiterSubscriptionSheet(context);
                } else {
                  onUnlockProfile();
                }
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.lock_open_rounded,
                      size: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        "Unlock Profile".tr,
                        font: AppFont.inter,
                        fontSize: 11.sp,
                        maxLines: 1,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        label,
        font: AppFont.inter,
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
