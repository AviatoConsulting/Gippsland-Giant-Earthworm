import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // Text styling for consistency

    return Scaffold(
      body: controller.obx(
          // Reacts to the controller state and shows either the content or loading state
          (state) => Padding(
                padding: AppConstants
                    .screenPadding(), // Padding based on app constants
                child: SingleChildScrollView(
                  // Enables scrolling for smaller screens
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns content to the start
                    children: [
                      const ScreenTitleWidget(
                          title: "Edit Profile",
                          isBack: true), // Title with back button
                      const SizedBox(height: 15),

                      // Displaying profile image section with user image or default
                      Obx(() => Center(
                            child: SizedBox(
                              height: 115,
                              width: 115,
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  // Check if a new image is selected or use the fetched/default image
                                  controller.isProfileImageSelected.value
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              100), // Circular image
                                          child: Image.file(
                                            File(controller.selectedImage
                                                .value), // Selected image
                                            fit: BoxFit
                                                .cover, // Ensures image covers the area
                                          ),
                                        )
                                      : (controller.fetchedUserData.value
                                                  .profileImg?.isEmpty ??
                                              true)
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  100), // Default image if none exists
                                              child: Image.asset(
                                                AppImagesConstant.profilePNG,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CommonAssets
                                                  .getGCSNetworkImage(
                                                controller.fetchedUserData.value
                                                        .profileImg ??
                                                    "",
                                                AppImagesConstant.profilePNG,
                                                fit: BoxFit.cover,
                                                height: 115,
                                                width: 115,
                                              ),
                                            ),
                                  Positioned(
                                    bottom: -10,
                                    right: -25,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        controller.pickImg(
                                            context:
                                                context); // Open image picker
                                      },
                                      elevation: 2.0,
                                      fillColor:
                                          AppColor.primaryColor, // Button style
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),

                      const SizedBox(height: 10),
                      // Centered user information display (username and email)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              controller.fetchedUserData.value.username,
                              style: textTheme.headlineMedium?.copyWith(
                                  fontWeight:
                                      FontWeight.w400), // Username styling
                            ),
                            const SizedBox(height: 5),
                            Text(
                              controller.fetchedUserData.value.email,
                              style: textTheme.bodyLarge, // Email styling
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name input field
                      Text("Full Name",
                          style:
                              textTheme.bodyLarge), // Label for Full Name field
                      CustomTextFormField(
                        hintText:
                            "Randomly@123", // Placeholder for username input
                        textFieldType: TextFieldType.text,
                        controller: controller.usernameController
                            .value, // Text controller for input field
                      ),
                      const SizedBox(height: 20),

                      // Update button that triggers the username update process
                      CommonButton(
                        label: "Update", // Button label
                        onTap: () {
                          // Validate if username is not empty before updating
                          if (controller
                              .usernameController.value.text.isEmpty) {
                            showCommonToast(
                                context: context,
                                title: "Username Missing",
                                description:
                                    "Please enter valid username to continue.");
                          } else {
                            controller.updateUserDetails(
                                context: context); // Update profile details
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
          onLoading:
              const CustomLoader()), // Show loading spinner while data is being fetched
    );
  }
}
