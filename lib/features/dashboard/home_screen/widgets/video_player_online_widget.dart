import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerOnlineWidget extends StatefulWidget {
  final String videoUrl; // Use a network URL

  const VideoPlayerOnlineWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerOnlineWidget> createState() =>
      _VideoPlayerOnlineWidgetState();
}

class _VideoPlayerOnlineWidgetState extends State<VideoPlayerOnlineWidget> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    final videoLink = await CommonAssets.getGCSUrl(widget.videoUrl);
    // Initialize the VideoPlayerController using the network URL
    flickManager = FlickManager(
        autoPlay: false,
        autoInitialize: true,
        videoPlayerController: VideoPlayerController.networkUrl(
            Uri.parse(videoLink!),
            videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true, allowBackgroundPlayback: false)));
    // Optionally start playing the video once initialized
    // _controller!.play();
    setState(() {
      // flickManager!.flickControlManager!.autoPause();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (flickManager?.flickVideoManager?.isBuffering ?? true) {
      return const CustomLoader();
    } else {
      return FlickVideoPlayer(
          flickManager: flickManager!,
          flickVideoWithControls: FlickVideoWithControls(
            controls: FlickPortraitControls(
                fontSize: 16,
                iconSize: 24,
                progressBarSettings: FlickProgressBarSettings(
                  playedColor: Colors.black, // Progress bar played color
                  bufferedColor: Colors.grey.shade400,
                  handleColor: Colors.black,
                  backgroundColor: Colors.grey,
                )),
            playerLoadingFallback: const Center(child: CustomLoader()),
            iconThemeData: const IconThemeData(
              color: Colors.black,
              size: 24,
            ),
            textStyle: const TextStyle(
              color: Colors.black,
            ),
          ));
    }
  }
}
