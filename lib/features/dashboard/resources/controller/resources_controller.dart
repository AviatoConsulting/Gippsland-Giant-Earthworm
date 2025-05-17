import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/resources/model/resource_model.dart';

class ResourcesController extends GetxController with StateMixin {
  // Singleton instance for accessing the controller
  static ResourcesController get instance => Get.find();

  // Firebase Firestore instance to interact with Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list to hold the list of resources
  RxList<ResourceModel> resourcesList = <ResourceModel>[].obs;

  // Function to listen to real-time updates in the 'resources' collection
  void listenToResources() {
    CommonAssets.enableFirestoreOfflineSupport(_firestore);

    // Listening to changes in the 'resources' collection in Firestore
    _firestore.collection('resources').snapshots().listen((snapshot) {
      // Mapping the snapshot data to ResourceModel and updating the list
      resourcesList.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ResourceModel.fromMap(
            data); // Converting document data to ResourceModel
      }).toList();

      // Notify the UI that the data has been successfully fetched
      change(null, status: RxStatus.success());

      // Debug print to show updated resources list in the console
      debugPrint("Resources List updated: $resourcesList");
    });
  }

  @override
  void onInit() {
    super.onInit();
    // Start listening to resources when the controller is initialized
    listenToResources();
  }
}
