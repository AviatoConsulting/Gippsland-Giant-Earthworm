import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/delete_user/controller/delete_user_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/controller/onboarding_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/controller/sign_in_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/controller/social_sign_in_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_up/controller/sign_up_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetCheckController(), permanent: true);

    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => DeleteUserController(), fenix: true);
    Get.lazyPut(() => SocialSignInController(), fenix: true);
    Get.lazyPut(() => OnboardingController(), fenix: true);
  }
}
