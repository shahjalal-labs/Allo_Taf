import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../utils/constants/app_colors.dart';
import '../utils/icon_path/icon_path.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: SvgPicture.asset(
        IconPath.arrowLeft,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          AppColors.bodyTextColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
