import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';

/// Displays a customizable toast notification using the toastification package.
///
/// - [context]: Required BuildContext to display the toast.
/// - [title]: Title text displayed in the toast.
/// - [description]: Description text displayed in the toast.
/// - [type]: Specifies the type of toast (e.g., info, success, warning).
/// - [style]: Style of the toast (e.g., flat or elevated).
/// - [autoCloseDuration]: Duration for the toast to automatically close.
/// - [alignment]: Position of the toast on the screen.
/// - [direction]: Text direction, useful for RTL or LTR alignment.
/// - [animationDuration]: Duration for the toast's animation.
/// - [icon]: Optional icon widget displayed in the toast.
/// - [primaryColor]: Primary color for elements like the progress bar.
/// - [backgroundColor]: Background color of the toast.
/// - [foregroundColor]: Color for the text inside the toast.
/// - [padding]: Padding inside the toast content area.
/// - [margin]: Margin around the toast.
/// - [borderRadius]: Border radius of the toast for rounded corners.
/// - [boxShadow]: Shadow styling for the toast (currently commented out).
/// - [showProgressBar]: If true, displays a progress bar in the toast.
/// - [closeButtonShowType]: When to show the close button (e.g., always, never).
/// - [closeOnClick]: If true, closes the toast when clicked.
/// - [pauseOnHover]: If true, pauses the auto-close timer when hovered.
/// - [dragToClose]: If true, allows the toast to be dragged to close.
/// - [applyBlurEffect]: If true, applies a blur effect to the toast background.

void showCommonToast({
  required BuildContext context,
  required String title,
  required String description,
  ToastificationType type = ToastificationType.info,
  ToastificationStyle style = ToastificationStyle.flat,
  Duration autoCloseDuration = const Duration(seconds: 3),
  AlignmentGeometry alignment =
      kIsWeb ? Alignment.topRight : Alignment.bottomCenter,
  TextDirection direction = TextDirection.ltr,
  Duration animationDuration = const Duration(milliseconds: 300),
  Widget? icon,
  Color primaryColor = AppColor.primaryColor,
  Color backgroundColor = Colors.white,
  Color foregroundColor = Colors.black,
  EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  EdgeInsetsGeometry margin =
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  List<BoxShadow> boxShadow = const [
    BoxShadow(
      color: Color(0x07000000),
      blurRadius: 16,
      offset: Offset(0, 16),
      spreadRadius: 0,
    )
  ],
  bool showProgressBar = true,
  CloseButtonShowType closeButtonShowType = CloseButtonShowType.always,
  bool closeOnClick = false,
  bool pauseOnHover = true,
  bool dragToClose = true,
  bool applyBlurEffect = false,
}) {
  toastification.show(
    context: context,
    type: type,
    style: style,
    autoCloseDuration: autoCloseDuration,
    progressBarTheme: ProgressIndicatorThemeData(
      color: primaryColor, // Sets color of the progress bar
      linearMinHeight: 2,
      linearTrackColor: Colors.grey, // Background track color of progress bar
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),
    alignment: alignment,
    direction: direction,
    animationDuration: animationDuration,
    animationBuilder: (context, animation, alignment, child) {
      // Custom fade-in animation for the toast
      return FadeTransition(
        key: GlobalKey(),
        opacity: animation,
        child: child,
      );
    },
    icon: icon,
    primaryColor: primaryColor,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    padding: padding,
    margin: margin,
    borderRadius: borderRadius,
    // boxShadow: boxShadow, // Uncomment if custom shadows are needed
    showProgressBar: showProgressBar,
    closeButtonShowType: closeButtonShowType,
    closeOnClick: closeOnClick,
    pauseOnHover: pauseOnHover,
    dragToClose: dragToClose,
    applyBlurEffect: applyBlurEffect,
  );
}
