import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/widgets/profile_menu_container.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // Access the theme's text styles

    return controller.obx(
        (state) => Column(
              // This widget will update based on the controller's state
              children: [
                const ScreenTitleWidget(title: "Profile"), // Screen title
                const SizedBox(
                    height: 15), // Space between title and profile info
                Column(
                  children: [
                    // Profile Image Section
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(100), // Circular border
                            border: Border.all(
                                color: (controller.fetchedUserData.value
                                            .profileImg?.isEmpty ??
                                        true)
                                    ? AppColor
                                        .primaryColor // Default border color if no image
                                    : Colors
                                        .transparent)), // Transparent if image is available
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(100), // Circular clipping
                          child: CommonAssets.getGCSNetworkImage(
                              controller.fetchedUserData.value.profileImg ?? "",
                              AppImagesConstant.profilePNG,
                              height: 120, // Profile image size
                              width: 120,
                              fit: BoxFit
                                  .cover), // Ensures image covers the container
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Display Username and Email
                    Text(
                      controller.fetchedUserData.value.username,
                      style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400), // Username styling
                    ),
                    const SizedBox(height: 5),
                    Text(
                      controller.fetchedUserData.value.email,
                      style: textTheme.bodyLarge, // Email styling
                    ),
                    const SizedBox(height: 20),
                    // Profile Menu for GGE Records
                    ProfileMenuContainer(
                      text: "My GGE Records",
                      ontap: () => CustomNavigationHelper.navigateTo(
                          context: context, routeName: RouteConstant.myWorms),
                    ),
                    const SizedBox(height: 15),
                    // Profile Menu for Edit Profile
                    ProfileMenuContainer(
                      text: "Edit Profile",
                      ontap: () => CustomNavigationHelper.navigateTo(
                          context: context,
                          routeName: RouteConstant.editProfile),
                    ),
                    const SizedBox(height: 15),
                    // Profile Menu for Account Settings
                    ProfileMenuContainer(
                      text: "Account Setting",
                      ontap: () => CustomNavigationHelper.navigateTo(
                          context: context,
                          routeName: RouteConstant.accountSetting),
                    ),
                    const SizedBox(height: 15),
                    // Profile Menu for Reporting Problems
                    ProfileMenuContainer(
                      text: "Report Problem",
                      ontap: () => Get.dialog(CommonAlertMessageDialog(
                          title: "Report a Problem",
                          description:
                              "If you face any issues while using our app, please feel free to contact us directly at:",
                          buttonText: "Email Us",
                          action: () {
                            launchUrl(Uri.parse(
                                "mailto:${controller.supportEmail.value}"));
                          },
                          child: InkWell(
                            onTap: () => CommonAssets.copyToClipboard(
                                controller.supportEmail.value),
                            child: Text(
                              "${controller.supportEmail.value}.", // Display email
                              textAlign: TextAlign.center,
                              style: textTheme.titleSmall?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.primaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.primaryColor),
                            ),
                          ))),
                    ),
                    const SizedBox(height: 15),
                    // Profile Menu for About Us page
                    ProfileMenuContainer(
                      text: "About Us",
                      ontap: () => CustomNavigationHelper.navigateTo(
                          context: context, routeName: RouteConstant.about),
                    ),
                    const SizedBox(height: 15),
                    // Profile Menu for Logout
                    ProfileMenuContainer(
                      text: "Log Out",
                      ontap: () => Get.dialog(CommonAlertMessageDialog(
                          title: "Log Out?",
                          description:
                              "Are you sure you want to log out? You will need to log in again to access your account.",
                          buttonText: "Log Out",
                          action: () {
                            CommonAssets.logOutFunction(
                                context: context); // Logs out the user
                          })),
                    ),
                  ],
                ),
              ],
            ),
        onLoading:
            const CustomLoader()); // Show loader while fetching user data
  }
}
