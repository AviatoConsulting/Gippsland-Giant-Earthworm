// Widget for displaying an animated recording wave
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  // A list representing the height of each "wave" bar in the animation
  final List<double> _heights = [
    0.05,
    0.07,
    0.1,
    0.07,
    0.05,
    0.05,
    0.07,
    0.1,
    0.07,
    0.05,
    0.05,
    0.07,
    0.1,
  ];

  Timer? _timer; // Timer for updating the wave heights periodically

  @override
  void initState() {
    super.initState();
    _startAnimating(); // Start the wave animation when the widget is initialized
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to start animating the wave heights by periodically shifting them
  void _startAnimating() {
    // Create a periodic timer that updates the wave heights every 150 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // Shift the first element of the list to the end to animate the wave
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return a row of animated wave bars
    return SizedBox(
      height: MediaQuery.sizeOf(context).height *
          0.1 /
          2, // Set the height relative to the screen size
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          // For each wave height, create an animated container (bar)
          return AnimatedContainer(
            duration: const Duration(
                milliseconds: 300), // Smooth transition for height change
            width: 4, // Fixed width for each wave bar
            height: MediaQuery.sizeOf(context).height *
                height /
                2, // Height is based on screen size
            margin:
                const EdgeInsets.only(right: 10), // Add space between the bars
            decoration: BoxDecoration(
              color: AppColor.primaryColor, // Set the color of the wave bar
              borderRadius: BorderRadius.circular(
                  20), // Round the corners of the wave bars
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Widget for displaying static wave bars (no animation)
class CustomStaticWaves extends StatelessWidget {
  const CustomStaticWaves({super.key});

  // A list representing the static heights of the wave bars
  final List<double> _heights = const [
    0.05,
    0.07,
    0.1,
    0.07,
    0.05,
    0.05,
    0.07,
    0.1,
    0.07,
    0.05,
    0.05,
    0.07,
    0.1,
  ];

  @override
  Widget build(BuildContext context) {
    // Return a row of static wave bars (no animation)
    return SizedBox(
      height: MediaQuery.sizeOf(context).height *
          0.1 /
          2, // Set the height relative to the screen size
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          // For each wave height, create an animated container (bar)
          return AnimatedContainer(
            duration: const Duration(
                milliseconds: 300), // Smooth transition for height change
            width: 4, // Fixed width for each wave bar
            height: MediaQuery.sizeOf(context).height *
                height /
                2, // Height is based on screen size
            margin:
                const EdgeInsets.only(right: 10), // Add space between the bars
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(
                  0.5), // Set the color with opacity for static waves
              borderRadius: BorderRadius.circular(
                  20), // Round the corners of the wave bars
            ),
          );
        }).toList(),
      ),
    );
  }
}
