import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/model/user_model.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/common_assets.dart';

class SignUpController extends GetxController with StateMixin {
  static SignUpController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================== Variable ==================
  RxString username = "".obs;
  RxString emailID = "".obs;
  RxString password = "".obs;
  RxString confirmPassword = "".obs;

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                       Create Account Function                        //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> createAccount({required BuildContext context}) async {
    change(null, status: RxStatus.loading());
    bool userExists = await checkEmailExists(emailID.value);
    if (userExists) {
      if (context.mounted) {
        showCommonToast(
          context: context,
          title: "User Exists",
          description:
              "User already exists. Try again with different credentials.",
        );
        change(null, status: RxStatus.success());
      }
    } else {
      try {
        CommonAssets.startFunctionPrint(
            title: "Creating Account and Storing Data in Firestore");

        // Create user with email and password

        await _auth.createUserWithEmailAndPassword(
          email: emailID.value.trim(),
          password: confirmPassword.value.trim(),
        );

        await storeUserDataInFirestore(
            username: username.value.trim(), email: emailID.value.trim());

        if (context.mounted) {
          await login(context: context);
        }

        clearDate();
        CommonAssets.successFunctionPrint(
            title: "Account Created and Data Stored Successfully");
        change(null, status: RxStatus.success());
      } on FirebaseAuthException catch (e) {
        CommonAssets.errorFunctionPrint(
            statusCodeMsg: "Error Creating Account: $e");

        if (context.mounted) {
          if (e.code == 'email-already-in-use') {
            showCommonToast(
              type: ToastificationType.error,
              context: context,
              title: "Email Already In Use",
              description:
                  "The email address is already in use by another account. Please use a different email address.",
            );
          } else {
            showCommonToast(
              type: ToastificationType.error,
              context: context,
              title: "Error",
              description: "Error creating account. Please try again later.",
            );
          }
        }

        change(null, status: RxStatus.success());
      } catch (e) {
        CommonAssets.errorFunctionPrint(statusCodeMsg: "Unknown Error: $e");
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

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                         Login Function                               //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> login({required BuildContext context}) async {
    change(null, status: RxStatus.loading());
    try {
      CommonAssets.startFunctionPrint(title: "Logging In");
      // Log in user with email and password
      await _auth.signInWithEmailAndPassword(
        email: emailID.value.trim(),
        password: password.value.trim(),
      );
      CommonAssets.successFunctionPrint(title: "Login Successful");
      if (context.mounted) {
        CustomNavigationHelper.navigateTo(
            context: context, routeName: RouteConstant.auth);
        showCommonToast(
          type: ToastificationType.success,
          context: context,
          title: "Success",
          description: "Logged in successfully.",
        );
      }
      change(null, status: RxStatus.success());
      // You can navigate to the next screen or perform other actions here
    } on FirebaseAuthException catch (e) {
      CommonAssets.errorFunctionPrint(statusCodeMsg: "Error Logging In: $e");

      if (context.mounted) {
        String errorMessage = "Error logging in. Please try again.";
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
      change(null, status: RxStatus.success());
    }
  }

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                       Check User Exis or Not                         //
  //----------------------------------------------------------------------//
  //**********************************************************************//

  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_details')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Error checking email existence: $e');
      return false;
    }
  }

  Future<void> storeUserDataInFirestore({
    required String username,
    required String email,
  }) async {
    try {
      CommonAssets.startFunctionPrint(title: "Storing User Data in Firestore");

      // Create a new user model
      UserModel newUser = UserModel(
        uid: const Uuid().v4(),
        username: username,
        email: email,
        mobile: null,
        birthdate: null,
        profileImg: null,
        createdOn: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      // Store the user data in Firestore
      await FirebaseFirestore.instance
          .collection('user_details')
          .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
          .set(newUser.toMap());

      CommonAssets.successFunctionPrint(
          title: "User Data Stored Successfully in Firestore");
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: "Error Storing User Data in Firestore: $e");
    }
  }

  void clearDate() {
    username.value = "";
    emailID.value = "";
    password.value = "";
    confirmPassword.value = "";
  }

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }
}
