import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';
import 'package:toastification/toastification.dart';

import '../../../add_worms/model/worm_model.dart';

class MyWormsControllers extends GetxController with StateMixin {
  static MyWormsControllers get instance => Get.find();

  RxList<WormModel> wormList = <WormModel>[].obs;

  final _firestore = FirebaseFirestore.instance;

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                       Fetch My Worms Data                            //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> fetchWorms() async {
    CommonAssets.enableFirestoreOfflineSupport(_firestore);
    wormList.clear();
    change(null, status: RxStatus.loading());
    try {
      CommonAssets.startFunctionPrint(
          title: "Fetching Worm Data from Firestore in MyWorms Controller");

      // Fetch all documents from the 'worm_list' collection where 'createdBy_uid' matches
      Query<Map<String, dynamic>> query = _firestore.collection('worm_list');

      query = query.where('createdBy_uid',
          isEqualTo: ProfileController.instance.fetchedUserData.value.uid);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await query.get(const GetOptions(source: Source.serverAndCache));

      // Check if documents exist
      if (querySnapshot.docs.isNotEmpty) {
        List<WormModel> worms = querySnapshot.docs.map((doc) {
          return WormModel.fromMap(doc.data());
        }).toList();

        CommonAssets.startFunctionPrint(
            title:
                "Worm Data Fetched Successfully in MyWorms Controller: $worms");

        wormList.value = worms;

        change(null, status: RxStatus.success());
      } else {
        CommonAssets.errorFunctionPrint(statusCodeMsg: "No Worm Data Found!");
        change(null, status: RxStatus.success());
      }
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Error fetching worm data: $e');
      change(null, status: RxStatus.error());
    }
  }

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                       Delete Worm and its images                     //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> deleteWorm(
      {required WormModel worm, required BuildContext context}) async {
    try {
      // Delete the worm document from Firestore
      await FirebaseFirestore.instance
          .collection('worm_list')
          .where('id', isEqualTo: worm.id)
          .get(const GetOptions(source: Source.serverAndCache))
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Delete worm images from the storage bucket
      for (String imageUrl in worm.wormsImg) {
        await deleteImage(imageUrl);
      }
      // Delete location images from the storage bucket
      await deleteImage(worm.locationImg);
      await fetchWorms();
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "Delete Succesfully",
            description: "Worm deleted Succesfully",
            type: ToastificationType.success);
      }

      CommonAssets.successFunctionPrint(
          title: 'Worm and images deleted successfully.');
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Error deleting worm and images: $e');
    }
  }

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //               Delete image from storage bucket                       //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imageUrl);
      await ref.delete();

      debugPrint('Image deleted successfully');
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    if (ProfileController.instance.fetchedUserData.value.uid.isEmpty) {
      await ProfileController.instance.fetchUserProfile();
      await fetchWorms();
    } else {
      await fetchWorms();
    }
  }
}
