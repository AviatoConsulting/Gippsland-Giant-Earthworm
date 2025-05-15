import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/home_controller.dart';

class VideoPlayerOnlineController extends GetxController {
  static VideoPlayerOnlineController get instance => Get.find();

  final RxBool isLoading = true.obs;
  final RxBool showOfflineMessage = false.obs;
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? customVideoPlayerController;

  Future<void> initializeVideoPlayer({required String videoUrl}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult == ConnectivityResult.none;

    if (isOffline) {
      isLoading.value = false;
      showOfflineMessage.value = true;
      return;
    }

    try {
      final videoLink = await CommonAssets.getGCSUrl(videoUrl, false);
      if (videoLink == null) throw Exception("No video URL found");

      videoPlayerController = VideoPlayerController.network(videoLink);
      await videoPlayerController!.initialize();

      customVideoPlayerController = CustomVideoPlayerController(
        context: Get.context!, // Using Get context
        videoPlayerController: videoPlayerController!,
        customVideoPlayerSettings: const CustomVideoPlayerSettings(
          showFullscreenButton: true,
          placeholderWidget: Center(child: CircularProgressIndicator()),
        ),
      );
      update();
      isLoading.value = false;
      fetchWormData();
    } catch (e) {
      fetchWormData();
      debugPrint("Error initializing video: $e");
      isLoading.value = false;
      showOfflineMessage.value = true;
    }
  }

  // Fetch data when starting the app after loaded the video if video is not available then it will load from homeController
  void fetchWormData() {
    if (HomeController.instance.wormList.isEmpty) {
      HomeController.instance.fetchWormData();
    }
  }
}
