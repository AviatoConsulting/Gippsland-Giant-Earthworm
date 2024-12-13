import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A reusable loading widget that displays a staggered dots wave animation.
/// Can customize the color of the loader to fit the app's theme or context.
class CustomLoader extends StatelessWidget {
  final Color color; // Color of the loading animation dots

  const CustomLoader({
    super.key,
    this.color = AppColor.primaryColor, // Defaults to the app's primary color
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: color, // Sets the color of the dots
        size: 40, // Size of the loading animation
      ),
    );
  }
}
