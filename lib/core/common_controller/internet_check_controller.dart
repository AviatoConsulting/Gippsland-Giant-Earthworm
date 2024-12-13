import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_api_utils/no_internet_msg_dialog.dart';

/// Controller to monitor and handle internet connectivity changes.
class InternetCheckController extends GetxController {
  // Observable boolean to track connection status
  RxBool isConnection = true.obs;
  StreamSubscription<ConnectivityResult>? subscription;

  /// Initializes connection check, only if there’s no existing subscription.
  initConnectionCheck() async {
    if (subscription == null) {
      // Check initial connectivity state
      await Connectivity().checkConnectivity().then((value) {
        // Update `isConnection` based on connectivity result
        isConnection(value == ConnectivityResult.wifi ||
            value == ConnectivityResult.mobile);

        // Show dialog if no internet connection
        if (!isConnection.value) {
          Get.dialog(const NoInternetMsgDialog(), barrierDismissible: false);
        }
      });

      // Listen for connectivity changes
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        switch (result) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
          case ConnectivityResult.ethernet:
          case ConnectivityResult.other:
            connectionOn(); // Call to handle restored connectivity
            break;
          case ConnectivityResult.none:
            connectionOff(); // Call to handle lost connectivity
            break;
          default:
            break;
        }
      });
    }
  }

  /// Handles actions when internet connection is restored
  connectionOn() async {
    if (!isConnection.value) {
      Get.back(); // Close the No Internet dialog
      await Get.deleteAll(force: true); // Force delete all controllers
      await Get.forceAppUpdate(); // Force update app state
    }
    isConnection(true); // Update connection state to true
    debugPrint("Connection restored: $isConnection");
  }

  /// Handles actions when internet connection is lost
  connectionOff() {
    if (isConnection.value) {
      // Show No Internet dialog when connection is lost
      Get.dialog(const NoInternetMsgDialog(), barrierDismissible: false);
    }
    isConnection(false); // Update connection state to false
    debugPrint("Connection lost: $isConnection");
  }

  /// Lifecycle method to initialize the connection check on controller init
  @override
  void onInit() {
    super.onInit();
    initConnectionCheck();
  }
}
