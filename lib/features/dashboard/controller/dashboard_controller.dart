import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/add_worms_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/home_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/resources/view/resources_screen.dart';

class DashboardController extends GetxController with StateMixin {
  static DashboardController get instance => Get.find();
  RxInt currentPageIndex = 0.obs;

  RxList<Widget> pages = <Widget>[
    const HomeScreen(),
    const AddWormsScreen(),
    const ResourcesScreen(),
    const ProfileScreen(),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3))
        .then((value) => ProfileController.instance.fetchUserProfile());
    change(null, status: RxStatus.success());
  }
}
