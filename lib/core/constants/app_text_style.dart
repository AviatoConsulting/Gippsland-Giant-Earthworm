import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle f12W400B400 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.black400,
  );
  static const TextStyle f12W400B600 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.black600,
  );

  static const TextStyle f14W400B400 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.black400,
  );

  static const TextStyle f14W400B600 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.black600,
  );
  static const TextStyle f14W400B800 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.black800,
  );

  static const TextStyle f14W400B1000 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.black1000,
  );

  static const TextStyle f14W500B1000 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.black1000,
  );
  static const TextStyle f14W500W1000 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.white1000,
  );

  static const TextStyle f14W400G1000 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.green1000,
  );

  static const TextStyle f16W500White = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.white1000,
  );

  static const TextStyle f16W500G1000 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.green1000,
  );

  static const TextStyle f16W500B6000 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.black600,
  );

  static const TextStyle f16W500B1000 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.black1000,
  );

  static const TextStyle f18W700 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle f18W500B1000 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColor.black1000,
  );

  static const TextStyle f18W400R1000 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    color: Color.fromRGBO(232, 18, 18, 1),
  );

  static const TextStyle f20W800 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle f22W900 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle f24W700 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: CustomFontFamily.macho,
      color: Color.fromRGBO(225, 225, 225, 0.6));

  static const TextStyle f24W700Grey = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(30, 30, 30, 0.2));

  static const TextStyle f24W500B1000 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColor.black1000,
  );
  static const TextStyle f24W500W1000 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColor.white1000,
  );

  static const TextStyle f32W500G1000 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColor.green1000,
  );
  static const TextStyle f32W400B1000 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColor.black1000,
  );

  static const TextStyle f40W700White = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontFamily: CustomFontFamily.macho);

  static const TextStyle f40W700B1000 = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: AppColor.black1000,
      fontFamily: CustomFontFamily.macho);

  static const TextStyle f40W500Black = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColor.black1000,
  );
  static const TextStyle f40W700GreenMacho = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: AppColor.green1000,
      fontFamily: CustomFontFamily.macho);

  static TextStyle f18W400Grey = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.black50.withOpacity(0.6),
  );

  static TextStyle f18W400W600 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.black600,
  );

  static TextStyle f18W400B800 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.black800,
  );

  static TextStyle f18W400G1000 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.green1000,
  );

  static TextStyle f18W400W1000 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle f65W700WhiteMacho = TextStyle(
      fontSize: 65,
      fontWeight: FontWeight.w700,
      color: AppColor.white1000,
      fontFamily: CustomFontFamily.macho);
}

class CustomFontFamily {
  static const gibson = "Gibson";
  static const macho = "Macho";
}
