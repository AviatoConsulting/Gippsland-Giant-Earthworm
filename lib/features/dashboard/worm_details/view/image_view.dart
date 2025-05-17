import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:http/http.dart' as http;
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  String? img; // Variable to hold the image URL after fetching

  @override
  void initState() {
    super.initState();
    _fetchImage(); // Fetch image URL from GCS
    _requestPermission(); // Request permission to save images
  }

  // Function to fetch the image URL from GCS (Google Cloud Storage)
  Future<void> _fetchImage() async {
    final imageUrl = await CommonAssets.getGCSUrl(widget.imageUrl);
    setState(() {
      img = imageUrl; // Update the state with the fetched image URL
    });
  }

  // Function to request permission based on platform (Android or iOS)
  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      // On Android, request storage permission
      await Permission.storage.request();
    } else {
      // On iOS, request permission to add photos
      await Permission.photosAddOnly.request();
    }
  }

  // Function to save the image to the device's gallery
  Future<void> _saveImage(BuildContext context) async {
    try {
      if (img == null) return; // If no image is fetched, return

      // Download the image data from the URL
      final response = await http.get(Uri.parse(img!));
      if (response.statusCode == 200) {
        // Get the temporary directory on the device
        final directory = await path.getTemporaryDirectory();
        final imagePath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Create a file at the specified image path
        final file = File(imagePath);
        await file.writeAsBytes(response.bodyBytes);

        // Save the image to the gallery using the SaverGallery plugin
        await SaverGallery.saveImage(
          response.bodyBytes,
          fileName: imagePath.split('/').last, // Image name based on file path
          skipIfExists:
              false, // Don't save the image if it already exists on Android
        );

        // Show a success toast notification
        if (context.mounted) {
          showCommonToast(
              context: context,
              type: ToastificationType.success,
              title: "Image Saved",
              description: "Image saved to gallery.");
        }
      } else {
        throw Exception('Failed to download image');
      }
    } catch (error) {
      // Handle errors during the image download or save process
      debugPrint('Error saving image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Transparent background for full-screen mode
      floatingActionButton: FloatingActionButton(
        tooltip: "Save Image", // Tooltip to show when hovering over the button
        onPressed: img == null
            ? null
            : () => _saveImage(context), // Save image when button is pressed
        child: const Icon(Icons.save_alt), // Save icon for the button
      ),
      body: Padding(
        padding: AppConstants.screenPadding(
            context: context), // Padding for the screen content
        child: Hero(
          tag: widget
              .imageUrl, // Hero tag for the image (used for smooth transitions)
          child: img == null
              // If the image hasn't been fetched yet, show a loader
              ? const CustomLoader(
                  color: Colors.white,
                )
              : PhotoView(
                  customSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context)
                          .size
                          .height), // Set image size to full screen
                  onTapDown: (context, details,
                      controllerValue) {}, // Handle tap down event (optional)
                  onTapUp: (context, details,
                      controllerValue) {}, // Handle tap up event (optional)
                  onScaleEnd: (context, details, controllerValue) =>
                      Get.back(), // Go back when scaling ends
                  imageProvider: NetworkImage(
                      img!), // Image to display from the fetched URL
                  loadingBuilder: (context, event) => const Center(
                    child: CircularProgressIndicator(
                        color: AppColor
                            .primaryColor), // Show a loading spinner while the image loads
                  ),
                  backgroundDecoration: const BoxDecoration(
                      color:
                          Colors.transparent), // Set background color to black
                ),
        ),
      ),
    );
  }
}
