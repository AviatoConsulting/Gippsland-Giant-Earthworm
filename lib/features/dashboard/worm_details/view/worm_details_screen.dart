// ignore_for_file: prefer_collection_literals

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/playing_audio_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/worm_details/view/image_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// WormDetailsScreen displays the details of a single worm, including its location, notes, audio recording, and images.
class WormDetailsScreen extends StatelessWidget {
  final WormModel wormDetails; // Model containing the details of the worm
  const WormDetailsScreen({super.key, required this.wormDetails});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // Fetch text theme from the app
    final Completer<GoogleMapController> googlecontroller =
        Completer<GoogleMapController>(); // Controller for Google Maps
    // LatLng represents the worm's location on the map, extracted from wormDetails
    final LatLng wormLocation = LatLng(
      double.parse(wormDetails.latLong.split(',')[0]),
      double.parse(wormDetails.latLong.split(',')[1]),
    );

    // Define a marker to show the worm's location on the map
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('worm_location'),
        position: wormLocation,
        infoWindow: InfoWindow(
          title: 'Worm Location',
          snippet: '${wormDetails.locality}, ${wormDetails.administrativeArea}',
        ),
      ),
    };

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(
            androidBottom: 0), // Screen padding for layout consistency
        child: Column(
          children: [
            const ScreenTitleWidget(
              title: "Worm Details", // Title widget for the screen
              isBack: true, // Back navigation enabled
            ),
            const SizedBox(height: 20), // Space between widgets
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Google Map to show worm's location on a map
                    SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GoogleMap(
                          mapType: MapType.normal, // Normal map view
                          onMapCreated: (GoogleMapController controller) {
                            googlecontroller.complete(
                                controller); // Completer to control the map
                          },
                          myLocationButtonEnabled:
                              true, // Enable current location button
                          initialCameraPosition: CameraPosition(
                            target:
                                wormLocation, // Set initial camera position to worm's location
                            zoom: 15, // Zoom level
                          ),
                          liteModeEnabled: Platform
                              .isAndroid, // Use lite mode on Android for performance
                          markers: markers, // Set the markers for the map
                          gestureRecognizers: Set()
                            ..add(Factory<EagerGestureRecognizer>(
                                // Gesture recognizers for map interactions
                                () => EagerGestureRecognizer())),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Location details (locality, administrative area, country, postal code)
                    Text(
                      "${wormDetails.locality}, ${wormDetails.administrativeArea}, ${wormDetails.country}, ${wormDetails.postalCode}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                        color: Colors.black12), // Divider for separation
                    const SizedBox(height: 5),
                    Text("Notes",
                        style: textTheme.titleMedium
                            ?.copyWith(fontSize: 20)), // Notes section header
                    // Displaying the notes with a maximum of 3 lines
                    Text(wormDetails.note,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge),
                    const SizedBox(height: 5),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 5),
                    // Audio recording section header
                    Text("Recording",
                        style: textTheme.titleMedium?.copyWith(fontSize: 20)),
                    const SizedBox(height: 5),
                    // FutureBuilder to fetch and display audio if available
                    FutureBuilder(
                      future: CommonAssets.getGCSUrl(wormDetails
                          .audioUrl), // Fetching the audio URL from GCS
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child:
                                  CircularProgressIndicator()); // Loading state
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error: ${snapshot.error}')); // Error state
                        } else if (snapshot.hasData) {
                          return AudioPlayerWidget(
                              audioUrl: snapshot
                                  .data!); // Display audio player widget
                        } else {
                          return Center(
                            child: Text('No audio available',
                                style: textTheme.titleMedium
                                    ?.copyWith(fontSize: 18)), // No audio state
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    // Location image section header
                    Text("Location Image",
                        style: textTheme.titleMedium?.copyWith(fontSize: 20)),
                    const SizedBox(height: 5),
                    // Display location image in a clickable widget
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () => Get.to(() => FullScreenImage(
                            imageUrl: wormDetails
                                .locationImg)), // Open full-screen image view
                        child: Hero(
                          tag: wormDetails.locationImg, // Hero animation tag
                          child: CommonAssets.getGCSNetworkImage(
                              wormDetails.locationImg,
                              AppImagesConstant.appLogo,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit
                                  .cover), // Display image fetched from GCS
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Worm images section header
                    Text("Worm Images",
                        style: textTheme.titleMedium?.copyWith(fontSize: 20)),
                    const SizedBox(height: 5),
                    // Displaying multiple worm images in a wrap widget
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: wormDetails.wormsImg
                          .map((e) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () => Get.to(() => FullScreenImage(
                                      imageUrl:
                                          e)), // Open full-screen image view
                                  child: Hero(
                                    tag: e
                                        .characters, // Hero animation tag for each image
                                    child: CommonAssets.getGCSNetworkImage(
                                        e, AppImagesConstant.appLogo,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit
                                            .cover), // Display worm images
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(
                        height: 20), // Space at the bottom of the page
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
