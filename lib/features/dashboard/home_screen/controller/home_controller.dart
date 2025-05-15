import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/helper/shared_pref_helper.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/model/survey_model.dart';
import '../../profile/profile_controller.dart';
import '../model/home_screen_model.dart';

class HomeController extends GetxController with StateMixin {
  static HomeController get instance => Get.find();

  RxList<WormModel> wormList = <WormModel>[].obs;

  Rx<HomeScreenDataModel> homeScreenModel = HomeScreenDataModel.empty().obs;
  RxList<SurveyModel> surveyList = <SurveyModel>[].obs;

  DocumentSnapshot? _lastDocument; // To store the last document for pagination

  RxBool isMoreDataLoading = false.obs; // To show loading indicator
  RxBool hasMoreData = true.obs; // To check if more data is available

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Schedule heavy tasks after first frame is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  Future<void> _initializeControllers() async {
    AddWormsController.instance.emailController.value.text =
        GetStorageHelper().getData('email') ?? "";
    fetchHomeScreenDataOnce();

    // // After wait fetch worm data
    // Future.delayed(const Duration(seconds: 5)).then((s) {
    // fetchWormData(isFetchMore: false);
    // });
  }

  Future<void> fetchHomeScreenDataOnce() async {
    try {
      CommonAssets.enableFirestoreOfflineSupport(_firestore);

      // Fetch 'sample_video' document
      final sampleVideoDoc = await _firestore
          .collection('homescreen')
          .doc('sample_video')
          .get(const GetOptions(source: Source.serverAndCache));

      final List<dynamic> videosList = sampleVideoDoc.data()?['videos'] ?? [];
      final List<SampleVideoModel> sampleVideos = videosList.map((videoMap) {
        return SampleVideoModel.fromMap(videoMap as Map<String, dynamic>);
      }).toList();

      // Fetch 'how_data_will_used' document
      final howDataDoc = await _firestore
          .collection('homescreen')
          .doc('how_data_will_used')
          .get(const GetOptions(source: Source.serverAndCache));

      final String howDataWillBeUsed =
          howDataDoc.data()?['how_data_will_used'] ?? '';

      // Fetch 'survey' document
      final surveyDoc = await _firestore
          .collection('homescreen')
          .doc('survey')
          .get(const GetOptions(source: Source.serverAndCache));

      final List<dynamic> surveyList = surveyDoc.data()?['surveys'] ?? [];
      final List<SurveyModel> surveys = surveyList.map((surveyMap) {
        return SurveyModel.fromJson(surveyMap as Map<String, dynamic>);
      }).toList();

      final model = HomeScreenDataModel(
        sampleVideos: sampleVideos,
        howDataWillBeUsed: howDataWillBeUsed,
        surveys: surveys,
      );

      homeScreenModel.value = model;
      // Fetch if video is empty else fetch after video loaded
      if (homeScreenModel.value.sampleVideos.isEmpty) {
        debugPrint("Sample Videos are empty");
        fetchWormData(isFetchMore: false);
      }
      change(homeScreenModel, status: RxStatus.success());
    } catch (e) {
      debugPrint("Error fetching home screen data: $e");
      change(homeScreenModel, status: RxStatus.success());
    }
  }

  // This method fetches the worm data with cursor-based pagination
  Future<void> fetchWormData({bool isFetchMore = false}) async {
    if (ProfileController.instance.fetchedUserData.value.uid.isEmpty) {
      await ProfileController.instance.fetchUserProfile();
    }
    try {
      CommonAssets.startFunctionPrint(title: "Fetching Worm Data");

      // Start query
      Query query = _firestore
          .collection('worm_list')
          .where('createdBy_uid',
              isEqualTo: ProfileController.instance.fetchedUserData.value.uid)
          .orderBy("createdOn", descending: true)
          .limit(10);

      // Apply cursor pagination if there's a last document
      if (_lastDocument != null) {
        isMoreDataLoading.value = true; // Show loading indicator
        query = query.startAfterDocument(_lastDocument!);
      } else {
        change(wormList, status: RxStatus.loading());
      }

      // Get the documents from Firestore
      QuerySnapshot querySnapshot = await query.get();

      // Explicitly cast the QuerySnapshot to QuerySnapshot<Map<String, dynamic>>
      QuerySnapshot<Map<String, dynamic>> typedQuerySnapshot =
          querySnapshot as QuerySnapshot<Map<String, dynamic>>;

      // If there are documents, process them
      if (typedQuerySnapshot.docs.isNotEmpty) {
        List<WormModel> worms = typedQuerySnapshot.docs.map((doc) {
          return WormModel.fromMap(doc.data());
        }).toList();

        if (isFetchMore) {
          wormList.addAll(worms);
        } else {
          wormList.value = worms;
        }

        debugPrint(
            "Worms Length: ${wormList.length} Fetched: ${worms.length} Last: ${_lastDocument?.id}");

        // Update the last document for pagination
        _lastDocument = typedQuerySnapshot.docs.last;

        change(wormList, status: RxStatus.success());
      } else {
        hasMoreData.value = false; // No more data available
        CommonAssets.errorFunctionPrint(statusCodeMsg: "No Worm Data Found!");
        change(wormList, status: RxStatus.success());
      }
    } catch (e) {
      CommonAssets.errorFunctionPrint(
          statusCodeMsg: 'Error fetching worm data: $e');
      change(wormList, status: RxStatus.success());
    } finally {
      isMoreDataLoading.value = false; // Hide loading indicator
    }
  }

  // This method can be called to fetch more data for pagination
  Future<void> fetchNextPage() async {
    if (_lastDocument != null) {
      await fetchWormData(isFetchMore: true); // Fetch next page of data
    } else {
      CommonAssets.errorFunctionPrint(statusCodeMsg: "No more data available!");
    }
  }
}
