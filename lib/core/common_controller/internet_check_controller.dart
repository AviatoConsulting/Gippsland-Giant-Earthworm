import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller to monitor and handle internet connectivity changes.
class InternetCheckController extends GetxController {
  static InternetCheckController get instance => Get.find();

  // Observable boolean to track connection status
  RxBool isConnected = true.obs;
  StreamSubscription<ConnectivityResult>? subscription;

  /// Initializes connection check, only if there’s no existing subscription.
  initConnectionCheck() async {
    // if (subscription == null) {
    // Check initial connectivity state
    await Connectivity().checkConnectivity().then((value) {
      // Update `isConnected` based on connectivity result
      isConnected(value == ConnectivityResult.wifi ||
          value == ConnectivityResult.mobile);

      // Show dialog if no internet connection
      // if (!isConnected.value) {
      //   Get.dialog(const NoInternetMsgDialog(), barrierDismissible: false);
      // }
    });

    // Listen for connectivity changes
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      debugPrint("value: $result");

      switch (result) {
        case ConnectivityResult.wifi:
          connectionOn(); // Call to handle restored connectivity
          break;
        case ConnectivityResult.mobile:
          connectionOn(); // Call to handle restored connectivity
          break;
        case ConnectivityResult.ethernet:
          connectionOn(); // Call to handle restored connectivity
          break;
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
    // }
  }

  /// Handles actions when internet connection is restored
  connectionOn() async {
    if (!isConnected.value) {
      Get.back(); // Close the No Internet dialog
      await Get.deleteAll(force: true); // Force delete all controllers
      await Get.forceAppUpdate(); // Force update app state
    }
    isConnected(true); // Update connection state to true
    debugPrint("Connection restored: $isConnected");
  }

  /// Handles actions when internet connection is lost
  connectionOff() {
    // if (isConnected.value) {
    //   // Show No Internet dialog when connection is lost
    //   Get.dialog(const NoInternetMsgDialog(), barrierDismissible: false);
    // }
    isConnected(false); // Update connection state to false
    debugPrint("Connection lost: $isConnected");
  }

  /// Lifecycle method to initialize the connection check on controller init
  @override
  void onInit() {
    super.onInit();
    initConnectionCheck();
  }
}
