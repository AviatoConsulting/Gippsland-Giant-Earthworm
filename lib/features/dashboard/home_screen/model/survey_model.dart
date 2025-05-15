import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String title;
  final String link;
  final int createdOn;
  final String surveyId;

  SurveyModel({
    required this.title,
    required this.link,
    required this.createdOn,
    required this.surveyId,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'createdOn': createdOn,
      'surveyId': surveyId,
    };
  }

  // Create a SurveyModel instance from Firestore data
  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      title: json['title'] ?? "",
      link: json['link'] ?? "",
      createdOn: json['createdOn'] ?? 0,
      surveyId: json['surveyId'] ?? "",
    );
  }

  // Create a SurveyModel instance from a Firestore document
  factory SurveyModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SurveyModel.fromJson(data);
  }

  // Empty constructor with default values
  SurveyModel.empty()
      : title = '',
        link = '',
        createdOn = 0,
        surveyId = '';
}
