import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/route_list.dart';
import 'package:giant_gipsland_earthworm_fe/core/helper/shared_pref_helper.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_themes.dart';
import 'package:giant_gipsland_earthworm_fe/core/utils/hive_service.dart';
import 'package:giant_gipsland_earthworm_fe/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';
import 'package:go_router/go_router.dart';

bool get isUseGoRouter => false;
bool get isDebuggingOnStart => true;
bool get isDebuggingOnSuccess => true;
bool get isDebuggingOnError => true;

void main() async {
  // MapboxOptions.setAccessToken(mapBoxAccessToken);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  await firebase.Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalytics.instance
      .setAnalyticsCollectionEnabled(true)
      .then((value) => debugPrint("Enable Google Analytics"));

  if (kReleaseMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return true;
    };
  }

  await HiveService.init();
  await GetStorageHelper().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (isUseGoRouter) {
      final router = GoRouter(
        navigatorKey: Get.key,
        initialLocation:
            kIsWeb ? RouteConstant.deleteAccount : RouteConstant.splash,
        routes: GetRoutesPages.getGoRouterRoutes(),
      );
      return GetMaterialApp.router(
          locale: const Locale('en', 'US'),
          title: 'GGE Census',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.light,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          backButtonDispatcher: RootBackButtonDispatcher(),
          useInheritedMediaQuery: true,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                        MediaQuery.of(context).size.width > 1280 ? 1 : 0.9)),
                child: child!);
          });
    } else {
      return GetMaterialApp(
          // translations: Localization(),
          locale: const Locale('en', 'US'),
          title: 'GGE Census',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.light,
          initialRoute:
              kIsWeb ? RouteConstant.deleteAccount : RouteConstant.splash,
          getPages: GetRoutesPages.getGetXPages(),
          useInheritedMediaQuery: true,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                        MediaQuery.of(context).size.width > 1280 ? 1 : 0.9)),
                child: child!);
          });
    }
  }
}
