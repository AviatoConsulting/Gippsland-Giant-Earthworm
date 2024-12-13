import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class DeleteUserController extends GetxController with StateMixin {
  static DeleteUserController get instance => Get.find();

  RxString email = "".obs;
  final regex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                      Delete User Function                            //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> deleteUser({required BuildContext context}) async {
    change(null, status: RxStatus.loading());
    bool userExists =
        await SignUpController.instance.checkEmailExists(email.value);
    const String baseUrl =
        'https://gg-earthworm-base-gm34iwks4q-ts.a.run.app/b/delete_user_data/sent_delete_request/v2';
    final Uri url = Uri.parse('$baseUrl?email=${email.value}');

    if (userExists) {
      try {
        // Send DELETE request with a 1-minute timeout
        final response =
            await http.delete(url).timeout(const Duration(minutes: 1));

        if (response.statusCode == 200) {
          jsonDecode(response.body);

          if (context.mounted) {
            showCommonToast(
              context: context,
              type: ToastificationType.success,
              title: "Success",
              description:
                  "Email sent to your inbox. Please follow the link to delete your account.",
            );
          }
          change(null, status: RxStatus.success());
        } else {
          if (context.mounted) {
            handleResponse(response, context);
          }

          change(null, status: RxStatus.success());
        }
      } on SocketException {
        debugPrint(
            "Network Error: Unable to connect to the server. Please check your internet connection.");
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Network Error",
            description:
                "Unable to connect to the server. Please check your internet connection.",
          );
        }
        change(null, status: RxStatus.success());
      } on TimeoutException {
        debugPrint(
            "Request Timeout: The server took too long to respond. Please try again later.");
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Request Timeout",
            description:
                "The server took too long to respond. Please try again later.",
          );
        }
        change(null, status: RxStatus.success());
      } on FormatException {
        debugPrint("Data Parsing Error: Failed to decode the server response.");
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Data Parsing Error",
            description:
                "There was a problem decoding the server response. Please try again later.",
          );
        }
        change(null, status: RxStatus.success());
      } catch (error) {
        debugPrint("Unexpected Error: $error");
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Unexpected Error",
            description: "An unexpected error occurred. Please try again.",
          );
        }
        change(null, status: RxStatus.success());
      }
    } else {
      if (context.mounted) {
        showCommonToast(
          context: context,
          title: "User Not Found!",
          description:
              "No account found with that email. Please create a new account and try again.",
        );
        change(null, status: RxStatus.success());
      }
    }
  }

  // Function to handle response based on status code
  void handleResponse(http.Response response, BuildContext context) {
    String message;

    switch (response.statusCode) {
      case 400:
        message = "Bad Request: Please verify the email and try again.";
        break;
      case 401:
        message = "Unauthorized: Please log in and try again.";
        break;
      case 404:
        message =
            "Not Found: Unable to locate the specified endpoint. Please contact support.";
        break;
      case 500:
        message =
            "Server Error: An error occurred on the server. Please try again later.";
        break;
      default:
        message =
            "Unexpected Error: Received status code ${response.statusCode}.";
        break;
    }

    debugPrint("Response: ${response.body}");
    debugPrint("Status Code: ${response.statusCode}");

    // Show toast for the error
    showCommonToast(
      context: context,
      title: "Error ${response.statusCode}",
      description: message,
    );
  }

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }
}
