import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/helper/shared_pref_helper.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

class ProfileController extends GetxController with StateMixin {
  static ProfileController get instance => Get.find();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString uid = "".obs;
  RxString supportEmail = "joel.geoghegan@basscoastlandcare.org.au".obs;

  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> birthdateController = TextEditingController().obs;
  RxInt selectedRewardDate = 0.obs;
  Rx<UserModel> fetchedUserData =
      UserModel(uid: "", username: "", email: "", createdOn: 0).obs;

  RxBool isProfileImageSelected = false.obs;
  RxString selectedImage = "".obs;
  ImagePicker picker = ImagePicker();
  XFile? file;

  void pickImg({required BuildContext context}) async {
    file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      selectedImage.value = file!.path;
      isProfileImageSelected.value = true;
      debugPrint("select :${selectedImage.value}");
      update();
    } else {
      isProfileImageSelected.value = false;
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "No Image Selected",
            description: "No Image Selected, Please Select a Image.");
      }
    }
  }

  void deleteImg() {
    file = null;
    selectedImage.value = "";
    isProfileImageSelected.value = false;
  }

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                           Fetching Profile                           //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> fetchUserProfile() async {
    CommonAssets.enableFirestoreOfflineSupport(firestore);

    change(null, status: RxStatus.success());
    uid.value = FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      CommonAssets.startFunctionPrint(
          title: "Fetching User Profile in Profile Controller");
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('user_details')
          .doc(uid.value)
          .get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.exists) {
        CommonAssets.startFunctionPrint(
            title:
                "Profile Fetched Succesfully: ${UserModel.fromMap(snapshot.data()!)}");
        fetchedUserData.value = UserModel.fromMap(snapshot.data()!);
        setData();
        await updateLastLoginTime(uniqueId: fetchedUserData.value.uid);
        GetStorageHelper().storeData('email', fetchedUserData.value.email);
        change(null, status: RxStatus.success());
      } else {
        CommonAssets.errorFunctionPrint(statusCodeMsg: "User Not Found!");
        change(null, status: RxStatus.success());
      }
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Error fetching user profile: $e');
      change(null, status: RxStatus.success());
    }
  }

  //====================== After Fetching Data Set Data =======================
  void setData() {
    usernameController.value.text = fetchedUserData.value.username;
    mobileNumberController.value.text = fetchedUserData.value.mobile ?? "";
    birthdateController.value.text = fetchedUserData.value.birthdate == 0
        ? ""
        : CommonAssets.timestampToDate(fetchedUserData.value.birthdate ?? 0);
  }

  //**********************************************************************//
  //----------------------------------------------------------------------//
  //                          Updating  Profile                           //
  //----------------------------------------------------------------------//
  //**********************************************************************//
  Future<void> updateUserDetails({required BuildContext context}) async {
    change(null, status: RxStatus.loading());
    String? profileImg = "";
    if (selectedImage.value.isNotEmpty) {
      profileImg = await uploadProfileImages();
    }
    try {
      CommonAssets.startFunctionPrint(
          title: "Updating User Details in Profile Controller");
      final userRef = firestore
          .collection('user_details')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final UserModel updatedUser = UserModel(
          createdOn: fetchedUserData.value.createdOn,
          uid: fetchedUserData.value.uid,
          username: usernameController.value.text.trim(),
          email: fetchedUserData.value.email,
          birthdate: selectedRewardDate.value,
          mobile: mobileNumberController.value.text.trim(),
          profileImg: isProfileImageSelected.value
              ? profileImg
              : fetchedUserData.value.profileImg);
      await userRef.update(updatedUser.toMap());
      CommonAssets.successFunctionPrint(
          title: "User Details Updated Successfully");
      selectedImage.value = "";
      isProfileImageSelected.value = false;
      if (context.mounted) {
        showCommonToast(
            context: context,
            type: ToastificationType.success,
            title: "Success",
            description: "Profile Update Succesfully");
      }
      await fetchUserProfile();
    } catch (e) {
      if (context.mounted) {
        showCommonToast(
            context: context,
            title: "Error",
            description: "Something went wrong, please try again later.");
      }
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Error updating user details: $e');
      change(null, status: RxStatus.success());
    }
  }

  // ================== Upload Images ==================
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<String?> uploadProfileImages() async {
    try {
      CommonAssets.startFunctionPrint(
          title: "Image Uploading in Profile Controller");

      final storageRef = firebaseStorage.ref().child(fetchedUserData.value.uid);
      String imageName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      UploadTask uploadTask;

      uploadTask = storageRef.child(imageName).putData(
            await file!.readAsBytes(),
          );

      // Wait for the upload task to complete
      TaskSnapshot snapshot = await uploadTask;
      FullMetadata metadata = await snapshot.ref.getMetadata();
      String? gcsToken = metadata.fullPath;

      CommonAssets.successFunctionPrint(
          title: "Image Uploaded Successfully in Profile Controller");

      return gcsToken;
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'ProfileController: Error uploading images: $e');
      return null;
    }
  }

  Future<void> updateLastLoginTime({required String uniqueId}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query the collection to find the document with the matching uid
      QuerySnapshot querySnapshot = await firestore
          .collection('user_details')
          .where('uid', isEqualTo: uniqueId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one document with this uid
        DocumentReference docRef = querySnapshot.docs.first.reference;

        // Update the lastLoginTime field
        await docRef.update({
          'last_login_timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        });

        CommonAssets.startFunctionPrint(
            title: 'Last login time updated successfully for UID: $uniqueId');
      } else {
        CommonAssets.errorFunctionPrint(
            statusCodeMsg: 'No document found with the uid: $uniqueId');
      }
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Failed to update last login time: $e');
    }
  }

  Future<String> fetchSupportEmail() async {
    const String defaultEmail = 'joel.geoghegan@basscoastlandcare.org.au';

    try {
      // Reference the Firestore instance and collection/document
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('reference')
          .doc('support_email')
          .get();

      // Check if the document exists and contains the 'email' field
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('email')) {
          return data['email'] as String; // Return the fetched email
        }
      }
    } catch (e) {
      debugPrint('Error fetching support email: $e');
    }

    // Return the default email if not found or an error occurs
    return defaultEmail;
  }

  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.success());
    supportEmail.value = await fetchSupportEmail();
    await fetchUserProfile();
  }
}
