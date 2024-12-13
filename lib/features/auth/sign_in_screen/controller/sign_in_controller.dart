import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';
import 'package:toastification/toastification.dart';

class SignInController extends GetxController with StateMixin {
  static SignInController get instance => Get.find();

  // ================== Variables ==================
  RxString password = "".obs; // Stores the password entered by the user
  RxString emailID = "".obs; // Stores the email ID entered by the user
  Rx<TextEditingController> forgotPassEmail =
      TextEditingController().obs; // Stores email for password reset
  final auth = FirebaseAuth.instance; // Firebase authentication instance

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                         Login Function                               //
  //----------------------------------------------------------------------//
  //**********************************************************************//

  // Logs in the user by authenticating with Firebase using email and password
  Future<void> login({required BuildContext context}) async {
    change(null, status: RxStatus.loading()); // Shows loading state
    bool userExists =
        await SignUpController.instance.checkEmailExists(emailID.value);

    if (userExists) {
      try {
        CommonAssets.startFunctionPrint(title: "Logging In");

        // Log in user with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailID.value.trim(),
          password: password.value.trim(),
        );

        CommonAssets.successFunctionPrint(title: "Login Successful");

        // Navigate to next screen if login is successful
        if (context.mounted) {
          CustomNavigationHelper.navigateTo(
            context: context,
            routeName:
                RouteConstant.auth, // Navigate to the main/authenticated screen
          );
          showCommonToast(
            type: ToastificationType.success,
            context: context,
            title: "Success",
            description: "Logged in successfully.",
          );
        }

        change(null, status: RxStatus.success()); // Change state to success
      } on FirebaseAuthException catch (e) {
        // Handle login errors
        CommonAssets.errorFunctionPrint(statusCodeMsg: "Error Logging In: $e");

        if (context.mounted) {
          String errorMessage = "Error logging in. Please try again.";

          // Customize error message based on the error code
          if (e.code == 'invalid-credential') {
            errorMessage = "Invalid password. Please try again.";
          } else if (e.code == 'user-not-found') {
            errorMessage = "User not found. Please check your credentials.";
          }

          showCommonToast(
            type: ToastificationType.error,
            context: context,
            title: "Error",
            description: errorMessage,
          );
        }
        change(null,
            status: RxStatus
                .success()); // Change state to success after handling error
      }
    } else {
      // If user doesn't exist, show a message asking them to create an account
      if (context.mounted) {
        showCommonToast(
          context: context,
          title: "User Not Found!",
          description: "Create a new account and try again.",
        );
        change(null, status: RxStatus.success());
      }
    }
  }

  // Sends a password reset email to the user
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    bool userExists = await SignUpController.instance
        .checkEmailExists(forgotPassEmail.value.text.trim());

    if (userExists) {
      try {
        await auth.sendPasswordResetEmail(
            email: forgotPassEmail.value.text.trim());
        if (context.mounted) {
          showCommonToast(
            context: context,
            type: ToastificationType.success,
            title: "Email Sent",
            description:
                "An email has been sent to you to reset your password. Please check your inbox.",
          );
        }
        CommonAssets.successFunctionPrint(title: "Password reset email sent.");
        forgotPassEmail.value
            .clear(); // Clear the email field after sending the email
        Get.back(); // Close the password reset screen
      } catch (e) {
        // Handle any errors while sending the reset email
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Error",
            description: "Failed to send password reset email.",
          );
        }
        CommonAssets.errorFunctionPrint(
            statusCodeMsg: "Failed to send password reset email: $e");
        rethrow; // Propagate the error to handle further
      }
    } else {
      // If user doesn't exist, show a message
      if (context.mounted) {
        showCommonToast(
          context: context,
          title: "User Not Found!",
          description: "Create a new account and try again.",
        );
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    change(null,
        status: RxStatus
            .success()); // Initial state set to success when the controller is initialized
  }
}
