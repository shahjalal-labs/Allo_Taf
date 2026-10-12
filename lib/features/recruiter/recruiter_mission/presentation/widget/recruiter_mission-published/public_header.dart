import 'package:allo_taf/core/global/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/global/custom_text.dart';

class PublishedHeader extends StatelessWidget {
  const PublishedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomBackButton(),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomText(
                "Urgent need? Publish your mission 🚀".tr,
                font: AppFont.inter,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        CustomText(
          "It takes 30 seconds".tr,
          font: AppFont.inter,
          fontSize: 13.sp,
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
