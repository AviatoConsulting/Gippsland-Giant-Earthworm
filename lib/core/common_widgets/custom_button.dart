import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

/// A reusable button widget with customizable appearance and behavior.
/// The `CommonButton` can be enabled/disabled, customized in size, color,
/// and supports custom on-tap behavior.
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.onTap, // Callback function triggered on button press.
    this.backgroundColor, // Background color of the button.
    required this.label, // Label text displayed on the button.
    this.labelColor, // Color of the label text.
    this.style, // Custom text style for the label.
    this.height, // Custom height for the button.
    this.width, // Custom width for the button.
    this.isEnable = true, // Determines if the button is enabled or disabled.
    this.borderColor, // Border color of the button.
  });

  final Function? onTap;
  final String label;
  final Color? backgroundColor, labelColor, borderColor;
  final TextStyle? style;
  final double? height;
  final double? width;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    // Checks the current theme mode to adjust text color based on brightness.
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: width ?? double.infinity, // Sets width, defaults to full width.
      height: height ?? 50, // Sets height, defaults to 50.
      child: TextButton(
        style: ButtonStyle(
          // Sets button background color depending on the enabled state.
          backgroundColor: MaterialStateProperty.all(
            isEnable
                ? backgroundColor ?? AppColor.primaryColor
                : Colors.transparent,
          ),
          elevation: MaterialStateProperty.all(0), // Removes button shadow.
          alignment: Alignment.center, // Centers text within the button.
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // Defines the button's border with color and radius.
              side: BorderSide(
                color: isEnable
                    ? borderColor ?? Colors.transparent
                    : AppColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(12.0), // Rounded corners.
            ),
          ),
        ),
        onPressed: () {
          // Invokes onTap function if button is enabled.
          if (onTap != null && isEnable) {
            onTap!();
          }
        },
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: style ??
              TextStyle(
                // Sets text color based on enabled state and theme.
                color: isEnable
                    ? borderColor ?? (isDarkTheme ? Colors.black : Colors.white)
                    : AppColor.primaryColor,
                letterSpacing: 1.2, // Adds letter spacing for label.
                fontSize: 18, // Sets font size.
                fontWeight: FontWeight.w600, // Sets font weight.
              ),
        ),
      ),
    );
  }
}
