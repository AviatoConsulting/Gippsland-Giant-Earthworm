import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/model/survey_model.dart';

class SampleVideoModel {
  String img;
  String videoLink;
  String title;
  int createdOn;
  String uniqueId;

  SampleVideoModel({
    required this.img,
    required this.videoLink,
    required this.title,
    required this.createdOn,
    required this.uniqueId,
  });

  // To Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'img': img,
      'video_link': videoLink,
      'title': title,
      'created_on': createdOn,
      'unique_id': uniqueId,
    };
  }

  // From Firestore
  factory SampleVideoModel.fromMap(Map<String, dynamic> map) {
    return SampleVideoModel(
      img: map['img'] ?? '',
      videoLink: map['video_link'] ?? '',
      title: map['title'] ?? '',
      createdOn: map['created_on'] ?? 0,
      uniqueId: map['unique_id'] ?? '',
    );
  }

  // Empty instance
  factory SampleVideoModel.empty() {
    return SampleVideoModel(
      img: '',
      videoLink: '',
      title: '',
      createdOn: 0,
      uniqueId: '',
    );
  }
}

class HomeScreenDataModel {
  List<SampleVideoModel> sampleVideos;
  String howDataWillBeUsed;
  List<SurveyModel> surveys; // New field for surveys

  HomeScreenDataModel({
    required this.sampleVideos,
    required this.howDataWillBeUsed,
    required this.surveys,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'sampleVideos': sampleVideos.map((video) => video.toMap()).toList(),
      'how_data_will_be_used': howDataWillBeUsed,
      'surveys': surveys
          .map((survey) => survey.toJson())
          .toList(), // Convert surveys to JSON
    };
  }

  // Create an instance from Firestore data
  factory HomeScreenDataModel.fromMap(Map<String, dynamic> map) {
    return HomeScreenDataModel(
      sampleVideos: List<SampleVideoModel>.from(
        (map['sampleVideos'] as List<dynamic>?)?.map(
              (item) => SampleVideoModel.fromMap(item as Map<String, dynamic>),
            ) ??
            [],
      ),
      howDataWillBeUsed: map['how_data_will_be_used'] ?? '',
      surveys: List<SurveyModel>.from(
        (map['surveys'] as List<dynamic>?)?.map(
              (item) => SurveyModel.fromJson(item as Map<String, dynamic>),
            ) ??
            [],
      ),
    );
  }

  // Empty instance
  factory HomeScreenDataModel.empty() {
    return HomeScreenDataModel(
      sampleVideos: [],
      howDataWillBeUsed: '',
      surveys: [],
    );
  }
}
