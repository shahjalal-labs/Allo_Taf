import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/global/custom_back_button.dart';
import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/recruiter_employee_profile_controller.dart';
import '../../model/user_reviews_model.dart';

class ViewAllReviewsScreen extends StatelessWidget {
  ViewAllReviewsScreen({super.key});

  final RecruiterEmployeeProfileController controller =
      Get.find<RecruiterEmployeeProfileController>();

  @override
  Widget build(BuildContext context) {
    // Scroll controller for pagination trigger
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.handleViewAllReviews();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom Header (Replaces AppBar) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      "All Reviews".tr,
                      font: AppFont.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // --- Body Content ---
            Expanded(
              child: Obx(() {
                // --- Initial Loading State ---
                if (controller.isReviewsLoading.value &&
                    controller.reviewsList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                // --- Empty State ---
                if (controller.reviewsList.isEmpty) {
                  return Center(
                    child: CustomText(
                      "No reviews found.".tr,
                      font: AppFont.inter,
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    await controller.fetchReviews(page: 1, isRefresh: true);
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    itemCount: controller.reviewsList.length + 1,
                    itemBuilder: (context, index) {
                      // Bottom loading indicator for pagination
                      if (index == controller.reviewsList.length) {
                        return Obx(() {
                          if (controller.isMoreReviewsLoading.value) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        });
                      }

                      final reviewData = controller.reviewsList[index];
                      return ReviewItemTile(review: reviewData);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Compatible ReviewItemTile Component ---
class ReviewItemTile extends StatelessWidget {
  final ReviewData review;

  const ReviewItemTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM').format(review.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Avatar
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

                // Star Rating
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

                // Comment Text
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
