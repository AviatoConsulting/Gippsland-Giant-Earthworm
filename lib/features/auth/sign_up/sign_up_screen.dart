import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_social_login_container.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_textrich.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/controller/social_sign_in_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/signin_aggrement_widget.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Avoid the keyboard overlapping input fields
      body: SingleChildScrollView(
        // Make the screen scrollable
        padding: AppConstants.screenPadding(
            context: context), // Custom padding defined in constants
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text for Sign-Up
            Text("Create account", style: textTheme.headlineMedium),
            const SizedBox(height: 30),

            // Full Name Input Field
            Text("Full Name", style: textTheme.bodyLarge),
            CustomTextFormField(
              hintText: "randomly241",
              textFieldType: TextFieldType.text,
              textInputAction: TextInputAction.next,
              onChanged: (value) => controller.username.value = value,
            ),
            const SizedBox(height: 10),

            // Email Input Field
            Text("Email Id", style: textTheme.bodyLarge),
            CustomTextFormField(
              hintText: "randomly241@gmail.com",
              textInputAction: TextInputAction.next,
              textFieldType: TextFieldType.email,
              onChanged: (value) => controller.emailID.value = value,
            ),
            const SizedBox(height: 10),

            // Password Input Field
            Text("Password", style: textTheme.bodyLarge),
            CustomTextFormField(
              hintText: "Randomly@123",
              textInputAction: TextInputAction.next,
              textFieldType: TextFieldType.password,
              onChanged: (value) => controller.password.value = value,
            ),
            const SizedBox(height: 10),

            // Confirm Password Input Field
            Text("Confirm Password", style: textTheme.bodyLarge),
            CustomTextFormField(
              hintText: "Randomly@123",
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.password,
              onChanged: (value) => controller.confirmPassword.value = value,
            ),
            const SizedBox(height: 30),

            // Sign-Up Button (with validation and loading state)
            controller.obx(
                (state) => CommonButton(
                    label: "Sign Up",
                    onTap: () {
                      if (controller.username.value.isEmpty) {
                        showCommonToast(
                            context: context,
                            title: "Name Required",
                            description: "Please enter your name");
                      } else if (controller.emailID.value.isEmpty) {
                        showCommonToast(
                            context: context,
                            title: "Email Required",
                            description: "Please enter email id");
                      } else if (controller.password.value.isEmpty) {
                        showCommonToast(
                            context: context,
                            title: "Password Required",
                            description: "Please enter password");
                      } else if (controller.confirmPassword.value.isEmpty) {
                        showCommonToast(
                            context: context,
                            title: "Confirm Password Required",
                            description: "Please enter confirm password");
                      } else {
                        if (controller.password.value ==
                            controller.confirmPassword.value) {
                          controller.createAccount(context: context);
                        } else {
                          // Show toast if passwords don't match
                          showCommonToast(
                              context: context,
                              title: "Password Not Matched",
                              description:
                                  "Passwords do not match. Please check and try again.");
                        }
                      }
                    }),
                onLoading: const CustomLoader()),

            const SizedBox(height: 30),

            // Social Sign-Up Message
            Align(
              alignment: Alignment.center,
              child: Text(
                "Or sign up with",
                style: textTheme.labelLarge?.copyWith(
                  letterSpacing: 1,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Social Login Options (Google and Apple)
            SocialSignInController.instance.obx(
                (state) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Platform.isIOS
                            ? CommonSocialLoginContainer(
                                onTap: () => SocialSignInController.instance
                                    .signInWithApple(context: context)
                                    .then((value) =>
                                        CustomNavigationHelper.navigateTo(
                                            context: context,
                                            routeName: RouteConstant.auth)),
                                imgColor: Colors.black,
                                svgIMG: AppImagesConstant.appleIconSVG)
                            : const SizedBox(),
                        SizedBox(width: Platform.isIOS ? 20 : 0),
                        CommonSocialLoginContainer(
                          svgIMG: AppImagesConstant.googleIconSVG,
                          onTap: () => SocialSignInController.instance
                              .signInWithGoogle(context: context)
                              .then((value) {
                            if (context.mounted) {
                              CustomNavigationHelper.navigateTo(
                                context: context,
                                routeName: RouteConstant.auth,
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                onLoading: const CustomLoader()),

            const SizedBox(height: 20),

            // Link to Sign-In Screen (for existing users)
            Align(
              alignment: Alignment.center,
              child: CommonTextRich(
                message: "If you have any account ",
                actionText: "Sign in",
                onTap: () {
                  CustomNavigationHelper.navigateTo(
                      context: context,
                      routeName: RouteConstant.signIn,
                      replace: true);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Terms and conditions for Sign-Up
            const SignInAgreementText(isSignup: true),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
