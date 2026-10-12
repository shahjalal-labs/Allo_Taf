import 'dart:io';

import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_profile/controller/employee_profile_controller.dart';
import 'package:allo_taf/features/language/controller/language_change_controller.dart';
import 'package:allo_taf/features/language/presentation/tr_screen/language_change.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';

class EmployeeProfileScreen extends StatelessWidget {
  EmployeeProfileScreen({super.key});

  final EmployeeProfileController controller = Get.find();
  final LanguageChangeController languageChangeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isFetching.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 8.h, right: 4.w),
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
                                  languageChangeController
                                      .selectedLanguage
                                      .value,
                                  font: AppFont.inter,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              Gap(4),
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
                Gap(25),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          final imageUrl = controller.profileImageUrl.value;
                          final localPath = controller.profileImagePath.value;

                          ImageProvider imageProvider;
                          if (localPath.isNotEmpty) {
                            imageProvider = FileImage(File(localPath));
                          } else if (imageUrl.isNotEmpty) {
                            imageProvider = CachedNetworkImageProvider(
                              imageUrl,
                            );
                          } else {
                            imageProvider = AssetImage(IconPath.userImages);
                          }

                          return CircleAvatar(
                            radius: 54.r,
                            backgroundColor: AppColors.greyColor,
                            backgroundImage: imageProvider,
                          );
                        }),
                      ),
                      Positioned(
                        bottom: 2.h,
                        right: 2.w,
                        child: InkWell(
                          onTap: controller.navigateToEditProfile,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.whiteColor,
                                width: 3.r,
                              ),
                            ),
                            child: Icon(
                              Icons.edit_square,
                              color: AppColors.backgroundColor,
                              size: 14.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(16),
                Obx(
                  () => CustomText(
                    controller.employeeName.value.isNotEmpty
                        ? controller.employeeName.value
                        : "No Name".tr,
                    font: AppFont.inter,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                Gap(25),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withValues(alpha: 0.04),
                        blurRadius: 13,
                        spreadRadius: 13,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuTile(
                        icon: IconPath.myProfile,
                        iconColor: AppColors.blackColor,
                        title: "My Profile".tr,
                        textColor: AppColors.blackColor,
                        showTrailing: true,
                        onTap: () =>
                            Get.toNamed(AppRoutes.employeeMyProfileScreen),
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.blackColor.withValues(alpha: 0.1),
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
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
                        color: AppColors.blackColor.withValues(alpha: 0.1),
                        indent: 16.w,
                        endIndent: 16.w,
                      ),

                      _buildMenuTile(
                        icon: IconPath.delete,
                        iconColor: AppColors.redColor,
                        title: "Delete Account".tr,
                        textColor: AppColors.redColor,
                        onTap: controller.handleDeleteAccount,
                      ),

                      Divider(
                        height: 1,
                        color: AppColors.blackColor.withValues(alpha: 0.1),
                        indent: 16.w,
                        endIndent: 16.w,
                      ),

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
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
                color: AppColors.greyColor,
                size: 14.r,
              ),
          ],
        ),
      ),
    );
  }
}
