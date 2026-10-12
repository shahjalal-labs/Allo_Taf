import 'dart:io';

import 'package:allo_taf/core/global/custom_text.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Select image
Widget buildImageHelper({String? imagePath, String? imageUrl}) {
  return Container(
    width: double.infinity,
    height: 80.h,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.4)),
    ),
    child: (imagePath != null && imagePath.isNotEmpty)
        ? Image.file(File(imagePath), fit: BoxFit.cover)
        : (imageUrl != null && imageUrl.isNotEmpty)
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) => _buildPlaceholder(),
          )
        : _buildPlaceholder(),
  );
}

Widget _buildPlaceholder() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        IconPath.gallery,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.blackColor.withValues(alpha: 0.9),
          BlendMode.srcIn,
        ),
      ),
      const Gap(6),
      CustomText(
        "Upload image".tr,
        font: AppFont.inter,
        fontSize: 14,
        color: AppColors.blackColor.withValues(alpha: 0.5),
      ),
    ],
  );
}
