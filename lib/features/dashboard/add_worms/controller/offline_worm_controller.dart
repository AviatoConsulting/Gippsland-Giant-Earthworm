// Controller class to manage the state and business logic
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/utils/hive_service.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/audio_recording_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/offline_worms.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:image_picker/image_picker.dart';

class OfflineWormsController extends GetxController {
  static OfflineWormsController get instance => Get.find();

  // Observable variables
  final RxList<WormModel> wormList = <WormModel>[].obs;
  final RxBool isExpanded = false.obs;

  // Fetch all offline worms from Hive storage
  Future<void> getAllOfflineWorm({bool showDialog = false}) async {
    wormList.value = await HiveService().getAllWorms();

    if (wormList.isNotEmpty &&
        InternetCheckController.instance.isConnected.value == true &&
        showDialog) {
      Get.dialog(CommonAlertMessageDialog(
        title: "Upload worm site reminder",
        description:
            "You have offline worm site data that needs to be uploaded. Now that you’re back online, please ensure your data is synced to prevent any loss.",
        action: () {
          Get.back();
          DashboardController.instance.currentPageIndex.value = 1;
          Get.dialog(const OfflineWorms(), barrierDismissible: false);
        },
        buttonText: "Upload Now",
      ));
    }
  }

  // Toggle expansion state
  void toggleExpansion(bool value) {
    isExpanded.value = value;
  }

  // Handle worm selection and populate form
  void onWormSelected(WormModel worm) {
    // Update note field
    AddWormsController.instance.noteController.value.text = worm.note;

    // Update email field
    AddWormsController.instance.emailController.value.text =
        worm.createdByEmail;

    // Update location image
    AddWormsController.instance.locationSelectedImage.value = worm.locationImg;

    // Convert and update worm images
    AddWormsController.instance.wormImages.value =
        worm.wormsImg.map((e) => XFile(e)).toList();

    // Update latitude and longitude
    AddWormsController.instance.latLong.value = worm.latLong;

    // Update selected worm ID
    AddWormsController.instance.selectedUid.value = worm.id;

    // Update audio path if available
    if (worm.audioUrl.isNotEmpty) {
      RecordingController.instance.audioPath.value = worm.audioUrl;
      debugPrint('Audio path: ${RecordingController.instance.audioPath.value}');
      AddWormsController.instance.audioRecordingPath.value = worm.audioUrl;
    }
    AddWormsController.instance.update();
  }
}
