import 'package:allo_taf/features/employee/employee_missions/controller/employee_mission_controller.dart';
import 'package:allo_taf/features/employee/employee_missions/controller/employee_payment_controller.dart';
import 'package:allo_taf/features/employee/employee_missions/controller/urgent_mission_controller.dart';
import 'package:allo_taf/features/employee/employee_profile/controller/employee_profile_controller.dart';
import 'package:allo_taf/features/language/controller/language_change_controller.dart';
import 'package:allo_taf/features/recruiter/recruiter_home/controller/recruiter_home_controller.dart';
import 'package:allo_taf/features/recruiter/recruiter_mission/controller/recruiter_job_details_controller.dart';
import 'package:get/get.dart';

import '../../features/authentication/controller/auth_controller.dart';
import '../../features/employee/employee_home/controller/employee_home_controller.dart';
import '../../features/employee/employee_missions/controller/employee_mission_job_controller.dart';
import '../../features/recruiter/recruiter_alart/controller/recruiter_alert_controller.dart';
import '../../features/recruiter/recruiter_cv_database/controller/recruit_cv_controller.dart';
import '../../features/recruiter/recruiter_home/controller/recruiter_employee_profile_controller.dart';
import '../../features/recruiter/recruiter_home/controller/recruiter_subscription_controller.dart';
import '../../features/recruiter/recruiter_mission/controller/recruiter_mission_published_controller.dart';
import '../../features/recruiter/recruiter_mission/controller/recruiter_missions_controller.dart';
import '../../features/recruiter/recruiter_nav/recruiter_nav_controller.dart';
import '../../features/recruiter/recruiter_profile/controller/recruiter_profile_controller.dart';
import '../../features/splash/controller/splash_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    ///add by Lisan
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => RecruiterHomeController(), fenix: true);
    Get.lazyPut(() => RecruiterMissionsController(), fenix: true);
    Get.lazyPut(() => RecruiterAlertController(), fenix: true);
    Get.lazyPut(() => RecruitCvController(), fenix: true);
    Get.lazyPut(() => RecruiterEmployeeProfileController(), fenix: true);
    Get.lazyPut(() => RecruiterMissionPublishedController(), fenix: true);
    Get.lazyPut(() => RecruiterJobDetailsController(), fenix: true);
    Get.lazyPut(() => RecruiterNavController(), fenix: true);
    Get.lazyPut(() => RecruiterProfileController(), fenix: true);
    Get.lazyPut(() => EmployeeMissionJobController(), fenix: true);
    Get.lazyPut(() => EmployeeHomeController(), fenix: true);
    Get.lazyPut(() => RecruiterSubscriptionController(), fenix: true);

    ///add by Lisan end

    /// Added by Rabbi
    Get.lazyPut(() => UrgentMissionController(), fenix: true);
    Get.lazyPut(() => EmployeePaymentController(), fenix: true);
    Get.lazyPut(() => EmployeeProfileController(), fenix: true);
    Get.lazyPut(() => EmployeeMissionController(), fenix: true);
    Get.lazyPut(() => LanguageChangeController(), fenix: true);
  }
}
