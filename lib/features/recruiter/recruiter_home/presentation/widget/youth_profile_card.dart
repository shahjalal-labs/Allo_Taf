import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../model/employee_details_model.dart';

class YouthProfileCard extends StatelessWidget {
  final EmployeeDetailsResult employee;

  const YouthProfileCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    // Format location string safely
    final String locationText = employee.neighborhood.isNotEmpty
        ? "${employee.neighborhood}, ${employee.city}"
        : employee.city.isNotEmpty
        ? employee.city
        : "Cameroon";

    // Format primary role/skills display
    final String roleText = employee.skills.isNotEmpty
        ? employee.skills.join(', ')
        : (employee.bio.isNotEmpty ? employee.bio : 'Candidate'.tr);

    // Derived boolean flags from model
    final bool isVerified = employee.isSubscribed ?? false;
    final bool isAvailable = employee.availabilityStart != null;
    final bool hasCv = employee.cv != null && employee.cv!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image with Fallback Icon
          ClipOval(
            child:
                employee.profileImage != null &&
                    employee.profileImage!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: employee.profileImage!,
                    width: 92.r,
                    height: 92.r,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) =>
                        _buildAvatarFallback(),
                  )
                : _buildAvatarFallback(),
          ),
          SizedBox(height: 12.h),

          // Candidate Full Name
          CustomText(
            employee.fullName,
            font: AppFont.inter,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),

          // Location Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Flexible(
                child: CustomText(
                  locationText,
                  font: AppFont.inter,
                  fontSize: 13.sp,
                  color: Colors.grey[500],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Status Badge Chips Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isVerified) ...[
                _buildTagChip(
                  "Verified".tr,
                  const Color(0xFFE6F4EA),
                  const Color(0xFF137333),
                ),
                SizedBox(width: 6.w),
              ],
              if (isAvailable) ...[
                _buildTagChip(
                  "Avail. today".tr,
                  const Color(0xFFE8F0FE),
                  const Color(0xFF1A73E8),
                ),
                SizedBox(width: 6.w),
              ],
              if (hasCv) ...[
                _buildTagChip(
                  "CV".tr,
                  const Color(0xFFFFF7E6),
                  const Color(0xFFB06000),
                ),
              ],
            ],
          ),
          SizedBox(height: 14.h),

          // Role, Rating, and Review/Job Counts Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: CustomText(
                  roleText,
                  font: AppFont.inter,
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.star, color: AppColors.goldColor, size: 16.sp),
              SizedBox(width: 4.w),
              CustomText(
                employee.reviewStats.averageRating.toStringAsFixed(1),
                font: AppFont.inter,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              CustomText(
                "  •  ${employee.reviewStats.totalReviews} ${"reviews".tr}",
                font: AppFont.inter,
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 92.r,
      height: 92.r,
      color: AppColors.primaryColor.withValues(alpha: 0.1),
      child: Icon(Icons.person, size: 46.sp, color: AppColors.primaryColor),
    );
  }

  Widget _buildTagChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: CustomText(
        label,
        font: AppFont.inter,
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
