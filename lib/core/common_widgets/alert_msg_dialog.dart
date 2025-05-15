import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import 'custom_button.dart';

/// A common alert dialog that displays a custom icon, title, description,
/// optional buttons, and actions for confirmations or alerts.
class CommonAlertMessageDialog extends StatelessWidget {
  const CommonAlertMessageDialog({
    super.key,
    this.icon = "assets/icons/warning.png", // Default icon
    required this.title, // Title of the dialog
    required this.description, // Description message
    this.buttonText, // Text for the action button
    this.iconHeight = 100, // Icon height, defaults to 100
    this.buttonColor, // Custom button color, optional
    required this.action, // Primary action function
    this.cancelText, // Text for the cancel button, optional
    this.child, // Additional widget to display in the dialog, optional
    this.cancelAction, // Custom cancel action, optional
    this.subHeadingChild, // Subheading child which will display between heading and description
    this.showCancel = true, // Show cancel button by default
  });

  final String title;
  final String icon;
  final String description;
  final String? buttonText;
  final String? cancelText;
  final double? iconHeight;
  final Color? buttonColor;
  final Widget? child;
  final Widget? subHeadingChild;
  final Function()? action;
  final Function()? cancelAction;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    // Access the text theme to style the title and description
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Get.isDarkMode ? Colors.white30 : Colors.transparent,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display icon image
          Image.asset(
            icon,
            height: iconHeight,
            fit: BoxFit.contain,
          ),
          // Title text
          if (title.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
          ],
          const SizedBox(height: 10),
          if (subHeadingChild != null) subHeadingChild!,

          // Description text
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),

          // Optional additional widget
          if (child != null) child!,
          SizedBox(height: description.isEmpty ? 0 : 20),

          if (showCancel) ...[
            // Cancel button
            CommonButton(
              label: cancelText ?? "Cancel",
              backgroundColor: Get.isDarkMode ? Colors.white12 : Colors.white,
              borderColor: AppColor.primaryColor,
              onTap:
                  cancelAction ?? () => Get.back(), // Default to closing dialog
            ),
            const SizedBox(height: 10),
          ],

          // Action button
          CommonButton(
            label: buttonText ?? "Delete Account",
            onTap: action,
            backgroundColor: buttonColor, // Apply custom color if provided
          ),
        ],
      ),
    );
  }
}
