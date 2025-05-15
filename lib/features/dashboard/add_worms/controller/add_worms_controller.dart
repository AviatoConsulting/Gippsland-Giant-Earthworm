// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/utils/hive_service.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/audio_recording_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/location_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/offline_worm_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/home_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class AddWormsController extends GetxController with StateMixin {
  static AddWormsController get instance => Get.find();

  // Controller for the note text input field
  Rx<TextEditingController> noteController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;

  // Firebase Storage instance for uploading files
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // Variables for storing lat/long and audio recording path
  RxString latLong = "".obs;
  RxString audioRecordingPath = "".obs;
  RxString selectedLocation = "".obs;
  RxString selectedUid = "".obs;

  RxString? audioPath;

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                              Add New Worm                            //
  //----------------------------------------------------------------------//
  //**********************************************************************//

  addNewWorm({required BuildContext context}) async {
    if (InternetCheckController.instance.isConnected.value == true) {
      await addNewWormToDatabase(context: context);
    } else {
      await saveWormLocally(context);
    }
  }

  // Method to save worm data locally
  Future<void> saveWormLocally(BuildContext context) async {
    String locationImg = "";
    if (locationSelectedImage.value.isNotEmpty) {
      locationImg = await CommonAssets.copyFileToPersistentStorage(
          locationSelectedImage.value, false);
    }
    final List<String> worms = <String>[];
    if (wormImages.isNotEmpty) {
      for (XFile file in wormImages) {
        String path =
            await CommonAssets.copyFileToPersistentStorage(file.path, false);
        worms.add(path);
      }
    }
    String offlineAudioPath = "";
    if (audioRecordingPath.value.isNotEmpty) {
      offlineAudioPath = await CommonAssets.copyFileToPersistentStorage(
          audioRecordingPath.value, true);
    }

    // Create the WormModel object with all necessary data
    WormModel offlineWormModel = WormModel(
        id: const Uuid().v1(),
        createdByName:
            ProfileController.instance.fetchedUserData.value.username,
        createdOn: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        createdByUid: ProfileController.instance.fetchedUserData.value.uid,
        createdByEmail: emailController.value.text.trim(),
        locationImg: locationImg,
        wormsImg: worms,
        latLong: latLong.value,
        audioUrl: offlineAudioPath,
        postalCode: "",
        country: "",
        administrativeArea: "",
        locality: "",
        note: noteController.value.text.trim(),
        search: "");
    await HiveService().saveWorm(offlineWormModel);
    OfflineWormsController.instance.getAllOfflineWorm();
    Get.dialog(
        CommonAlertMessageDialog(
          icon: "assets/icons/done.png",
          iconHeight: 120,
          title: "",
          description:
              "The worm site has been saved locally.  You can upload it to the database once an internet connection is available.",
          action: () {
            Get.back();
            clearData();
          },
          cancelAction: () {
            Get.back();
            clearData();
            DashboardController.instance.currentPageIndex.value = 0;
          },
          cancelText: "Go to home",
          buttonText: "Add another Worm Site",
        ),
        barrierDismissible: false);
  }

  // Method to add a new worm to the Firestore database
  Future<void> addNewWormToDatabase({required BuildContext context}) async {
    change(null, status: RxStatus.loading()); // Change state to loading
    // Debug print for checking data
    CommonAssets.startFunctionPrint(title: "Adding New Worm Data in Firestore");
    if (ProfileController.instance.fetchedUserData.value.uid.isEmpty) {
      await ProfileController.instance.fetchUserProfile();
    }
    try {
      if (LocationController.instance.placemarks.isEmpty &&
          latLong.isNotEmpty) {
        LocationController.instance.placemarks.value =
            await placemarkFromCoordinates(
                double.tryParse(latLong.split(",")[0]) ?? 0,
                double.tryParse(latLong.split(",")[1]) ?? 0);
      }

      // Upload the location image
      String locationImg = "";
      if (locationSelectedImage.value.isNotEmpty) {
        locationImg =
            (await uploadImages(images: [locationSelectedImage.value])).first;
      }

      // Upload the worm images
      List<String> wormImg = <String>[];

      if (wormImages.isNotEmpty) {
        wormImg = await uploadImages(images: wormImages);
      }

      // Variable to store audio URL if audio is recorded
      String aURL = "";
      if (audioRecordingPath.value.isNotEmpty) {
        aURL = await uploadRecording(audioPath: audioRecordingPath.value);
      }

      // Create the WormModel object with all necessary data
      WormModel addWormModel = WormModel(
          id: selectedUid.value.isNotEmpty
              ? selectedUid.value
              : const Uuid().v1(),
          createdByName:
              ProfileController.instance.fetchedUserData.value.username,
          createdOn: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          createdByUid: ProfileController.instance.fetchedUserData.value.uid,
          createdByEmail: emailController.value.text.trim(),
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

      // Show success toast message
      if (context.mounted) {
        showCommonToast(
            context: context,
            type: ToastificationType.success,
            title: "Added",
            description: "New Worm added successfully");
      }
      if (selectedUid.value.isNotEmpty) {
        HiveService().deleteWorm(selectedUid.value);
        OfflineWormsController.instance.getAllOfflineWorm();
      }
      // Debug print for success
      CommonAssets.successFunctionPrint(
          title: "New Worm Added Successfully in Firestore");

      // Change state to success
      change(null, status: RxStatus.success());
      HomeController.instance.fetchWormData(isFetchMore: false);
      // Clear the data after successful submission
      clearData();
    } catch (e) {
      // Handle errors and change state to success (even if failed)
      change(null, status: RxStatus.error());
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

  Future<void> pickLocationImg({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50, // Reduce quality (1-100)
      );

      if (pickedFile != null) {
        locationSelectedImage.value = pickedFile.path;
        update(); // Update UI if using GetX
      } else {
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "No Location Image Selected",
            description: "No Location Image Selected, Please Select an Image.",
          );
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        // Handle denied permission error
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Permission Denied",
            description:
                "Photo access is denied. Please enable it in settings.",
          );
          openAppSettings();
        }
      } else {
        // Handle other platform exceptions
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Error",
            description: "Something went wrong: ${e.message}",
          );
        }
      }
    } catch (e) {
      // Handle unexpected errors
      if (context.mounted) {
        showCommonToast(
          context: context,
          title: "Error",
          description: "An unexpected error occurred: ${e.toString()}",
        );
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
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        // Handle denied permission error
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Permission Denied",
            description:
                "Photo access is denied. Please enable it in settings.",
          );
          openAppSettings();
        }
      } else {
        // Handle other platform exceptions
        if (context.mounted) {
          showCommonToast(
            context: context,
            title: "Error",
            description: "Something went wrong: ${e.message}",
          );
        }
      }
    } catch (e) {
      // Handle unexpected errors
      if (context.mounted) {
        showCommonToast(
          context: context,
          title: "Error",
          description: "An unexpected error occurred: ${e.toString()}",
        );
      }
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
    selectedUid.value = "";
    locationSelectedImage.value = "";

    wormImages.clear();
    noteController.value.clear(); // Clear the note text
    RecordingController.instance.deleteRecording(); //Clear Recording
    audioRecordingPath.value = "";
    RecordingController.instance.audioPath.value = null; //Clear Recording
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
