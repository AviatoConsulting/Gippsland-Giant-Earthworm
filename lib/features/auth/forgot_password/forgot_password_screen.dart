import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/controller/sign_in_controller.dart';

class ForgotPasswordScreen extends GetView<SignInController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Avoid screen overflow when the keyboard is open
      body: SingleChildScrollView(
        // Ensures the screen scrolls when the keyboard appears
        padding: AppConstants
            .screenPadding(), // Padding for the screen, can be customized globally
        child: Form(
            key: formKey, // Key to identify the form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button to navigate to the previous screen
                InkWell(
                    onTap: () => Get.back(), // Goes back to the previous screen
                    child: const Icon(Icons.arrow_back_ios, size: 25)),
                const SizedBox(height: 15),

                // Title of the screen
                Text(
                  "Forgot Password",
                  style: textTheme
                      .headlineMedium, // Applying the theme's headline style
                ),

                // Description of what the user will do next
                Text(
                  "We are sending you an email to reset your password. Please check your inbox and follow the instructions to reset your password.",
                  style: textTheme
                      .labelLarge, // Applying the theme's labelLarge style
                ),

                const SizedBox(height: 30),

                // Label and input field for email ID
                Text("Email ID", style: textTheme.bodyLarge), // Email label
                CustomTextFormField(
                  hintText: "randomly241@gmail.com", // Placeholder text
                  textFieldType:
                      TextFieldType.email, // Specifies the field type as email
                  textInputAction: TextInputAction
                      .next, // Moves to next input field when done
                  controller: controller.forgotPassEmail
                      .value, // Controller to manage email input value
                ),

                const SizedBox(height: 30),

                // Button to send password reset email
                controller.obx(
                    (state) => CommonButton(
                          label: "Send Email", // Button label
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              // Validates the form before sending the reset email
                              controller.sendPasswordResetEmail(context);
                            }
                          },
                        ),
                    onLoading:
                        const CustomLoader()), // Shows loading indicator while request is in progress
                const SizedBox(height: 30),
              ],
            )),
      ),
    );
  }
}
