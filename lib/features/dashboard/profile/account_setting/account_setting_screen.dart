import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX for state management and navigation
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart'; // Custom dialog widget
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart'; // Constants like padding
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart'; // Constants for image paths
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart'; // Custom navigation helper
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart'; // Custom widget for screen title
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/change_password/controller/change_password_controller.dart'; // Controller for account settings
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/widgets/profile_menu_container.dart'; // Custom widget for menu items
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart'; // Routes constants

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(
            context: context), // Custom screen padding from constants
        child: SingleChildScrollView(
          // Allows scrolling if content overflows
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Aligns children widgets to the start of the column
            children: [
              // Screen title with a back button
              const ScreenTitleWidget(title: "Account Setting", isBack: true),
              const SizedBox(height: 15),

              // Menu item for changing password
              ProfileMenuContainer(
                text: "Change Password",
                ontap: () => CustomNavigationHelper.navigateTo(
                    context: context,
                    routeName: RouteConstant
                        .changePassword), // Navigate to change password screen
              ),

              const SizedBox(height: 10),

              // Menu item for deleting account
              ProfileMenuContainer(
                  text: "Delete Account",
                  ontap: () {
                    if (InternetCheckController.instance.isConnected.value ==
                        false) {
                      showCommonToast(
                        context: context,
                        title: "Internet Connection Required",
                        description:
                            "Please connect to the internet and try again.",
                      );
                    } else {
                      Get.dialog(CommonAlertMessageDialog(
                          description:
                              "Are you sure you want to delete your account? This action cannot be undone, and all your data will be permanently removed.",
                          title: "Delete Account?",
                          icon: AppImagesConstant
                              .deleteUserIconPNG, // Icon for deletion
                          action: () {
                            Get.back(); // Close the dialog
                            ChangePasswordController
                                .instance // Call method to delete account
                                .deleteAccount(context: context);
                          }));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
