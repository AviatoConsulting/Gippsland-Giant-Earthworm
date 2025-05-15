import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/video_player_controller.dart';

class VideoPlayerOnlineWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerOnlineWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerOnlineWidget> createState() =>
      _VideoPlayerOnlineWidgetState();
}

class _VideoPlayerOnlineWidgetState extends State<VideoPlayerOnlineWidget> {
  final controller = VideoPlayerOnlineController.instance;

  @override
  void initState() {
    controller.initializeVideoPlayer(videoUrl: widget.videoUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CustomLoader();
      }

      return SizedBox(
        height: 220,
        width: double.infinity,
        child: CustomVideoPlayer(
          customVideoPlayerController: controller.customVideoPlayerController!,
        ),
      );
    });
  }
}
