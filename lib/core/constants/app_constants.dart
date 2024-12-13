import 'dart:io';

import 'package:flutter/material.dart';

class AppConstants {
  static EdgeInsets screenPadding({
    double iosTop = 60.0,
    double androidTop = 50.0,
    double androidBottom = 16.0,
    double iosBottom = 16.0,
    double left = 24.0,
    double right = 24.0,
  }) {
    double top = Platform.isIOS ? iosTop : androidTop;
    double bottom = Platform.isIOS ? iosBottom : androidBottom;
    return EdgeInsets.only(right: right, left: left, top: top, bottom: bottom);
  }

  static double cloudTopMargin = 40;
}
