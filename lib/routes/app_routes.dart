import 'package:allo_taf/features/authentication/presentation/screen/signup_verification_screen.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/screen/buy_plan_pay_screen.dart';
import 'package:allo_taf/features/employee/employee_home/presentation/screen/pay_confirm_screen.dart';
import 'package:allo_taf/features/employee/employee_missions/presentation/screen/employee_mission_job_details.dart';
import 'package:allo_taf/features/employee/employee_profile/presentation/screen/employee_edit_profile.dart';
import 'package:allo_taf/features/recruiter/recruiter_mission/presentation/screen/mission_edit_screen.dart';
import 'package:allo_taf/features/recruiter/recruiter_mission/presentation/screen/recruiter_job_details_screen.dart';
import 'package:allo_taf/features/recruiter/recruiter_profile/presentation/screen/recruiter_edit_profile_screen.dart';
import 'package:get/get.dart';

import '../features/authentication/binding/auth_binding.dart';
import '../features/authentication/presentation/screen/login_screen.dart';
import '../features/authentication/presentation/screen/recruiter_signup_screen.dart';
import '../features/authentication/presentation/screen/role_selection_screen.dart';
import '../features/authentication/presentation/screen/signup_screen.dart';
import '../features/authentication/presentation/screen/verification_screen.dart';
import '../features/employee/employee_nav/employee_nav.dart';
import '../features/employee/employee_profile/presentation/screen/employee_my_profile_screen.dart';
import '../features/recruiter/recruiter_home/presentation/screen/recruiter_employee_profile_screen.dart';
import '../features/recruiter/recruiter_home/presentation/screen/recruiter_leave_a_review_screen.dart';
import '../features/recruiter/recruiter_home/presentation/screen/recruiter_payment_confirm_screen.dart';
import '../features/recruiter/recruiter_home/presentation/screen/recruiter_subscription_buy_screen.dart';
import '../features/recruiter/recruiter_home/presentation/screen/view_all_reviews_screen.dart';
import '../features/recruiter/recruiter_mission/presentation/screen/recruiter_mission_published_screen.dart';
import '../features/recruiter/recruiter_nav/recruiter_nav.dart';
import '../features/splash/presentation/screen/splash_screen.dart';

class AppRoutes {
  ///Add by Lisan
  static const String init = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/role_selection';
  static const String verifyOtp = '/verify_otp';
  static const String employeeNav = '/employee_nav';
  static const String recruiterNav = '/recruiter_nav';
  static const String recruiterEmployeeProfileScreen =
      '/recruiter_employee_profile_screen';
  static const String recruiterLeaveAReviewScreen =
      '/recruiter_leave_a_review_screen';
  static const String recruiterMissionPublishedScreen =
      '/recruiter_mission_published_screen';
  static const String recruiterJobDetailsScreen =
      '/recruiter_job_details_screen';
  static const String recruiterEditProfileScreen =
      '/recruiter_edit_profile_screen';
  static const String employeeMyProfileScreen = '/employee_my_profile_screen';
  static const String recruiterSignup = '/recruiter_signup';
  static const String recruiterSubscriptionBuyScreen =
      '/recruiter_subscription_buy_screen';
  static const String recruiterPaymentConfirmScreen =
      '/recruiter_payment_confirm_screen';
  static const String signupVerificationScreen = '/signup_verification_screen';
  static const String missionEditingScreen = '/mission_editing_screen';
  static const String viewAllReviews = '/view_all_reviews';

  ///Add by Lisan end

  /// Add by Rabbi
  static const String employeeBuyPlan = '/employeeBuyPlan';
  static const String employeePlanConfirm = '/employeePlanConfirm';
  static const String employeeJobDetails = '/employeeJobDetails';
  static const String employeeEditProfile = '/employeeEditProfile';

  //----END

  static final List<GetPage> pages = [
    GetPage(name: init, page: () => const SplashScreen()),
    GetPage(name: login, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(name: signup, page: () => SignupScreen(), binding: AuthBinding()),
    GetPage(
      name: roleSelection,
      page: () => RoleSelectionScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: verifyOtp,
      page: () => VerificationScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: signupVerificationScreen,
      page: () => SignupVerificationScreen(),
      binding: AuthBinding(),
    ),
    GetPage(name: employeeNav, page: () => EmployeeNav()),
    GetPage(name: recruiterNav, page: () => RecruiterNav()),
    GetPage(
      name: recruiterEmployeeProfileScreen,
      page: () => RecruiterEmployeeProfileScreen(),
    ),
    GetPage(
      name: recruiterLeaveAReviewScreen,
      page: () => RecruiterLeaveAReviewScreen(),
    ),
    GetPage(
      name: recruiterMissionPublishedScreen,
      page: () => RecruiterMissionPublishedScreen(),
    ),
    GetPage(
      name: recruiterJobDetailsScreen,
      page: () => RecruiterJobDetailsScreen(),
    ),
    GetPage(
      name: recruiterEditProfileScreen,
      page: () => RecruiterEditProfileScreen(),
    ),

    GetPage(
      name: employeeMyProfileScreen,
      page: () => EmployeeMyProfileScreen(),
    ),
    GetPage(name: recruiterSignup, page: () => RecruiterSignupScreen()),
    GetPage(
      name: recruiterSubscriptionBuyScreen,
      page: () => RecruiterSubscriptionBuyScreen(),
    ),
    GetPage(
      name: recruiterPaymentConfirmScreen,
      page: () => RecruiterPaymentConfirmScreen(),
    ),
    GetPage(
      name: missionEditingScreen,
      page: () => RecruiterMissionEditScreen(),
    ),
    GetPage(name: viewAllReviews, page: () => ViewAllReviewsScreen()),

    /// Added by Rabbi
    GetPage(name: employeeBuyPlan, page: () => BuyPlanPayScreen()),
    GetPage(name: employeePlanConfirm, page: () => PayConfirmScreen()),
    GetPage(name: employeeJobDetails, page: () => EmployeeMissionJobDetails()),
    GetPage(name: employeeEditProfile, page: () => EmployeeEditProfile()),
  ];
}
