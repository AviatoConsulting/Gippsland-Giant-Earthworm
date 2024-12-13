import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';

import '../model/home_screen_model.dart';

class HomeController extends GetxController with StateMixin {
  static HomeController get instance => Get.find();

  RxList<WormModel> wormList = <WormModel>[].obs;
  RxList<WormModel> filteredWormList = <WormModel>[].obs;
  RxList<String> pincodeList = <String>[].obs;

  RxBool isExapand = false.obs;
  RxBool isSearch = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxBool isPincodeSelected = false.obs;
  Timer? debounce;

  Rx<HomeScreenDataModel> homeScreenModel = HomeScreenDataModel.empty().obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Function to listen to the homescreen collection and its subcollections
  void listenHomeScreenData() {
    debugPrint("Starteddd");
    _firestore
        .collection('homescreen')
        .snapshots()
        .listen((querySnapshot) async {
      try {
        debugPrint("sampleVideoDoc:1");

        // Get the 'sample_video' document
        DocumentSnapshot<Map<String, dynamic>> sampleVideoDoc = await _firestore
            .collection('homescreen')
            .doc('sample_video') // Document ID for sample_video
            .get();

        debugPrint("sampleVideoDoc: ${sampleVideoDoc.data()}");

        // Extract the 'videos' field, which is a list of maps
        List<dynamic> videosList = sampleVideoDoc.data()?['videos'] ?? [];
        debugPrint("Videos: ${videosList.length}");

        // Map the list of maps to a list of SampleVideoModel
        List<SampleVideoModel> sampleVideos = videosList.map((videoMap) {
          return SampleVideoModel.fromMap(videoMap as Map<String, dynamic>);
        }).toList();

        // Fetch the 'how_data_will_be_used' document
        DocumentSnapshot<Map<String, dynamic>> howDataDoc = await _firestore
            .collection('homescreen')
            .doc('how_data_will_used') // Document ID for how_data_will_be_used
            .get();

        // Extract the 'how_data_will_be_used' value
        String howDataWillBeUsed =
            howDataDoc.data()?['how_data_will_used'] ?? '';

        final model = HomeScreenDataModel(
          sampleVideos: sampleVideos,
          howDataWillBeUsed: howDataWillBeUsed,
        );
        homeScreenModel.value = model;
        change(null, status: RxStatus.success());
      } catch (e) {
        debugPrint("Error fetching home screen data: $e");
        change(null, status: RxStatus.error());
      }
    });
  }

  // Listen to Firestore stream for real-time data
  void listenToWormStream() {
    CommonAssets.startFunctionPrint(title: "Listening to Worm Data Stream");

    FirebaseFirestore.instance
        .collection('worm_list')
        .orderBy("createdOn", descending: true)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      try {
        if (querySnapshot.docs.isNotEmpty) {
          List<WormModel> worms = querySnapshot.docs.map((doc) {
            return WormModel.fromMap(doc.data());
          }).toList();

          wormList.value = worms;

          // Extract unique pincodes
          pincodeList.value = worms
              .where((worm) => worm.postalCode.isNotEmpty)
              .map((worm) => worm.postalCode)
              .toSet()
              .toList(); // Convert to Set for unique values

          debugPrint("Pincodes: ${pincodeList.toString()}");

          change(null, status: RxStatus.success());
          CommonAssets.startFunctionPrint(title: "Worm Data Updated: $worms");
        } else {
          CommonAssets.errorFunctionPrint(statusCodeMsg: "No Worm Data Found!");
          change(null, status: RxStatus.success());
        }
      } catch (e) {
        CommonAssets.errorFunctionPrint(
            statusCodeMsg: 'Error processing worm data: $e');
        change(null, status: RxStatus.error());
      }
    });
  }

  void clearSearch() {
    searchController.value.text = "";
    isSearch.value = false;
    listenToWormStream();
  }

  @override
  void onInit() {
    super.onInit();
    listenHomeScreenData();
    listenToWormStream();
  }
}
