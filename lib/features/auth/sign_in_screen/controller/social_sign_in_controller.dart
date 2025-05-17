import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class SocialSignInController extends GetxController with StateMixin {
  static SocialSignInController get instance => Get.find();

  // SignIn with Google
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      change(null, status: RxStatus.loading()); // Set loading state

      // Attempt to sign in with Google
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      // Handle case where user cancels sign-in
      if (googleUser == null) {
        change(null,
            status: RxStatus.success()); // Set success state (no sign-in)
        return;
      }

      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        final bool isExists = await SignUpController.instance
            .checkEmailExists(value.user?.email ?? "");
        if (!isExists) {
          await SignUpController.instance.storeUserDataInFirestore(
            username: googleUser.email.split("@")[0],
            email: googleUser.email,
          );
        }
        change(null,
            status:
                RxStatus.success()); // Set success state after successful login
      });
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      CommonAssets.errorFunctionPrint(statusCodeMsg: e.toString());
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "Error",
            description: "Something went wrong, please try again later.");
      }
      change(null,
          status: RxStatus.success()); // Set success state after error handling
      rethrow;
    } catch (e) {
      // Handle other exceptions
      CommonAssets.errorFunctionPrint(statusCodeMsg: e.toString());
      change(null, status: RxStatus.error()); // Set error state
    }
  }

  // // SignIn with Facebook
  // Future<void> signInWithFacebook({required BuildContext context}) async {
  //   try {
  //     change(null, status: RxStatus.loading()); // Set loading state

  //     // Trigger Facebook login
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     // Handle successful login
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(accessToken.tokenString);

  //       // Sign in with Firebase using Facebook credentials
  //       await FirebaseAuth.instance
  //           .signInWithCredential(credential)
  //           .then((value) async {
  //         final bool isExists = await SignUpController.instance
  //             .checkEmailExists(value.user?.email ?? "");
  //         if (!isExists) {
  //           await SignUpController.instance.storeUserDataInFirestore(
  //             username: value.user?.email?.split("@")[0] ?? '',
  //             email: value.user?.email ?? '',
  //           );
  //         }
  //         change(null, status: RxStatus.success()); // Set success state
  //       });
  //     } else if (result.status == LoginStatus.cancelled) {
  //       change(null,
  //           status: RxStatus.success()); // Set success if user cancels login
  //     } else {
  //       debugPrint('Facebook login failed: ${result.status}');
  //       change(null, status: RxStatus.success());
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // Handle Firebase authentication exceptions
  //     CommonAssets.errorFunctionPrint(statusCodeMsg: e.toString());
  //     if (context.mounted) {
  //       showCommonToast(
  //           context: context,
  //           title: "Error",
  //           description: "Something went wrong, please try again later.");
  //     }
  //     change(null, status: RxStatus.success());
  //     rethrow;
  //   } catch (e) {
  //     // Handle other exceptions
  //     CommonAssets.errorFunctionPrint(statusCodeMsg: e.toString());
  //     change(null, status: RxStatus.error()); // Set error state
  //   }
  // }

  // SignIn with Apple
  signInWithApple({required BuildContext context}) async {
    try {
      // Request Apple Sign-In credentials
      final result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleCredential = result.credential;
          final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleCredential!.identityToken!),
            accessToken:
                String.fromCharCodes(appleCredential.authorizationCode!),
          );

          // Sign in to Firebase with Apple credentials
          final res =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final bool isExists = await SignUpController.instance
              .checkEmailExists(res.user?.email ?? "");
          if (!isExists) {
            await SignUpController.instance.storeUserDataInFirestore(
              username: (res.user?.email ?? "").split("@")[0],
              email: res.user?.email ?? "",
            );
          }
          change(null, status: RxStatus.success()); // Set success state

          break;

        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );
        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_CANCELLED',
            message: 'User cancelled the sign-in process',
          );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "Error",
            description: "Something went wrong, please try again later.");
      }
      rethrow;
    }
  }

  @override
  void onInit() {
    super.onInit();
    change(null,
        status: RxStatus
            .success()); // Set success state when the controller is initialized
  }
}
