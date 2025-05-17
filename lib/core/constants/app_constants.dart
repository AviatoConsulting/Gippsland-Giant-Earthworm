import 'dart:io';

import 'package:flutter/material.dart';

class AppConstants {
  static bool hasNotch(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top > 20;
  }

  static EdgeInsets screenPadding({
    required BuildContext context,
    double iosTop = 60.0,
    double androidTop = 50.0,
    double androidBottom = 16.0,
    double iosBottom = 16.0,
    double left = 24.0,
    double right = 24.0,
  }) {
    double top = Platform.isIOS ? iosTop : androidTop;
    // If device has a notch, set top padding to 30
    if (!hasNotch(context) && Platform.isIOS) {
      top = 30.0;
    }
    double bottom = Platform.isIOS ? iosBottom : androidBottom;
    return EdgeInsets.only(right: right, left: left, top: top, bottom: bottom);
  }

  static double cloudTopMargin = 40;
}
