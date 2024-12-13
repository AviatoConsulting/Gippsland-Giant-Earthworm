import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordController extends GetxController with StateMixin {
  static ChangePasswordController get instance => Get.find();

  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to change the user's password
  Future<void> changePassword(
      {required String newPassword, required BuildContext context}) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        change(null, status: RxStatus.loading()); // Start loading state

        // Attempt to change the password
        await user.updatePassword(newPassword);

        if (context.mounted) {
          showCommonToast(
              context: context,
              type: ToastificationType.success,
              title: "Password changed successfully",
              description: "Login again with new password.");
        }
        if (context.mounted) {
          CommonAssets.logOutFunction(context: context); // Log out after change
        }
        change(null, status: RxStatus.success()); // Success state
      } on FirebaseAuthException catch (e) {
        String errorMessage;

        // Handle specific error cases
        if (e.code == 'requires-recent-login') {
          errorMessage =
              "This operation is sensitive and requires recent authentication. Please log in again to proceed.";
        } else if (e.code == 'wrong-password') {
          errorMessage =
              "The current password you entered is incorrect. Please try again.";
        } else {
          errorMessage =
              "An error occurred while updating the password. Please try again later.";
        }

        if (context.mounted) {
          showCommonToast(
            type: ToastificationType.error,
            context: context,
            title: "Error",
            description: errorMessage,
          );
        }
        change(null, status: RxStatus.success());
      } catch (e) {
        if (context.mounted) {
          showCommonToast(
            type: ToastificationType.error,
            context: context,
            title: "Error",
            description: "An unknown error occurred. Please try again later.",
          );
        }
        change(null, status: RxStatus.success());
      }
    }
  }

  // Method to delete the user's account
  Future<void> deleteAccount({required BuildContext context}) async {
    try {
      change(null, status: RxStatus.loading()); // Start loading state

      User? user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore
            .collection('user_details')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .delete();

        // Delete the user account
        await user.delete();

        if (context.mounted) {
          CommonAssets.logOutFunction(
              context: context); // Log out after deletion
          showCommonToast(
            context: context,
            type: ToastificationType.success,
            title: "Account Deleted",
            description: "Your account has been deleted successfully.",
          );
        }
      }
      change(null, status: RxStatus.success()); // Success state
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (context.mounted) {
          showCommonToast(
            type: ToastificationType.error,
            context: context,
            title: "Reauthentication Required",
            description:
                "This operation is sensitive and requires recent authentication. Log in again before retrying this request.",
          );
        }
        change(null, status: RxStatus.success());
      } else {
        if (context.mounted) {
          showCommonToast(
            type: ToastificationType.error,
            context: context,
            title: "Error",
            description: "Error deleting account. Please try again later.",
          );
        }
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      if (context.mounted) {
        showCommonToast(
          type: ToastificationType.error,
          context: context,
          title: "Error",
          description: "Unknown error occurred. Please try again later.",
        );
      }
      change(null, status: RxStatus.success());
    }
  }

  // Initialize state
  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }
}
