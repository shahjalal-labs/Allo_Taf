import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/global/custom_loading_indicator.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/icon_path/icon_path.dart';
import '../../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    final size = MediaQuery.of(context).size;

    log("Token check: ${AuthService.token}");

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: size.width * 0.40,
                    height: size.width * 0.40,
                    child: Image.asset(
                      IconPath.splashLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              Positioned(
                bottom: size.height * 0.1,
                child: const CustomLoadingIndicator(
                  size: 45,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
