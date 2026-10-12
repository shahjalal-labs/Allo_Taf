import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/global/custom_back_button.dart';
import '../../../../core/global/custom_button.dart';
import '../../../../core/global/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/icon_path/icon_path.dart';
import '../../controller/auth_controller.dart';

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [CustomBackButton()],
                ),
              ),

              Image.asset(
                IconPath.splashLogo,
                width: size.width * 0.28,
                height: size.width * 0.28,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),

              CustomText(
                "Welcome to Allô Taf!".tr,
                font: AppFont.inter,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 6),
              CustomText(
                "The right job, at the right time".tr,
                font: AppFont.inter,
                fontSize: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 32),

              // Section Subtitle
              CustomText(
                "What are you here for?".tr,
                font: AppFont.inter,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              const SizedBox(height: 24),

              // --- SELECTABLE ROLE CARDS ENTRY BLOCKS ---
              Obx(() {
                final isJobSelected =
                    controller.selectedRole.value == 'EMPLOYEE';
                return _buildRoleCard(
                  title: "I'm looking for a job".tr,
                  subtitle:
                      "Quick assignments, direct payment,\nbuild your reputation."
                          .tr,
                  svgPath: IconPath.search,
                  isSelected: isJobSelected,
                  selectedBgColor: const Color(0xFFF3E7EA),
                  borderColor: AppColors.primaryColor,
                  onTap: () => controller.selectedRole.value = 'EMPLOYEE',
                );
              }),
              const SizedBox(height: 16),

              Obx(() {
                final isRecruitingSelected =
                    controller.selectedRole.value == 'RECRUITER';
                return _buildRoleCard(
                  title: "I'm recruiting".tr,
                  subtitle:
                      "Post a need in 2 minutes, find the\nright person today"
                          .tr,
                  svgPath: IconPath.jobLink,
                  isSelected: isRecruitingSelected,
                  selectedBgColor: AppColors.goldColor.withValues(alpha: 0.1),
                  borderColor: AppColors.goldColor,
                  onTap: () => controller.selectedRole.value = 'RECRUITER',
                );
              }),

              const Spacer(),

              // Core Action Continue Button
              CustomButton(
                text: "Continue".tr,
                font: AppFont.inter,
                backgroundColor: AppColors.primaryColor,
                width: double.infinity,
                borderRadius: 14.0,
                onTap: controller.handleRoleSelectionContinue,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required String svgPath,
    required bool isSelected,
    required Color selectedBgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? borderColor : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular SVG Container Base
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                svgPath,
                colorFilter: ColorFilter.mode(borderColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 16),

            // Card Text Descriptions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    font: AppFont.inter,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? borderColor : AppColors.blackColor,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    subtitle,
                    font: AppFont.inter,
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
