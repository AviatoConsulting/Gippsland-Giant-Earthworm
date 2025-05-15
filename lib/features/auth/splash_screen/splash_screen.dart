import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';

import '../../../core/constants/common_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchTermsAndPrivacy();

    InternetCheckController.instance.initConnectionCheck();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (mounted) {
        // Check if the widget is still mounted
        CustomNavigationHelper.navigateTo(
          context: context,
          routeName: RouteConstant.auth,
          replace: true,
        );
      }
    });
  }

  // Fetch Terms & Conditions and Privacy Policy document from Firestore
  Future<void> fetchTermsAndPrivacy() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('reference')
          .doc('policies')
          .get();

      if (snapshot.exists) {
        CommonAssets.termsAndConditionUrl = snapshot.data()?['term_condition'];
        CommonAssets.privacyPolicyUrl = snapshot.data()?['privacy_policy'];
      } else {
        debugPrint('Document does not exist.');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "GGE",
                      style: textTheme.headlineLarge!
                          .copyWith(fontSize: 38, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Giant Gippsland Earthworm",
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Funded By:",
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Image.asset(
              AppImagesConstant.ausGovLogoPNG,
              scale: 2.8,
            ),
          ],
        ),
      ),
    );
  }
}
