import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/controller/onboarding_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/widgets/onboarding_widget.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The PageView allows for swiping between onboarding screens
              Expanded(
                child: PageView(
                  controller: controller
                      .pageController, // Controls the page view navigation
                  physics:
                      const ClampingScrollPhysics(), // Prevents overscrolling
                  onPageChanged: (value) => controller.currentPage.value =
                      value, // Updates the current page index
                  children: controller.listOfScreenContent
                      .map((element) => OnboardingWidget(
                          onboardingModel:
                              element)) // Displays onboarding content
                      .toList(),
                ),
              ),

              // Indicator dots to show which page of the onboarding the user is on
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Obx(() => AnimatedContainer(
                        duration: const Duration(
                            milliseconds:
                                300), // Smooth animation when changing
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: controller.currentPage.value == index
                            ? 40.0
                            : 8.0, // Adjust dot size based on page
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index
                              ? AppColor.primaryColor // Active dot color
                              : Colors.grey, // Inactive dot color
                          borderRadius: BorderRadius.circular(
                              4.0), // Rounded corners for the dots
                        ),
                      ));
                }),
              ),

              // Padding for the button at the bottom of the screen
              Padding(
                padding: AppConstants.screenPadding(androidTop: 25, iosTop: 25),
                child: Column(
                  children: [
                    // Button changes text and action based on current page
                    Obx(() => CommonButton(
                          label: controller.currentPage.value ==
                                  controller.listOfScreenContent.length - 1
                              ? "Get Started" // Label for the last page
                              : "Next", // Label for intermediate pages
                          onTap: () {
                            if (controller.currentPage.value ==
                                controller.listOfScreenContent.length - 1) {
                              // If on the last page, navigate to the SignIn screen
                              CustomNavigationHelper.navigateTo(
                                context: context,
                                routeName: RouteConstant.signIn,
                              );
                            } else {
                              // Otherwise, move to the next page in the onboarding sequence
                              controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            }
                          },
                        )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
