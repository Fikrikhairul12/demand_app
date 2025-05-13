import 'package:get/get.dart';

import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/applicant/bindings/applicant_binding.dart';
import '../modules/applicant/views/applicant_view.dart';
import '../modules/application/bindings/application_binding.dart';
import '../modules/application/views/application_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/license_application/bindings/license_application_binding.dart';
import '../modules/license_application/views/license_application_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/my_job/bindings/my_job_binding.dart';
import '../modules/my_job/views/my_job_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/post_job/bindings/post_job_binding.dart';
import '../modules/post_job/views/post_job_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_completion/bindings/profile_completion_binding.dart';
import '../modules/profile_completion/views/profile_completion_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_COMPLETION,
      page: () => const ProfileCompletionView(),
      binding: ProfileCompletionBinding(),
    ),
    GetPage(
      name: _Paths.POST_JOB,
      page: () => PostJobView(),
      binding: PostJobBinding(),
    ),
    GetPage(
      name: _Paths.MY_JOB,
      page: () => const MyJobView(),
      binding: MyJobBinding(),
    ),
    GetPage(
      name: _Paths.APPLICATION,
      page: () => const ApplicationView(),
      binding: ApplicationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.LICENSE_APPLICATION,
      page: () => const LicenseApplicationView(),
      binding: LicenseApplicationBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () => MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.APPLICANT,
      page: () => const ApplicantView(),
      binding: ApplicantBinding(),
    ),
  ];
}
