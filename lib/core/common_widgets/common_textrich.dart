import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

/// A widget that displays a rich text with a tappable action text at the end.
/// Useful for inline call-to-action phrases such as "Already have an account? Sign in."
class CommonTextRich extends StatelessWidget {
  final String message; // Initial message displayed before the action text
  final String actionText; // Action text that is tappable
  final Color? color; // Color for the action text, defaults to primary color
  final Function onTap; // Callback function when action text is tapped

  const CommonTextRich({
    super.key,
    required this.message,
    required this.actionText,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12), // Adds spacing above the text
      child: Text.rich(
        TextSpan(
          text: message,
          style: const TextStyle(
            fontSize: 14, // Base font size for message
            fontWeight: FontWeight.w400,
          ),
          children: [
            // Action text styled and wrapped with a TapGestureRecognizer for interactivity
            TextSpan(
              text: actionText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: color ??
                    AppColor
                        .primaryColor, // Defaults to primary color if none provided
                decoration:
                    TextDecoration.underline, // Underlines the action text
                decorationColor:
                    AppColor.primaryColor, // Underline color matches text color
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => onTap(), // Tap event
            ),
          ],
        ),
      ),
    );
  }
}
