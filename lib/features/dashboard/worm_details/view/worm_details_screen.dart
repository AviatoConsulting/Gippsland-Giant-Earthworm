// ignore_for_file: prefer_collection_literals

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
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
            context: context,
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
                    wormDetails.audioUrl.isEmpty
                        ? Text('No audio available',
                            style: textTheme.titleMedium
                                ?.copyWith(fontSize: 18, color: Colors.red))
                        : FutureBuilder(
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
                                return Text('No audio available',
                                    style: textTheme.titleMedium?.copyWith(
                                        fontSize: 18, color: Colors.red));
                              }
                            },
                          ),
                    const SizedBox(height: 5),
                    // Location image section header
                    Text("Location Image",
                        style: textTheme.titleMedium?.copyWith(fontSize: 20)),
                    const SizedBox(height: 5),
                    // Display location image in a clickable widget
                    wormDetails.locationImg.isEmpty
                        ? Text('No Location Image available',
                            style: textTheme.titleMedium
                                ?.copyWith(fontSize: 18, color: Colors.red))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () => Get.to(() => FullScreenImage(
                                  imageUrl: wormDetails
                                      .locationImg)), // Open full-screen image view
                              child: Hero(
                                tag: wormDetails
                                    .locationImg, // Hero animation tag
                                child: GCSCachedImage(
                                  gcsPath: wormDetails.locationImg,
                                  height: 130,
                                  width: double.infinity,
                                  // fit: BoxFit
                                  //     .cover
                                ), // Display image fetched from GCS
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    // Worm images section header
                    Text("Worm Images",
                        style: textTheme.titleMedium?.copyWith(fontSize: 20)),
                    const SizedBox(height: 5),
                    // Displaying multiple worm images in a wrap widget
                    wormDetails.wormsImg.isEmpty
                        ? Text('No Worms Image available',
                            style: textTheme.titleMedium
                                ?.copyWith(fontSize: 18, color: Colors.red))
                        : SizedBox(
                            height: 120, // Adjust as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: wormDetails.wormsImg.length,
                              itemBuilder: (context, index) {
                                final gcsUrl = wormDetails.wormsImg[index];
                                return GCSCachedImage(
                                    gcsPath: gcsUrl, height: 100, width: 100);
                              },
                            ),
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

class GCSCachedImage extends StatelessWidget {
  final String gcsPath;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GCSCachedImage({
    super.key,
    required this.gcsPath,
    this.height = 100,
    this.width = 100,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.only(right: 10),
  });

  @override
  Widget build(BuildContext context) {
    if (gcsPath.isEmpty) {
      return const SizedBox(
        width: 100,
        height: 100,
        child: Center(child: Icon(Icons.image_not_supported)),
      );
    }

    return FutureBuilder<String?>(
      future: CommonAssets.getGCSUrl(gcsPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return SizedBox(
            width: width,
            height: height,
            child: const Icon(Icons.error),
          );
        }

        final publicUrl = snapshot.data!;
        return Padding(
          padding: padding,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: () => Get.to(() => FullScreenImage(imageUrl: publicUrl)),
              child: CachedNetworkImage(
                imageUrl: publicUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }
}
