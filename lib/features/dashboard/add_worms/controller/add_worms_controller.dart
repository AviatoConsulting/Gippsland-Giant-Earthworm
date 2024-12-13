// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/location_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class AddWormsController extends GetxController with StateMixin {
  static AddWormsController get instance => Get.find();

  // Controller for the note text input field
  Rx<TextEditingController> noteController = TextEditingController().obs;

  // Firebase Storage instance for uploading files
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // Variables for storing lat/long and audio recording path
  RxString latLong = "".obs;
  RxString audioRecordingPath = "".obs;

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                              Add New Worm                            //
  //----------------------------------------------------------------------//
  //**********************************************************************//

  // Method to add a new worm to the Firestore database
  Future<void> addNewWorm({required BuildContext context}) async {
    change(null, status: RxStatus.loading()); // Change state to loading
    try {
      // Upload the location image
      final String locationImg =
          (await uploadImages(images: [locationSelectedImage.value])).first;

      // Upload the worm images
      final List<String> wormImg = await uploadImages(images: wormImages);

      // Variable to store audio URL if audio is recorded
      String aURL = "";
      if (audioRecordingPath.value.isNotEmpty) {
        aURL = await uploadRecording(audioPath: audioRecordingPath.value);
      }

      // Debug print for checking data
      CommonAssets.startFunctionPrint(
          title: "Adding New Worm Data in Firestore");

      // Create the WormModel object with all necessary data
      WormModel addWormModel = WormModel(
          id: const Uuid().v1(),
          createdByName:
              ProfileController.instance.fetchedUserData.value.username,
          createdOn: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          createdByUid: ProfileController.instance.fetchedUserData.value.uid,
          createdByEmail:
              ProfileController.instance.fetchedUserData.value.email,
          locationImg: locationImg,
          wormsImg: wormImg,
          latLong: latLong.value,
          audioUrl: aURL,
          postalCode:
              LocationController.instance.placemarks.first.postalCode ?? "",
          country: LocationController.instance.placemarks.first.country ?? "",
          administrativeArea:
              LocationController.instance.placemarks.first.administrativeArea ??
                  "",
          locality: LocationController.instance.placemarks.first.locality ?? "",
          note: noteController.value.text.trim(),
          search:
              "${LocationController.instance.placemarks.first.country} ${LocationController.instance.placemarks.first.administrativeArea} ${LocationController.instance.placemarks.first.locality} ${LocationController.instance.placemarks.first.postalCode}"
                  .toLowerCase());

      // Debug print for the worm model object
      debugPrint("Worm Model: $addWormModel");

      // Store the worm data in Firestore under the 'worm_list' collection
      await FirebaseFirestore.instance
          .collection('worm_list')
          .doc()
          .set(addWormModel.toMap());

      // Display dialog after successful addition
      await Get.dialog(CommonAlertMessageDialog(
          title: "Your Worm photos has been added!",
          description: "",
          icon: AppImagesConstant.doneIconPNG,
          cancelText: "Go to home",
          buttonText: "Add another worm",
          cancelAction: () {
            DashboardController.instance.currentPageIndex.value = 0;
            Get.back();
          },
          action: () => Get.back()));

      // Show success toast message
      if (context.mounted) {
        showCommonToast(
            context: context,
            type: ToastificationType.success,
            title: "Added",
            description: "New Worm added successfully");
      }

      // Debug print for success
      CommonAssets.successFunctionPrint(
          title: "New Worm Added Successfully in Firestore");

      // Change state to success
      change(null, status: RxStatus.success());

      // Clear the data after successful submission
      clearData();
    } catch (e) {
      // Handle errors and change state to success (even if failed)
      change(null, status: RxStatus.success());
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "Error",
            description: "Error Adding New Worm, Please try again Later.");
      }
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: "Error Adding New Worm in Firestore: $e");
    }
  }

  //====================== For Location Photos =======================
  RxString locationSelectedImage = "".obs; // Variable for location image
  ImagePicker picker = ImagePicker(); // Image picker instance
  XFile? file; // To store the selected image file

  // Method to pick location image
  Future<void> pickLocationImg(
      {required BuildContext context, required ImageSource source}) async {
    file = await picker.pickImage(source: source);
    if (file != null) {
      locationSelectedImage.value = file!.path;
      update(); // Update the UI
    } else {
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "No Location Image Selected",
            description: "No Location Image Selected, Please Select a Image.");
      }
    }
  }

  //====================== For Worm Photos =======================
  RxList<XFile> wormImages = <XFile>[].obs; // List of worm images
  RxList<String> fetchImgUrlList = <String>[].obs; // List to store image URLs

  // Method to pick worm images
  Future<void> pickImages({
    required BuildContext context,
    required ImageSource source,
    bool allowMultiple = false,
  }) async {
    try {
      if (source == ImageSource.gallery && allowMultiple) {
        // Pick multiple images from gallery
        List<XFile>? pickedImages =
            await picker.pickMultiImage(imageQuality: 50);
        if (pickedImages != null) {
          wormImages.addAll(pickedImages); // Add to wormImages list
        } else {
          if (context.mounted) {
            showCommonToast(
                context: context,
                title: "No Worm Image Selected",
                description:
                    "No Worm habitat Image Selected, Please Select a Image.");
          }
        }
      } else {
        // Pick a single image from camera or gallery
        XFile? pickedImage =
            await picker.pickImage(source: source, imageQuality: 50);
        if (pickedImage != null) {
          wormImages.add(pickedImage); // Add to wormImages list
        } else {
          if (context.mounted) {
            showCommonToast(
                context: context,
                title: "No Worm Image Selected",
                description:
                    "No Worm habitat Image Selected, Please Select a Image.");
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  // Method to remove an image from the wormImages list
  void removeImage(int index) {
    wormImages.removeAt(index); // Remove the image at the specified index
  }

  //====================== Upload Worms Photos =======================
  // Method to upload worm images to Firebase Storage
  Future<List<String>> uploadImages({required List<dynamic> images}) async {
    List<String> fetchImgUrlList = [];
    try {
      final storageRef = firebaseStorage.ref().child("worm_images");

      for (var image in images) {
        final File file = image is XFile ? File(image.path) : File(image);
        final imageName =
            "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg"; // Generate unique image name
        final uploadTask = storageRef.child(imageName).putFile(file);

        await uploadTask.whenComplete(() async {
          final temp = await storageRef.child(imageName).getMetadata();
          String imageUrl = temp.fullPath;
          fetchImgUrlList.add(imageUrl); // Add image URL to the list
        });
      }
    } catch (e) {
      debugPrint('AddWorm Controller: Error uploading images: $e');
    }

    return fetchImgUrlList; // Return list of uploaded image URLs
  }

  // Method to clear all the collected data
  void clearData() {
    latLong.value = "";
    locationSelectedImage.value = "";
    wormImages.clear();
    noteController.value.clear(); // Clear the note text
  }

  //====================== Upload Audio =======================
  // Method to upload audio recordings to Firebase Storage
  Future<String> uploadRecording({required String audioPath}) async {
    String fileURL = "";
    CommonAssets.startFunctionPrint(
        title: "Adding Recording to Firebase started!");
    try {
      final storageRef = FirebaseStorage.instance.ref().child("recordings");
      final fileName = path.basename(audioPath);
      final fileRef = storageRef.child(fileName);

      // Upload to Firebase Storage
      final uploadTask = fileRef.putFile(File(audioPath));

      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded file
        final temp = await fileRef.getMetadata();
        fileURL = temp.fullPath;
      });

      CommonAssets.successFunctionPrint(
          title: "Recording added to bucket: $fileURL");
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'AddWorm Controller: Error uploading audio: $e');
    }
    return fileURL; // Return the file URL of the uploaded audio
  }

  // onInit method for initialization tasks
  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.success()); // Change state to success
  }
}
