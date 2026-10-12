import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../model/employee_details_model.dart';

class ReviewItemTile extends StatelessWidget {
  final RecentReview review;

  const ReviewItemTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // Format date string (e.g., "22 Jul")
    final String formattedDate = DateFormat('dd MMM').format(review.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Avatar with Fallback Image
          ClipOval(
            child:
                review.reviewer.profileImage != null &&
                    review.reviewer.profileImage!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: review.reviewer.profileImage!,
                    width: 44.r,
                    height: 44.r,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) =>
                        _buildAvatarFallback(),
                  )
                : _buildAvatarFallback(),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reviewer Name & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        review.reviewer.fullName.isNotEmpty
                            ? review.reviewer.fullName
                            : "Anonymous",
                        font: AppFont.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      formattedDate,
                      font: AppFont.inter,
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Stars Rating Row
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < review.rating.floor()
                              ? AppColors.goldColor
                              : Colors.grey[300],
                          size: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      review.rating.toStringAsFixed(1),
                      font: AppFont.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Comment
                CustomText(
                  review.comment,
                  font: AppFont.inter,
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 44.r,
      height: 44.r,
      color: AppColors.primaryColor.withValues(alpha: 0.1),
      child: Icon(Icons.person, size: 22.sp, color: AppColors.primaryColor),
    );
  }
}
