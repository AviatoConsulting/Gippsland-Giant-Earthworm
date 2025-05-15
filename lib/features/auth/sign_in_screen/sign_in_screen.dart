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
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/controller/sign_in_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_in_screen/controller/social_sign_in_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/signin_aggrement_widget.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Avoid keyboard overlap on input fields
      body: SingleChildScrollView(
        // Make the screen scrollable
        padding: AppConstants.screenPadding(
            context: context), // Custom screen padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header text
            Text("Welcome back!", style: textTheme.headlineMedium),
            const SizedBox(height: 30),

            // Email field label and input
            Text("Email Id", style: textTheme.bodyLarge),
            CustomTextFormField(
              hintText: "randomly241@gmail.com",
              textFieldType: TextFieldType.email,
              textInputAction: TextInputAction.next,
              onChanged: (value) => controller.emailID.value = value,
            ),
            const SizedBox(height: 10),

            // Password field label and input
            Text("Password", style: textTheme.bodyLarge),
            CustomTextFormField(
              hintText: "Randomly@123",
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.password,
              onChanged: (value) => controller.password.value = value,
            ),
            const SizedBox(height: 10),

            // Forgot password link
            InkWell(
              onTap: () => CustomNavigationHelper.navigateTo(
                  context: context, routeName: RouteConstant.forgotPass),
              child: Align(
                alignment: Alignment.topRight,
                child: Text("Forgot password?",
                    style: textTheme.labelLarge?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w400)),
              ),
            ),
            const SizedBox(height: 30),

            // Login button (show loading while waiting)
            controller.obx(
                (state) => CommonButton(
                      label: "Sign In",
                      onTap: () {
                        if (controller.emailID.value.isEmpty) {
                          showCommonToast(
                              context: context,
                              title: "Email Required",
                              description: "Please enter email id");
                        } else if (controller.password.value.isEmpty) {
                          showCommonToast(
                              context: context,
                              title: "Password Required",
                              description: "Please enter password");
                        } else {
                          controller.login(context: context);
                        }
                      },
                    ),
                onLoading: const CustomLoader()),
            const SizedBox(height: 30),

            // Divider message with options to sign up with social media
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

            // Social login buttons (Apple and Google)
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
                            : const SizedBox(), // Show only on iOS
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

            // Sign up prompt link
            Align(
              alignment: Alignment.center,
              child: CommonTextRich(
                message: "Don’t have any account? ",
                actionText: "Sign up",
                onTap: () {
                  CustomNavigationHelper.navigateTo(
                      context: context,
                      routeName: RouteConstant.signUp,
                      replace: true);
                },
              ),
            ),
            const SizedBox(height: 30),

            // Sign-In agreement text at the bottom
            const SignInAgreementText(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
