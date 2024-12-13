import 'package:giant_gipsland_earthworm_fe/core/bindings/auth_bindings.dart';
import 'package:giant_gipsland_earthworm_fe/core/bindings/dashboard_bindings.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_route.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/delete_user/delete_user_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/onboarding_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/sign_in_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_up/sign_up_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/splash_screen/splash_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth_gate.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/dashboard_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/how_will_my_data_use_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/about/about_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/account_setting/account_setting_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/change_password/change_password_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/edit_profile/edit_profile_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/my_worms/view/my_worms_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/resources/view/resources_screen.dart';

import 'routes_constant.dart';

//  can't use extra in get because it forgot args when web refresh
//  we can fetch extra in gorouter only
//  replace will only work in getX in goRouter it does not work

class AppRoutes {
  static final routes = [
    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                       Splash Screen Route                            //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
        name: RouteConstant.splash,
        getPage: () => const SplashScreen(),
        goRoutePage: (context, state) => const SplashScreen(),
        binding: AuthBinding()),
    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                          Auth Gate Route                             //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
        name: RouteConstant.auth,
        getPage: () => const AuthGate(),
        goRoutePage: (context, state) => const AuthGate(),
        binding: AuthBinding()),
    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                       SignIn Route                                   //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
      name: RouteConstant.signIn,
      binding: AuthBinding(),
      getPage: () {
        return const SignInScreen();
      },
      goRoutePage: (context, state) {
        return const SignInScreen();
      },
    ),

    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                     Onboarding Route                                 //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
      name: RouteConstant.onboarding,
      binding: AuthBinding(),
      getPage: () => const OnboardingScreen(),
      goRoutePage: (context, state) => const OnboardingScreen(),
    ),

    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                       SignUp Route                                   //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
      name: RouteConstant.signUp,
      binding: AuthBinding(),
      getPage: () => const SignUpScreen(),
      goRoutePage: (context, state) => const SignUpScreen(),
    ),
    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                       ForgotPass Route                               //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
      name: RouteConstant.forgotPass,
      binding: AuthBinding(),
      getPage: () => const ForgotPasswordScreen(),
      goRoutePage: (context, state) => const ForgotPasswordScreen(),
    ),
    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                     DeleteAccount Route                              //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
      name: RouteConstant.deleteAccount,
      binding: AuthBinding(),
      getPage: () => const DeleteUserScreen(),
      goRoutePage: (context, state) => const DeleteUserScreen(),
    ),
    //**********************************************************************//
    //----------------------------------------------------------------------//
    //                      Dashboard Route                                 //
    //----------------------------------------------------------------------//
    //**********************************************************************//
    CustomRoute(
        name: RouteConstant.dashboard,
        binding: DashboardBinding(),
        getPage: () => const DashboardScreen(),
        goRoutePage: (context, state) => const DashboardScreen(),
        children: [
          CustomRoute(
            name: RouteConstant.editProfile,
            binding: DashboardBinding(),
            getPage: () => const EditProfileScreen(),
            goRoutePage: (context, state) => const EditProfileScreen(),
          ),
          CustomRoute(
            name: RouteConstant.accountSetting,
            binding: DashboardBinding(),
            getPage: () => const AccountSettingScreen(),
            goRoutePage: (context, state) => const AccountSettingScreen(),
          ),
          CustomRoute(
            name: RouteConstant.about,
            binding: DashboardBinding(),
            getPage: () => const AboutScreen(),
            goRoutePage: (context, state) => const AboutScreen(),
          ),
          CustomRoute(
            name: RouteConstant.changePassword,
            binding: DashboardBinding(),
            getPage: () => const ChangePassword(),
            goRoutePage: (context, state) => const ChangePassword(),
          ),
          CustomRoute(
            name: RouteConstant.myWorms,
            binding: DashboardBinding(),
            getPage: () => const MyWormsScreen(),
            goRoutePage: (context, state) => const MyWormsScreen(),
          ),
          CustomRoute(
            name: RouteConstant.howMyDataWillUse,
            binding: DashboardBinding(),
            getPage: () => const HowWillMyDataUseScreen(),
            goRoutePage: (context, state) => const HowWillMyDataUseScreen(),
          ),
        ]),
    CustomRoute(
      name: RouteConstant.resource,
      binding: DashboardBinding(),
      getPage: () => const ResourcesScreen(),
      goRoutePage: (context, state) => const ResourcesScreen(),
    ),
  ];
}
