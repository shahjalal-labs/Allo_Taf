import 'package:allo_taf/features/recruiter/recruiter_nav/recruiter_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/icon_path/icon_path.dart';
import '../recruiter_alart/presentation/screen/recruiter_alert_screen.dart';
import '../recruiter_cv_database/presentation/screen/recruiter_cv_database_screen.dart';
import '../recruiter_home/presentation/screen/recruiter_home_screen.dart';
import '../recruiter_mission/presentation/screen/recruiter_mission_screen.dart';
import '../recruiter_profile/presentation/screen/recruiter_profile_screen.dart';

class RecruiterNav extends StatelessWidget {
  RecruiterNav({super.key});

  final RecruiterNavController navIndexController = Get.put(
    RecruiterNavController(),
  );

  final List<Widget> screens = [
    RecruiterHomeScreen(),
    RecruiterMissionScreen(),
    RecruiterAlertScreen(),
    RecruiterCvDatabaseScreen(),
    RecruiterProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: navIndexController.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: BottomNavigationBar(
              currentIndex: navIndexController.selectedIndex.value,
              onTap: navIndexController.changeIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconPath.home,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    IconPath.home,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Home".tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconPath.mission,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    IconPath.mission,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "My missions".tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconPath.notification,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    IconPath.notification,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Alerts".tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconPath.cvDatabase,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    IconPath.cvDatabase,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "CV Database".tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconPath.profile,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    IconPath.profile,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "My Profile".tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*  Widget _buildNavItem({
    required int index,
    required String label,
    required String svgPath,
  }) {
    final bool isSelected = navIndexController.selectedIndex.value == index;
    final Color activeColor = AppColors.primaryColor;
    final Color inactiveColor = Colors.grey[500]!;

    return GestureDetector(
      onTap: () => navIndexController.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? activeColor : inactiveColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 6),
          // Removed the fixed width constraint to prevent overflow
          CustomText(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            font: AppFont.inter,
            fontSize: 10,
            height: 1.1,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ],
      ),
    );
  } */
}
