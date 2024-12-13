import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  AppThemes._();

  static const String font1 = 'BeVietnamPro';
  static const String font2 = 'Macho';

  static const Color _lightBackgroundColor = AppColor.white;
  static const Color _lightPrimaryColor = AppColor.primaryColor;
  static const Color _lightTextColor = AppColor.black;
  static const Color _lightTextSecondaryColor = AppColor.greyScale5;
  static const Color _lightBackgroundSecondaryColor = AppColor.greyScale;
  static const Color _lightBackgroundAppBarColor = AppColor.greyScale7;
  static final Color _lightBorderActiveColor = AppColor.black.withOpacity(0.4);
  static const Color _lightBorderErrorColor = Colors.redAccent;
  static const Color _lightBackgroundAlertColor = AppColor.brinkPink;
  static const Color _lightBackgroundActionTextColor = AppColor.white;
  static const Color _lightIconColor =
      AppColor.grey; // You can replace with your desired color
  // static final Color _lightTextBlack1000 = AppColor.black.withOpacity(1);
  // static final Color _lightTextBlack800 = AppColor.black.withOpacity(0.8);
  // static final Color _lightTextBlack600 = AppColor.black.withOpacity(0.6);
  static final Color _lightTextBlack400 = AppColor.black.withOpacity(0.4);

  static const Color _darkBackgroundColor = AppColor.black;
  static const Color _darkPrimaryColor = AppColor.primaryColor;
  static const Color _darkTextColor = AppColor.white;
  static const Color _darkTextSecondaryColor = AppColor.greyScale5;
  static const Color _darkBackgroundSecondaryColor = AppColor.greyScale;
  static const Color _darkBackgroundAppBarColor = AppColor.grayScale9;
  static final Color _darkBorderActiveColor = AppColor.white.withOpacity(0.4);
  static const Color _darkBorderErrorColor = Colors.redAccent;
  static const Color _darkBackgroundAlertColor = AppColor.brinkPink;
  static const Color _darkBackgroundActionTextColor = AppColor.white;
  static const Color _darkIconColor = AppColor.white;
  static final Color _darkTextWhite1000 = AppColor.white.withOpacity(1);
  static final Color _darkTextWhite800 = AppColor.white.withOpacity(0.8);
  static final Color _darkTextWhite600 = AppColor.white.withOpacity(0.6);
  static final Color _darkTextWhite400 = AppColor.white.withOpacity(0.4);

  static const TextTheme _lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 40,
      color: _lightTextColor,
      fontWeight: FontWeight.w800,
      fontFamily: font1,
    ),
    headlineMedium: TextStyle(
      fontSize: 32,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
      fontFamily: font1,
    ),
    headlineSmall: TextStyle(
      fontSize: 26,
      color: _lightTextColor,
      fontWeight: FontWeight.w600,
      fontFamily: font1,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      color: _lightTextColor,
      fontWeight: FontWeight.w600,
      fontFamily: font1,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
      fontFamily: font1,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
      fontFamily: font1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w300,
      fontFamily: font1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: _lightTextColor,
      fontWeight: FontWeight.w300,
      fontFamily: font1,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      color: _lightTextColor,
      fontWeight: FontWeight.w300,
      fontFamily: font1,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    dialogBackgroundColor: _lightBackgroundColor,
    brightness: Brightness.light,
    fontFamily: font1,
    scaffoldBackgroundColor: _lightBackgroundColor,
    primaryColor: _lightPrimaryColor,
    secondaryHeaderColor: AppColor.blueShade2,
    indicatorColor: _lightTextColor,
    cardColor: _lightBackgroundColor,
    checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(_lightPrimaryColor)),
    radioTheme:
        RadioThemeData(fillColor: WidgetStateProperty.all(_lightPrimaryColor)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _lightPrimaryColor,
    ),
    cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        color: _lightBackgroundColor,
        shadowColor: _lightBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColor.grayScale9),
      toolbarTextStyle: _lightTextTheme.bodyMedium,
      titleTextStyle: _lightTextTheme.titleLarge,
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //   statusBarColor: _lightBackgroundColor,
      //   statusBarIconBrightness: Brightness.dark,
      //   statusBarBrightness: Brightness.light,
      // ),
    ),
    listTileTheme: const ListTileThemeData(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: const IconThemeData(
        color: _lightPrimaryColor,
      ),
      unselectedIconTheme: const IconThemeData(
        color: _lightTextSecondaryColor,
      ),
      selectedLabelStyle: _lightTextTheme.bodySmall,
      unselectedLabelStyle: _lightTextTheme.bodySmall,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedItemColor: _lightTextSecondaryColor,
      selectedItemColor: _lightPrimaryColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: _lightBackgroundColor,
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: _lightBackgroundAlertColor,
        actionTextColor: _lightBackgroundActionTextColor),
    iconTheme: const IconThemeData(
      color: _lightIconColor,
    ),
    dividerTheme: const DividerThemeData(
        color: _lightBackgroundSecondaryColor, thickness: 2),
    popupMenuTheme:
        const PopupMenuThemeData(color: _lightBackgroundAppBarColor),
    textTheme: _lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      animationDuration: const Duration(milliseconds: 2000),
      backgroundColor: WidgetStateProperty.all(Colors.lightBlue),
      textStyle: WidgetStateProperty.all(_lightTextTheme.labelLarge),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    )),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      animationDuration: const Duration(milliseconds: 2000),
      backgroundColor: WidgetStateProperty.all(Colors.lightBlue),
      textStyle: WidgetStateProperty.all(_lightTextTheme.labelLarge),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            animationDuration: const Duration(milliseconds: 2000),
            backgroundColor: WidgetStateProperty.all(_lightBackgroundColor),
            textStyle: WidgetStateProperty.all(_lightTextTheme.labelLarge),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            side: WidgetStateProperty.all(
                const BorderSide(color: _lightPrimaryColor, width: 1)))),
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        buttonColor: _lightPrimaryColor,
        textTheme: ButtonTextTheme.primary),
    unselectedWidgetColor: _lightPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
        //prefixStyle: TextStyle(color: _lightIconColor),
        isDense: false,
        hintStyle: _lightTextTheme.titleLarge
            ?.copyWith(fontSize: 14, color: _lightTextBlack400),
        contentPadding: const EdgeInsets.all(16),
        border: const OutlineInputBorder(
            borderSide:
                BorderSide(color: _lightBackgroundSecondaryColor, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            )),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _lightBorderActiveColor),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _lightBorderActiveColor.withOpacity(1)),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        hoverColor: AppColor.transparent,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _lightBorderErrorColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _lightBorderErrorColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        fillColor: AppColor.white,
        filled: true
        //focusColor: _lightBorderActiveColor,
        ),
    colorScheme: const ColorScheme.light(
      primary: _lightTextColor,
      // primaryVariant: _lightBackgroundColor,
      // secondary: _lightSecondaryColor,
    ).copyWith(surface: _lightBackgroundSecondaryColor),
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headlineLarge: const TextStyle(
      fontSize: 32,
      color: _darkTextColor,
      fontWeight: FontWeight.w600,
      fontFamily: font1,
    ),
    headlineMedium: const TextStyle(
      fontSize: 24,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
      fontFamily: font1,
    ),
    headlineSmall: const TextStyle(
      fontSize: 20,
      color: _darkTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    titleLarge: const TextStyle(
      fontSize: 18,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
      fontFamily: font1,
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      color: _darkTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    titleSmall: const TextStyle(
      fontSize: 14,
      color: _darkTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: _darkTextWhite800,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      color: _darkTextSecondaryColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    bodySmall: const TextStyle(
      fontSize: 12,
      color: _darkTextSecondaryColor,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      color: _darkTextWhite1000,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: _darkTextWhite600,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      color: _darkTextWhite400,
      fontWeight: FontWeight.w400,
      fontFamily: font1,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    fontFamily: font1,
    scaffoldBackgroundColor: _darkBackgroundColor,
    secondaryHeaderColor: _darkBackgroundSecondaryColor,
    indicatorColor: _darkTextColor,
    checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(_darkPrimaryColor)),
    radioTheme:
        RadioThemeData(fillColor: WidgetStateProperty.all(_darkPrimaryColor)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkPrimaryColor,
    ),
    cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    appBarTheme: AppBarTheme(
      color: _darkBackgroundAppBarColor,
      iconTheme: const IconThemeData(color: _darkTextColor),
      toolbarTextStyle: _darkTextTheme.bodyMedium,
      titleTextStyle: _darkTextTheme.titleLarge,
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //   statusBarColor: _darkBackgroundColor,
      //   statusBarIconBrightness: Brightness.dark,
      //   statusBarBrightness: Brightness.light,
      // ),
    ),
    snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: Colors.white),
        backgroundColor: _darkBackgroundAlertColor,
        actionTextColor: _darkBackgroundActionTextColor),
    iconTheme: const IconThemeData(
      color: _darkIconColor,
    ),
    popupMenuTheme: const PopupMenuThemeData(color: _darkBackgroundAppBarColor),
    textTheme: _darkTextTheme,
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        buttonColor: _darkPrimaryColor,
        textTheme: ButtonTextTheme.primary),
    unselectedWidgetColor: _darkPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: _lightTextTheme.titleLarge!
            .copyWith(fontSize: 14, color: _darkTextWhite400),
        prefixStyle: const TextStyle(color: _darkIconColor),
        isDense: true,
        contentPadding: const EdgeInsets.all(16),
        border: const OutlineInputBorder(
            borderSide:
                BorderSide(color: _darkBackgroundSecondaryColor, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            )),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _darkBorderActiveColor),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _lightPrimaryColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _darkBorderErrorColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        hoverColor: AppColor.transparent,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _darkBorderErrorColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        fillColor: Colors.black45,
        filled: true
        //focusColor: _darkBorderActiveColor,
        ),
    colorScheme: const ColorScheme.dark(
      primary: _darkTextColor,
    ),
    primaryColor: _darkPrimaryColor,
    listTileTheme: const ListTileThemeData(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: const IconThemeData(
        color: _darkPrimaryColor,
      ),
      unselectedIconTheme: const IconThemeData(
        color: _darkTextSecondaryColor,
      ),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: _darkTextTheme.bodySmall,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedItemColor: _darkTextSecondaryColor,
      selectedItemColor: _darkPrimaryColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: _darkBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
    ),
    dividerTheme: const DividerThemeData(
        color: _darkBackgroundSecondaryColor, thickness: 2),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      animationDuration: const Duration(milliseconds: 2000),
      backgroundColor: WidgetStateProperty.all(Colors.lightBlue),
      textStyle: WidgetStateProperty.all(_darkTextTheme.labelLarge),
    )),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      animationDuration: const Duration(milliseconds: 2000),
      backgroundColor: WidgetStateProperty.all(Colors.lightBlue),
      textStyle: WidgetStateProperty.all(_darkTextTheme.labelLarge),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            animationDuration: const Duration(milliseconds: 2000),
            backgroundColor: WidgetStateProperty.all(_darkBackgroundColor),
            textStyle: WidgetStateProperty.all(_darkTextTheme.labelLarge),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            side: WidgetStateProperty.all(
                const BorderSide(color: _darkPrimaryColor, width: 1)))),
  );
}
