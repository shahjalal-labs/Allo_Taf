import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/language/controller/language_change_controller.dart';
import 'package:allo_taf/features/language/presentation/tr_screen/language_change.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../controller/recruiter_profile_controller.dart';

class RecruiterProfileScreen extends StatelessWidget {
  RecruiterProfileScreen({super.key});

  final RecruiterProfileController controller =
      Get.find<RecruiterProfileController>();
  final LanguageChangeController languageChangeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.profileData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 8.h, right: 20.w),
                child: Row(
                  children: [
                    CustomText(
                      "Profile".tr,
                      font: AppFont.inter,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                    const Spacer(),

                    /// Change language button
                    GestureDetector(
                      onTap: () {
                        languageChangeController.openDialog();
                        LanguageChange(context: context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.4,
                            ),
                            width: 1.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withValues(
                                alpha: 0.04,
                              ),
                              blurRadius: 5,
                              spreadRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Obx(
                              () => CustomText(
                                languageChangeController.selectedLanguage.value,
                                font: AppFont.inter,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                            const Gap(4),
                            Icon(
                              Icons.translate,
                              color: AppColors.blackColor,
                              size: 17.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.fetchProfileData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Header Title Bar
                        SizedBox(height: 32.h),

                        // Dynamic Profile Avatar with Network Image & Edit Badge
                        Center(
                          child: GestureDetector(
                            onTap: controller.navigateToEditProfile,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.r,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Obx(() {
                                    final imageUrl =
                                        controller.profileImageUrl.value;
                                    return CircleAvatar(
                                      radius: 54.r,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: imageUrl.isNotEmpty
                                          ? CachedNetworkImageProvider(imageUrl)
                                                as ImageProvider
                                          : const AssetImage(
                                              'assets/images/recruiter_avatar.png',
                                            ),
                                      child: imageUrl.isEmpty
                                          ? Icon(
                                              Icons.person_rounded,
                                              size: 50.r,
                                              color: Colors.grey[400],
                                            )
                                          : null,
                                    );
                                  }),
                                ),
                                Positioned(
                                  bottom: 2.h,
                                  right: 2.w,
                                  child: Container(
                                    padding: EdgeInsets.all(6.r),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit_square,
                                      color: AppColors.whiteColor,
                                      size: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Recruiter Profile Name
                        Obx(
                          () => CustomText(
                            controller.recruiterName.value.isNotEmpty
                                ? controller.recruiterName.value
                                : "Recruiter Name".tr,
                            font: AppFont.inter,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Grouped Menu Container Card
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Column(
                            children: [
                              // Edit Profile Row
                              _buildMenuTile(
                                icon: IconPath.editProfile,
                                iconColor: AppColors.blackColor,
                                title: "Edit Profile".tr,
                                textColor: AppColors.blackColor,
                                showTrailing: true,
                                onTap: controller.navigateToEditProfile,
                              ),

                              Divider(
                                height: 1,
                                color: Colors.grey[100],
                                indent: 16.w,
                                endIndent: 16.w,
                              ),

                              // Account Deletion Row
                              _buildMenuTile(
                                icon: IconPath.delete,
                                iconColor: AppColors.redColor,
                                title: "Delete Account".tr,
                                textColor: AppColors.redColor,
                                onTap: controller.handleDeleteAccount,
                              ),

                              Divider(
                                height: 1,
                                color: Colors.grey[100],
                                indent: 16.w,
                                endIndent: 16.w,
                              ),

                              // Logout Session Action Row
                              _buildMenuTile(
                                icon: IconPath.logout,
                                iconColor: AppColors.redColor,
                                title: "Logout".tr,
                                textColor: AppColors.redColor,
                                onTap: controller.handleLogout,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMenuTile({
    required String icon,
    required Color iconColor,
    required String title,
    required Color textColor,
    bool showTrailing = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              height: 22.sp,
              width: 22.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: CustomText(
                title,
                font: AppFont.inter,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            if (showTrailing)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 14.sp,
              ),
          ],
        ),
      ),
    );
  }
}
