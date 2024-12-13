import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_text_style.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_themes.dart';
import 'package:giant_gipsland_earthworm_fe/core/utils/responsive.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/delete_user/controller/delete_user_controller.dart';

class DeleteUserScreen extends GetView<DeleteUserController> {
  static String routeName = "/delete-user";
  const DeleteUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // Adjust padding based on whether the device is mobile or larger
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.all(24.0)
            : EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: MediaQuery.of(context).size.width / 3),
        child: Column(
          children: [
            // Display logo/image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppImagesConstant.ggeCensusPNG,
                height: 100,
              ),
            ),
            const SizedBox(height: 32),

            // Title of the screen
            const Text(
              'Delete User Detail Request',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: AppThemes.font2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),

            // Email input field
            CustomTextFormField(
              onChanged: (value) => controller.email.value = value,
              hintText: "Enter email",
            ),
            const SizedBox(height: 32.0),

            // Reactive InkWell button for delete action
            controller.obx(
                (s) => InkWell(
                      onTap: () {
                        // Validate email input before proceeding
                        if (controller.email.value.isEmpty) {
                          showCommonToast(
                            context: context,
                            title: "Email Not Found",
                            description: "Please enter valid email.",
                          );
                        } else if (!controller.regex
                            .hasMatch(controller.email.value)) {
                          // If the email does not match the regex pattern
                          showCommonToast(
                            context: context,
                            title: "Invalid Email",
                            description: "Please enter a valid email address.",
                          );
                        } else {
                          // Proceed to delete user if validation is passed
                          controller.deleteUser(context: context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "Delete Account",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.f24W700.copyWith(
                              color: Colors.white,
                              fontFamily: AppThemes.font2,
                              fontSize: 24),
                        ),
                      ),
                    ),
                // Show loading indicator when in loading state
                onLoading: const CustomLoader())
          ],
        ),
      ),
    );
  }
}
