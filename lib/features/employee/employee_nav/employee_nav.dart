import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/icon_path/icon_path.dart';
import '../employee_alert/presentation/screen/employee_alert_screen.dart';
import '../employee_home/presentation/screen/employee_home_screen.dart';
import '../employee_missions/presentation/screen/employee_mission_screen.dart';
import '../employee_profile/presentation/screen/employee_profile_screen.dart';
import 'employee_nav_controller.dart';

class EmployeeNav extends StatelessWidget {
  EmployeeNav({super.key});

  final EmployeeNavController navIndexController = Get.put(
    EmployeeNavController(),
  );

  final List<Widget> screens = [
    EmployeeHomeScreen(),
    EmployeeMissionScreen(),
    EmployeeAlertScreen(),
    EmployeeProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: navIndexController.selectedIndex.value,
          children: screens,
        ),
        /* bottomNavigationBar: Container(
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    label: "Home".tr,
                    svgPath: IconPath.home,
                  ),
                  _buildNavItem(
                    index: 1,
                    label: "Mission".tr,
                    svgPath: IconPath.mission,
                  ),
                  _buildNavItem(
                    index: 2,
                    label: "Alerts".tr,
                    svgPath: IconPath.notification,
                  ),
                  _buildNavItem(
                    index: 3,
                    label: "Profile".tr,
                    svgPath: IconPath.profile,
                  ),
                ],
              ),
            ),
          ),
        ), */
        bottomNavigationBar: Obx(
          () => Container(
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

                selectedFontSize: 12,
                unselectedFontSize: 12,

                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
                    label: "Mission".tr,
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
                    label: "Profile".tr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*   Widget _buildNavItem({
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
          CustomText(
            label,
            font: AppFont.inter,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ],
      ),
    );
  } */
}
