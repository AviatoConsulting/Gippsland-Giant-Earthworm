import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double iconsize = 24; // Define icon size for BottomNavigationBar
    ScrollController scrollController =
        ScrollController(); // Controller to detect scroll position
    RxBool isBottomBarVisible =
        true.obs; // Reactive variable to manage visibility of BottomNavBar

    // Detect scrolling direction
    scrollController.addListener(() {
      // Hide bottom bar when scrolling down
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isBottomBarVisible.value = false;
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // Show bottom bar when scrolling up
        isBottomBarVisible.value = true;
      }
    });

    return Scaffold(
        body: Padding(
          padding: AppConstants.screenPadding(), // Padding for the body content
          child: Obx(() => SingleChildScrollView(
                controller:
                    scrollController, // Attach the scroll controller to the scroll view
                child: controller.pages[controller
                    .currentPageIndex.value], // Display the current page
              )),
        ),
        bottomNavigationBar: Obx(
          () => AnimatedContainer(
            // Animated container for the BottomNavigationBar, with smooth transition
            duration: const Duration(milliseconds: 400),
            height: isBottomBarVisible.value
                ? kBottomNavigationBarHeight
                : 0, // Hide or show bottom bar
            child: Wrap(
              children: [
                Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent, // Disable splash color
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Get.isDarkMode
                        ? Colors.transparent
                        : Colors.white, // Background color based on theme
                    onTap: (index) {
                      controller.currentPageIndex.value =
                          index; // Update current page index on tab click
                    },
                    showSelectedLabels: true, // Show labels for selected items
                    currentIndex: controller
                        .currentPageIndex.value, // Current selected index
                    showUnselectedLabels:
                        true, // Show labels for unselected items
                    enableFeedback: false, // Disable haptic feedback
                    elevation: 0, // No elevation for the bottom bar
                    useLegacyColorScheme: false,
                    selectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.primaryColor, // Color for selected label
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Get.isDarkMode
                          ? Colors.white
                          : Colors.black, // Color for unselected labels
                    ),
                    type: BottomNavigationBarType
                        .fixed, // Fixed type for the bottom bar
                    items: [
                      // First item - Home
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppImagesConstant.homeIconSVG,
                          height: iconsize,
                          width: iconsize,
                          color: controller.currentPageIndex.value == 0
                              ? AppColor
                                  .primaryColor // Change color when selected
                              : const Color(0XFF999693), // Default color
                        ),
                        label: "Home", // Label for Home
                      ),
                      // Second item - Add Worm
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppImagesConstant.createIconSVG,
                          height: iconsize,
                          width: iconsize,
                          color: controller.currentPageIndex.value == 1
                              ? AppColor
                                  .primaryColor // Change color when selected
                              : const Color(0XFF999693), // Default color
                        ),
                        label: "Add Worm", // Label for Add Worm
                      ),
                      // Third item - Resources
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppImagesConstant.resourcesIconSVG,
                          height: iconsize,
                          width: iconsize,
                          color: controller.currentPageIndex.value == 2
                              ? AppColor
                                  .primaryColor // Change color when selected
                              : const Color(0XFF999693), // Default color
                        ),
                        label: "Resources", // Label for Resources
                      ),
                      // Fourth item - Profile
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppImagesConstant.profileIconSVG,
                          height: iconsize,
                          width: iconsize,
                          color: controller.currentPageIndex.value == 3
                              ? AppColor
                                  .primaryColor // Change color when selected
                              : const Color(0XFF999693), // Default color
                        ),
                        label: "Profile", // Label for Profile
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
