import 'dart:developer';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../routes/app_routes.dart';
import '../../employee/employee_profile/controller/employee_profile_controller.dart';
import '../../recruiter/recruiter_profile/controller/recruiter_profile_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startRoutingDelay();
  }

  Future<void> _startRoutingDelay() async {
    await Future.delayed(const Duration(seconds: 1));
    final role = AuthService.userRole?.toUpperCase();
    final bool isProfileComplete = AuthService.userSetUp ?? false;

    log("Token check: ${AuthService.token}");
    log("Role check: $role");
    log("Profile complete check: $isProfileComplete");

    if (AuthService.hasToken()) {
      final token = AuthService.token!;
      bool isTokenExpired = false;

      try {
        isTokenExpired = JwtDecoder.isExpired(token);
      } catch (e) {
        log("JWT Decoding Error: $e");
        isTokenExpired = true;
      }

      if (isTokenExpired) {
        log("Token expired, redirecting to login");
        await AuthService.deleteTokenRole();
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      try {
        if (role == 'EMPLOYEE') {
          final employeeCtrl = Get.isRegistered<EmployeeProfileController>()
              ? Get.find<EmployeeProfileController>()
              : Get.put(EmployeeProfileController());

          await employeeCtrl.fetchProfileData();
          Get.offAllNamed(AppRoutes.employeeNav);
        } else if (role == 'EMPLOYER') {
          final recruiterCtrl = Get.isRegistered<RecruiterProfileController>()
              ? Get.find<RecruiterProfileController>()
              : Get.put(RecruiterProfileController());

          await recruiterCtrl.fetchProfileData();

          log("City : ${AuthService.city}");
          log("Neighbour : ${AuthService.neighborhood}");

          Get.offAllNamed(AppRoutes.recruiterNav);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      } catch (e) {
        log("Splash Routing Error: $e");
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
