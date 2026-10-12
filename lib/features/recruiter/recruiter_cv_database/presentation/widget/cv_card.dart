import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../model/cv_list_model.dart';

class CvCard extends StatelessWidget {
  final CandidateProfile candidate;
  final VoidCallback onUnlockProfile;

  const CvCard({
    super.key,
    required this.candidate,
    required this.onUnlockProfile,
  });

  bool get _isAvailableToday {
    final dynamic startRaw = candidate.availabilityStart;
    final dynamic endRaw = candidate.availabilityEnd;

    // 1. Return true if either start or end is null
    if (startRaw == null || endRaw == null) {
      return true;
    }

    final now = DateTime.now();
    DateTime? parseToDateTimeToday(dynamic input) {
      if (input is DateTime) {
        return input;
      }
      if (input is TimeOfDay) {
        return DateTime(now.year, now.month, now.day, input.hour, input.minute);
      }
      if (input is String) {
        final parsed = DateTime.tryParse(input);
        if (parsed != null) return parsed;
      }
      return null;
    }

    final start = parseToDateTimeToday(startRaw);
    final end = parseToDateTimeToday(endRaw);

    if (start == null || end == null) {
      return true;
    }

    return now.isAfter(start) && now.isBefore(end);
  }

  @override
  Widget build(BuildContext context) {
    final String locationText = candidate.neighborhood.isNotEmpty
        ? "${candidate.neighborhood}, ${candidate.city}"
        : candidate.city;

    final String roleText = candidate.skills.isNotEmpty
        ? candidate.skills.join(" • ")
        : (candidate.bio.isNotEmpty ? candidate.bio : "No bio specified".tr);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo & Name/Location Row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: candidate.profileImage.isNotEmpty
                    ? CachedNetworkImageProvider(candidate.profileImage)
                    : null,
                child: candidate.profileImage.isEmpty
                    ? const Icon(Icons.person, size: 20, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      candidate.fullName,
                      font: AppFont.inter,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: CustomText(
                            locationText,
                            font: AppFont.inter,
                            fontSize: 10,
                            color: Colors.grey[500],
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
          const SizedBox(height: 10),

          // Dynamic Badge Tag Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (candidate.isSubscribed ?? false) ...[
                  _buildTagChip(
                    "Verified".tr,
                    const Color(0xFFE6F4EA),
                    const Color(0xFF137333),
                  ),
                  const SizedBox(width: 4),
                ],

                // Render "Avail. today" tag
                if (_isAvailableToday) ...[
                  _buildTagChip(
                    "Avail. today".tr,
                    const Color(0xFFFCE8E6),
                    const Color(0xFFC5221F),
                  ),
                  const SizedBox(width: 4),
                ],

                _buildTagChip(
                  "CV".tr,
                  const Color(0xFFFFF7E6),
                  const Color(0xFFB06000),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Role / Skills Description Text
          CustomText(
            roleText,
            font: AppFont.inter,
            fontSize: 12,
            color: Colors.grey[700],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Ratings Row
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.goldColor, size: 14),
              const SizedBox(width: 2),
              CustomText(
                "${candidate.reviewStats.averageRating}",
                font: AppFont.inter,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              CustomText(
                "  •  ${candidate.reviewStats.totalReviews} ${'reviews'.tr}",
                font: AppFont.inter,
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ],
          ),
          const Spacer(),

          // Action button
          GestureDetector(
            onTap: onUnlockProfile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: CustomText(
                      "Unlock Profile".tr,
                      font: AppFont.inter,
                      maxLines: 1,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
        borderRadius: BorderRadius.circular(6),
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
