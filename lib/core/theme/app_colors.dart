import 'dart:math';
import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xFFE6924B);
  static const Color cardColor = Color(0xFF1F2125);
  static const Color dividerColor = Color.fromRGBO(166, 166, 166, 0.5);
  static const Color greyFontColor = Color.fromRGBO(30, 30, 30, 0.2);
  static const Color cardDarkGreenColor = Color(0xFF2E312E);
  static const Color primaryColorDark = Color(0xFFF4F4F4);
  static const Color primaryColorLight = Color(0xFFF4F4F4);
  static const Color whiteLilac = Color.fromRGBO(248, 250, 252, 1);
  static const Color blackPearl = Color.fromRGBO(30, 31, 43, 1);
  static const Color brinkPink = Color.fromRGBO(255, 97, 136, 1);
  static const Color juneBud = Color.fromRGBO(186, 215, 97, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color nevada = Color(0xff6B7280);
  static const Color ebonyClay = Color.fromRGBO(40, 42, 58, 1);
  static const Color grey = Color.fromRGBO(87, 108, 138, 1);
  static const Color lightGrey = Color.fromRGBO(247, 247, 247, 1);
  static const Color whiteBG = Color(0xffF7F7F7);
  static const Color black = Color(0xff000000);
  static const Color greyScale = Color(0xfff3f4f8);
  static const Color grayScale5 = Color(0xff5B5D6B);
  static const Color grayScale7 = Color(0xff404252);
  static const Color grayScale9 = Color(0xff101223);
  static const Color randomCardColor1 = Color.fromRGBO(0, 122, 175, 1);
  static const Color randomCardColor2 = Color.fromRGBO(72, 79, 89, 1);
  static const Color blueShade1 = Color(0xffdff3ff);
  static const Color blueShade2 = Color(0xffE9F7FF);
  static const Color darkBlueShade2 = Color(0xff001b2b);
  static const Color gryShade = Color(0xffF9F9F9);
  static const Color navyShade = Color.fromRGBO(0, 112, 175, 1);
  static const Color secondaryGreen = Color(0xff47c87a);
  static const Color randomBG = Color(0xffeee5ff);
  static const Color transparent = Colors.transparent;
  static const Color greyScale5 = Color(0xff5B5D6B);
  static const Color greyScale7 = Color(0xff404252);
  static const Color textFieldBg = Color(0xffF1F1F1);
  static const Color red = Color(0xffFF4242);
  static Color containerBGcolor = Colors.grey.shade100;
  static const Color settingBackground = Color.fromRGBO(250, 250, 250, 1);
  static const Color greenBackground = Color.fromRGBO(236, 249, 248, 1);
  static const Color redColor = Color.fromRGBO(238, 10, 10, 1);

  static const Color black50 = Color(0XFF1E1E1E);
  static const Color black1000 = Color.fromRGBO(30, 30, 30, 1);
  static const Color black100 = Color.fromRGBO(30, 30, 30, 0.1);
  static const Color black300 = Color.fromRGBO(30, 30, 30, 0.3);
  static const Color black400 = Color.fromRGBO(30, 30, 30, 0.4);
  static const Color black600 = Color.fromRGBO(30, 30, 30, 0.6);
  static const Color black800 = Color.fromRGBO(30, 30, 30, 0.8);
  static const Color green1000 = Color.fromRGBO(67, 192, 185, 1);
  static const Color white1000 = Color.fromRGBO(255, 255, 255, 1);
  static const Color purple = Color(0xffA73D9A);
  static const Color green = Color(0xff2FB589);
  static const Color greyBackground = Color(0xffF2F4F5);

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color generateRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  //chart colors
  static List<Color> chartColorPalette = const [
    Color(0xFFFDE725),
    Color(0xFF95D840),
    Color(0xFF20A387),
    Color(0xFF2D708E),
    Color(0xFF453781),
    Color(0xFF440154),
  ];
}
