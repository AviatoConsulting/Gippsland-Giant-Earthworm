import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_snackbar.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';

class LocationController extends GetxController with StateMixin {
  static LocationController get instance =>
      Get.find(); // Singleton instance of LocationController

  Position?
      currentPosition; // Holds the current position (latitude and longitude)
  RxList<Placemark> placemarks = <Placemark>[]
      .obs; // List to hold the address details obtained from coordinates

  // Private method to handle location permission requests and checks
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show a snack bar if location services are disabled
      SnackBarMessageWidget.show(
          'Location services are disabled. Please enable the services');
      return false;
    }

    // Check the current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show a snack bar if permission is still denied
        SnackBarMessageWidget.show('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Show a snack bar if permission is permanently denied
      SnackBarMessageWidget.show(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }

    // Return true if permission is granted
    return true;
  }

  // Method to fetch the current position and convert it to an address
  Future<void> getCurrentPosition() async {
    change(null,
        status: RxStatus
            .loading()); // Change state to loading while fetching the location
    CommonAssets.startFunctionPrint(
        title: "Location Fetching in Location Controller");

    // Check and handle permissions before fetching the location
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      return; // If permission is not granted, exit the function
    }

    // Get the current position with high accuracy
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      currentPosition = position; // Store the current position

      // Fetch the placemark (address) details from the coordinates
      placemarks.value =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Store the latitude and longitude in the AddWormsController to use later
      AddWormsController.instance.latLong.value =
          "${currentPosition?.latitude}, ${currentPosition?.longitude}";

      change(null,
          status: RxStatus
              .success()); // Change state to success after fetching the location
      CommonAssets.successFunctionPrint(
          title: 'Location Fetched in Location Controller');
    }).catchError((e) {
      // Handle any error that occurs while fetching the location
      change(null,
          status: RxStatus
              .success()); // Change state to success even in case of error
      CommonAssets.successFunctionPrint(
          title: 'Error in Location Fetched Location Controller');
      debugPrint(e); // Print the error for debugging purposes
    });
  }

  @override
  void onInit() async {
    super.onInit();
    change(null,
        status: RxStatus.success()); // Set the initial state to success
  }
}
