import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/utils/secure_storage/path_storage.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';
import '../common_widgets/common_snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommonAssets {
  static String defaultImageMain = AppImagesConstant.appLogo;
  static const String alertIcon = "assets/commonassets/alert_icon.svg";
  static String privacyPolicyUrl =
      "https://docs.google.com/document/d/1IpW0R3ygLVCVdd3WiFV-rMYbeEo-EyqjBP9Ub-SM9Hs";
  static String termsAndConditionUrl =
      "https://docs.google.com/document/d/1k6TVX52SWTHKA0eDQVbAG10tcKrQFDTWCum93BrNisM";

  static Future<String?> getGCSUrl(String? icon,
      [bool isGetStored = true]) async {
    if (icon == null || icon == "") icon = "assets/images/biya_circle_icon.svg";
    if (isGetStored) {
      final data = PathStorage.readPathIfAvailable(icon);
      if (data.isNotEmpty) {
        return data;
      }
    }

    try {
      String url;

      url = await FirebaseStorage.instance
          .ref(icon)
          // .ref("${icon}_40x40.jpeg")
          .getDownloadURL();
      PathStorage.savePath(icon, url);
      return url;
    } catch (e) {
      debugPrint('Error occurred for $e');
      return null;
    }
  }

  static Widget getAssetsSvgImage(String imagePath,
      {double height = 40, double width = 40, Color? color}) {
    return SvgPicture.asset(
      imagePath,
      height: height,
      width: width,
      fit: BoxFit.cover,
      color: color,
    );
  }

  static Widget getAssetsImage(
      {String imagePath = "",
      double height = 40,
      double width = 40,
      BoxFit fit = BoxFit.cover,
      required Alignment alignment,
      Color? color}) {
    return Image.asset(
      imagePath.isEmpty ? defaultImageMain : imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      color: color,
    );
  }

  static Widget getNetworkImage(String imageUrl,
      {String defaultImage = "assets/logo/logo.png",
      double height = 90,
      double width = 90,
      BoxFit fit = BoxFit.cover,
      required Alignment alignment}) {
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            height: height,
            width: width,
            fit: fit,
            filterQuality: FilterQuality.medium,
            errorWidget:
                (BuildContext context, String exception, dynamic stackTrace) {
              return getAssetsImage(
                  height: height, width: width, alignment: alignment);
            },
          )
        : getAssetsImage(height: height, width: width, alignment: alignment);
  }

  static Widget getGCSNetworkImage(String imageUrl,
      {String? defaultImage,
      double height = 40,
      double width = 40,
      double radius = 50,
      Alignment alignment = Alignment.center,
      BoxFit fit = BoxFit.cover}) {
    try {
      if (imageUrl.isEmpty) {
        return getAssetsImage(
            height: height,
            width: width,
            alignment: alignment,
            imagePath: defaultImage ?? defaultImageMain,
            fit: BoxFit.contain);
      } else {
        final data = PathStorage.readPathIfAvailable(imageUrl);

        if (data.isNotEmpty) {
          return getNetworkImage(
            data.toString(),
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            defaultImage: defaultImage ?? defaultImageMain,
          );
        } else {
          return FutureBuilder(
            future: getGCSUrl(imageUrl),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasError) {
                debugPrint(
                    "Errpr while loading img: ${snapshot.error.toString()}");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return getAssetsImage(
                      height: height,
                      width: width,
                      alignment: alignment,
                      imagePath: defaultImage ?? defaultImageMain,
                      fit: BoxFit.contain);
                }
                return getNetworkImage(snapshot.data.toString(),
                    height: height,
                    width: width,
                    fit: fit,
                    alignment: alignment);
              } else {
                return getAssetsImage(
                    height: height,
                    width: width,
                    alignment: alignment,
                    imagePath: defaultImage ?? defaultImageMain,
                    fit: BoxFit.contain);
              }
            },
          );
        }
      }
    } on Exception {
      return getAssetsImage(
          height: height,
          width: width,
          alignment: alignment,
          imagePath: defaultImage ?? defaultImageMain,
          fit: fit);
    }
  }

  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarMessageWidget.show("Copied to clipboard");
  }

  static Decoration containerDecoration({required BuildContext context}) {
    return BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.black100));
  }

  static Decoration containerDecorationwithShadow(
      {required BuildContext context}) {
    return BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 0),
              color: Color.fromRGBO(0, 0, 0, 0.08))
        ],
        border: Border.all(
            color: Get.isDarkMode ? Colors.white30 : AppColor.black100));
  }

  static Decoration containerGreyDecoration() {
    return BoxDecoration(
        color: Get.isDarkMode ? Colors.white10 : AppColor.greyBackground,
        borderRadius: BorderRadius.circular(8));
  }

  static String timestampToDate(int timestamp) {
    // Create a DateTime object from the timestamp
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Define months array
    List<String> months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    // Extract day, month, and year from the DateTime object
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;

    // Format the date string
    String formattedDate = '$day ${months[month]} $year';

    return formattedDate;
  }

  static bool validatePassword(String password) {
    // Regex pattern for password validation
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  static void startFunctionPrint({required String title}) {
    if (isDebuggingOnStart) {
      debugPrint("******************************************************");
      // debugPrint("************                              ************");
      debugPrint(title);
      // debugPrint("************                              ************");
      debugPrint("******************************************************");
    }
  }

  static void successFunctionPrint({required String title}) {
    if (isDebuggingOnSuccess) {
      debugPrint("*****************************************************");
      debugPrint("-----------------------------------------------------");
      debugPrint(" $title");
      debugPrint("-----------------------------------------------------");
      debugPrint("*****************************************************");
    }
  }

  static void errorFunctionPrint({required String statusCodeMsg}) {
    if (isDebuggingOnError) {
      debugPrint("------------------------------------------------------");
      debugPrint(statusCodeMsg);
      debugPrint("------------------------------------------------------");
    }
  }

  static bool validateEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  static void enableFirestoreOfflineSupport(FirebaseFirestore firestore) {
    firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  static void logOutFunction({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    Get.back();
    await Get.offAllNamed(RouteConstant.auth);
    await Get.deleteAll();
  }

  static void pickImage(
      {required BuildContext context,
      required Function() onGalleryTap,
      required Function() onCameraTap}) async {
    await Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text(
            //   'Select Image Source',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: onGalleryTap,
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: onCameraTap,
            ),
          ],
        ),
      ),
    ));
  }

  static List<String> partnerList = [
    AppImagesConstant.partner1PNG,
    AppImagesConstant.partner2PNG,
    AppImagesConstant.partner3PNG,
    AppImagesConstant.partner4PNG,
    AppImagesConstant.partner5PNG,
    AppImagesConstant.ausGov2PNG,
  ];

  static Future<String> copyFileToPersistentStorage(
      String tempPath, bool isAudio) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = isAudio
        ? '${DateTime.now().millisecondsSinceEpoch}.wav'
        : '${DateTime.now().millisecondsSinceEpoch}.png';
    final newPath = '${directory.path}/$fileName';
    await File(tempPath).copy(newPath);
    // Save fileName (not newPath) persistently.
    return newPath;
  }
}
