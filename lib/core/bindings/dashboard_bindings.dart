import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/controller/onboarding_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/location_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/home_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/change_password/controller/change_password_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/my_worms/controller/my_worm_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';
import "package:giant_gipsland_earthworm_fe/features/dashboard/resources/controller/resources_controller.dart";

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetCheckController(), permanent: true);
    Get.lazyPut(() => DashboardController, fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => AddWormsController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => MyWormsControllers(), fenix: true);
    Get.lazyPut(() => ResourcesController(), fenix: true);
    Get.lazyPut(() => OnboardingController(), fenix: true);
  }
}
