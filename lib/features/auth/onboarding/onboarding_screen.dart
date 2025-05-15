import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/controller/onboarding_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/widgets/onboarding_widget.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  late OnboardingController controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    controller = Get.put(OnboardingController());
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   controller.dispose();
  //   super.dispose();
  // }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNextPressed(BuildContext context) {
    if (_currentPage == controller.listOfScreenContent.length - 1) {
      // Navigate to sign-in screen
      CustomNavigationHelper.navigateTo(
        context: context,
        routeName: RouteConstant.signIn,
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: _onPageChanged,
              children: controller.listOfScreenContent
                  .map((element) => OnboardingWidget(onboardingModel: element))
                  .toList(),
            ),
          ),

          // Page Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.listOfScreenContent.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 40.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColor.primaryColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: AppConstants.screenPadding(
                androidTop: 25, iosTop: 25, context: context),
            child: Column(
              children: [
                CommonButton(
                  label:
                      _currentPage == controller.listOfScreenContent.length - 1
                          ? "Get Started"
                          : "Next",
                  onTap: () => _onNextPressed(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
