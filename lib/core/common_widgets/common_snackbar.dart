import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

/// A utility class for displaying messages via SnackBars or Toasts,
/// with conditional behavior for web platforms.
class SnackBarMessageWidget {
  /// Displays a message as a SnackBar or Toast.
  ///
  /// - [message]: The text content of the SnackBar/Toast.
  /// - [time]: The duration to show the message (default is 3 seconds).
  /// - [buttonText]: Optional text for an action button.
  /// - [onTap]: Action to perform when the button is tapped.
  /// - [snackShowInWeb]: Set to true to show SnackBars on web, otherwise shows Toasts.
  static show(String message,
      {int? time = 3,
      String? buttonText,
      Function()? onTap,
      bool snackShowInWeb = false}) {
    // Show Toast for web unless snackShowInWeb is true
    if (kIsWeb && !snackShowInWeb) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: time!,
        backgroundColor: Theme.of(Get.context!).primaryColor,
        textColor: Colors.white,
        webShowClose: true,
        webBgColor:
            "linear-gradient(to right, #43C0B9, #64B5F6)", // Web-specific styling
        fontSize: 16.0,
      );
    } else {
      // Show SnackBar for non-web platforms or if snackShowInWeb is true
      Get.showSnackbar(
        GetSnackBar(
          message: message,
          mainButton: buttonText != null
              ? TextButton(
                  onPressed: onTap ??
                      () {}, // Executes onTap if provided, or an empty action
                  child: Text(buttonText),
                )
              : const SizedBox(), // Show button only if buttonText is specified
          isDismissible: true,
          duration: Duration(seconds: time ?? 3), // Display duration
        ),
      );
    }
  }
}
