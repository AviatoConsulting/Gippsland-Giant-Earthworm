import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(DashboardController());
  }

  @override
  Widget build(BuildContext context) {
    const double selectedIconsize = 26;
    const double unSelectedIconsize = 20;

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(context: context),
        child: Obx(
          () => controller.pages[controller.currentPageIndex.value],
        ),
      ),
      bottomNavigationBar: Obx(
        () => AnimatedContainer(
          padding: const EdgeInsets.only(right: 16, left: 16),
          duration: const Duration(milliseconds: 400),
          height: kBottomNavigationBarHeight,
          child: Wrap(
            children: [
              Theme(
                data: ThemeData(splashColor: Colors.transparent),
                child: BottomNavigationBar(
                  backgroundColor:
                      Get.isDarkMode ? Colors.transparent : Colors.white,
                  onTap: (index) {
                    controller.currentPageIndex.value = index;
                  },
                  showSelectedLabels: true,
                  currentIndex: controller.currentPageIndex.value,
                  showUnselectedLabels: true,
                  enableFeedback: false,
                  elevation: 0,
                  useLegacyColorScheme: false,
                  selectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        AppImagesConstant.homeIconSVG,
                        height: controller.currentPageIndex.value == 0
                            ? selectedIconsize
                            : unSelectedIconsize,
                        width: controller.currentPageIndex.value == 0
                            ? selectedIconsize
                            : unSelectedIconsize,
                        color: controller.currentPageIndex.value == 0
                            ? AppColor.primaryColor
                            : Colors.black54,
                      ),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        AppImagesConstant.createIconSVG,
                        height: controller.currentPageIndex.value == 1
                            ? selectedIconsize
                            : unSelectedIconsize,
                        width: controller.currentPageIndex.value == 1
                            ? selectedIconsize
                            : unSelectedIconsize,
                        color: controller.currentPageIndex.value == 1
                            ? AppColor.primaryColor
                            : Colors.black54,
                      ),
                      label: "Add Worm",
                    ),
                    // if (InternetCheckController
                    // .instance.isConnection.value) ...[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        AppImagesConstant.resourcesIconSVG,
                        height: controller.currentPageIndex.value == 2
                            ? selectedIconsize
                            : unSelectedIconsize,
                        width: controller.currentPageIndex.value == 2
                            ? selectedIconsize
                            : unSelectedIconsize,
                        color: controller.currentPageIndex.value == 2
                            ? AppColor.primaryColor
                            : Colors.black54,
                      ),
                      label: "Resources",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        AppImagesConstant.profileIconSVG,
                        height: controller.currentPageIndex.value == 3
                            ? selectedIconsize
                            : unSelectedIconsize,
                        width: controller.currentPageIndex.value == 3
                            ? selectedIconsize
                            : unSelectedIconsize,
                        color: controller.currentPageIndex.value == 3
                            ? AppColor.primaryColor
                            : Colors.black54,
                      ),
                      label: "Profile",
                    ),
                    // ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
