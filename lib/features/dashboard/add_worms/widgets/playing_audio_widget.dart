import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/recording_waves.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl; // URL of the audio to be played

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance
  bool isPlaying = false; // State variable to track if the audio is playing
  bool isLoading = false; // State variable to track if audio is loading

  @override
  void initState() {
    super.initState();
    _preloadAudio(); // Preload the audio when the widget is initialized

    // Listen for when the audio completes playing
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlaying = false; // Set to false when audio finishes
        });
      }
    });

    // Listen for changes in the player's state (playing, paused, etc.)
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing; // Update play/pause state
          isLoading =
              false; // Clear the loading state when playback starts or stops
        });
      }
      if (state == PlayerState.completed) {
        _preloadAudio(); // Preload audio when completed
      }
    });
  }

  // Preload the audio by setting the audio source URL
  Future<void> _preloadAudio() async {
    setState(() {
      isLoading = true; // Show loading state while the audio is being prepared
    });

    try {
      await _audioPlayer
          .setSourceUrl(widget.audioUrl); // Set the audio URL to the player
    } catch (e) {
      debugPrint(
          "Error while setSourceUrl in audioplayer: $e"); // Log error if setting URL fails
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Clear loading state after preloading
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer
        .dispose(); // Dispose of the audio player when the widget is disposed
    super.dispose();
  }

  // Function to toggle between play and pause states
  Future<void> _playPause() async {
    if (isPlaying) {
      setState(() {
        isPlaying = false; // Pause the audio if it is playing
      });
      await _audioPlayer.pause();
    } else {
      setState(() {
        isPlaying = true; // Play the audio if it is paused
      });
      await _audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CommonAssets
          .containerGreyDecoration(), // Container with a grey background
      padding: const EdgeInsets.all(12), // Padding inside the container
      child: Row(
        children: [
          InkWell(
            onTap: _playPause, // Handle play/pause on tap
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.primaryColor
                    .withOpacity(0.2), // Light background for the button
                borderRadius:
                    BorderRadius.circular(12), // Rounded corners for the button
              ),
              padding: const EdgeInsets.all(8), // Padding inside the button
              child: isLoading
                  ? LoadingAnimationWidget.beat(
                      color: AppColor
                          .primaryColor, // Show loading animation when audio is loading
                      size: 24)
                  : Icon(
                      isPlaying
                          ? Icons.pause
                          : Icons.play_arrow, // Play/Pause icon based on state
                      color: Colors.black54,
                      size: 24,
                    ),
            ),
          ),
          const SizedBox(
              width:
                  20), // Spacer between the play/pause button and wave widget
          isPlaying
              ? const CustomRecordingWaveWidget() // Show animated wave during playback
              : const CustomStaticWaves(), // Show static wave when paused
        ],
      ),
    );
  }
}
