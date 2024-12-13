// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

/// A reusable container for social login buttons with customizable background color,
/// icon, icon color, and size. Designed for SVG icons.
class CommonSocialLoginContainer extends StatelessWidget {
  final Color? bgColor; // Background color for the container, defaults to grey
  final Color? imgColor; // Color for the SVG icon
  final String svgIMG; // Path to the SVG image asset
  final double? size; // Size for the SVG icon, defaults to 30
  final Function()? onTap; // Callback function for tap events

  const CommonSocialLoginContainer({
    super.key,
    this.bgColor,
    required this.svgIMG,
    this.size,
    this.onTap,
    this.imgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Handles tap events, if provided
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ??
              AppColor
                  .greyBackground, // Default to grey if no bgColor is specified
          shape: BoxShape.circle, // Circular shape for social login icon
        ),
        padding: const EdgeInsets.all(
            12), // Padding around the icon for visual spacing
        child: SvgPicture.asset(
          svgIMG, // SVG image asset
          color: imgColor, // Apply color to the SVG if specified
          height: size ?? 30, // Set icon height, defaulting to 30
          width: size ?? 30, // Set icon width, defaulting to 30
        ),
      ),
    );
  }
}
