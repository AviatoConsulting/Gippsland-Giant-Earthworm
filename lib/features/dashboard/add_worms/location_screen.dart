import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSearchScreen extends StatefulWidget {
  final double lat; // Latitude for the initial location
  final double long; // Longitude for the initial location

  const LocationSearchScreen(
      {super.key, required this.lat, required this.long});

  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  GoogleMapController? _mapController; // Google Map Controller
  LatLng? _pickedLocation; // Variable to hold the selected location on the map

  @override
  void initState() {
    super.initState();
    _initializePickedLocation(); // Initialize the picked location on the map
  }

  // Initializes the location on the map, either from passed lat/long or current location
  Future<void> _initializePickedLocation() async {
    if (widget.lat == 0.0 && widget.long == 0.0) {
      // If lat/long is 0.0, fetch current location
      await LocationController.instance.getCurrentPosition();
      _pickedLocation = LatLng(
        double.parse(AddWormsController.instance.latLong.split(",")[0]),
        double.parse(AddWormsController.instance.latLong.split(",")[1]),
      );
      setState(() {
        _moveToLocation(
          double.parse(AddWormsController.instance.latLong.split(",")[0]),
          double.parse(AddWormsController.instance.latLong.split(",")[1]),
        );
      });
    } else {
      // Use provided lat/long if available
      _pickedLocation = LatLng(widget.lat, widget.long);
    }
  }

  // Called when the map is created and ready to use
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move the camera to the picked location with a zoom level of 15
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_pickedLocation!, 15),
    );

    // Initialize location in AddWormsController if a location is selected
    if (_pickedLocation != null) {
      AddWormsController.instance.latLong.value =
          "${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}";
    }
  }

  // Called when a user taps on the map to select a new location
  void _onTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  // Called when the user selects a location and confirms the selection
  void _selectLocation() {
    // Store the selected location in the controller
    AddWormsController.instance.latLong.value =
        "${_pickedLocation?.latitude}, ${_pickedLocation?.longitude}";
    debugPrint(
        "Location: ${_pickedLocation?.latitude}, ${_pickedLocation?.longitude}");
    Navigator.of(context).pop(); // Close the screen after selection
  }

  // Moves the camera to the given latitude and longitude and updates picked location
  Future<void> _moveToLocation(double lat, double lng) async {
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
    );
    setState(() {
      _pickedLocation = LatLng(lat, lng);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; // Get current text theme

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(), // Go back to the previous screen
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios,
              size: 25,
            ),
          ),
        ),
        title: Text(
          'Select Location',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          if (_pickedLocation !=
              null) // Show check icon if a location is selected
            IconButton(
              icon: const Icon(
                Icons.check,
                size: 26,
                color: AppColor.primaryColor,
              ),
              onPressed: _selectLocation, // Confirm selection
            )
        ],
      ),
      body: LocationController.instance.obx(
          (state) => Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      onMapCreated:
                          _onMapCreated, // Callback when map is created
                      initialCameraPosition: _pickedLocation != null
                          ? CameraPosition(
                              target:
                                  _pickedLocation!, // Initial position of the map
                              zoom: 15,
                            )
                          : const CameraPosition(
                              target: LatLng(37.422,
                                  -122.084), // Default position if location not found
                            ),
                      onTap: _onTap, // Callback when map is tapped
                      markers: _pickedLocation == null
                          ? {} // Show no markers if no location selected
                          : {
                              Marker(
                                markerId: const MarkerId('picked-location'),
                                position:
                                    _pickedLocation!, // Mark the selected position on the map
                              )
                            },
                    ),
                  ),
                ],
              ),
          onLoading:
              const CustomLoader()), // Show loader if location data is being fetched
    );
  }
}
