import 'package:hive/hive.dart';

part 'worm_model.g.dart'; // This will be auto-generated

@HiveType(typeId: 1)
class WormModel {
  @HiveField(0)
  final int createdOn;

  @HiveField(1)
  final String createdByUid;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final String createdByEmail;

  @HiveField(4)
  final String createdByName;

  @HiveField(5)
  final bool isEnable;

  @HiveField(6)
  final String locationImg;

  @HiveField(7)
  final List<String> wormsImg;

  @HiveField(8)
  final String latLong;

  @HiveField(9)
  final String postalCode;

  @HiveField(10)
  final String country;

  @HiveField(11)
  final String administrativeArea;

  @HiveField(12)
  final String locality;

  @HiveField(13)
  final String note;

  @HiveField(14)
  final String audioUrl;

  @HiveField(15)
  final String? search;

  WormModel({
    required this.createdOn,
    required this.createdByName,
    required this.id,
    required this.createdByUid,
    required this.createdByEmail,
    this.isEnable = true, // Default value set to true
    required this.locationImg,
    required this.wormsImg,
    required this.latLong,
    required this.postalCode,
    required this.country,
    required this.administrativeArea,
    required this.locality,
    required this.note,
    required this.audioUrl,
    this.search,
  });

  // Convert a WormModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'createdOn': createdOn,
      'id': id,
      'createdBy_uid': createdByUid,
      'createdBy_email': createdByEmail,
      'createdBy_name': createdByName,
      'isEnable': isEnable,
      'locationImg': locationImg,
      'worms_img': wormsImg,
      'latLong': latLong,
      'postalCode': postalCode,
      'country': country,
      'administrative_area': administrativeArea,
      'locality': locality,
      'note': note,
      'search': search,
      'audio_url': audioUrl,
    };
  }

  // Create a WormModel instance from a Map
  factory WormModel.fromMap(Map<String, dynamic> map) {
    return WormModel(
      createdOn: map['createdOn'],
      createdByUid: map['createdBy_uid'],
      createdByName: map['createdBy_name'] ?? "Not Available",
      id: map['id'],
      createdByEmail: map['createdBy_email'],
      isEnable: map['isEnable'] ?? true, // Default to true if null
      locationImg: map['locationImg'],
      // locationImg: "",

      // wormsImg: [],
      wormsImg: List<String>.from(map['worms_img']),
      latLong: map['latLong'],
      postalCode: map['postalCode'],
      country: map['country'],
      administrativeArea: map['administrative_area'],
      locality: map['locality'],
      note: map['note'],
      search: map['search'],
      audioUrl: map['audio_url'] ?? "",
    );
  }

  @override
  String toString() {
    return 'WormModel(id: $id, createdOn: $createdOn, createdBy: $createdByName, email: $createdByEmail, '
        'locationImg: $locationImg, wormsImg: $wormsImg, latLong: $latLong, postalCode: $postalCode, '
        'country: $country, administrativeArea: $administrativeArea, locality: $locality, '
        'note: $note, audioUrl: $audioUrl, search: $search)';
  }

  WormModel.empty()
      : createdOn = 0,
        id = '',
        createdByUid = '',
        createdByName = "",
        createdByEmail = '',
        isEnable = true,
        locationImg = '',
        wormsImg = [],
        latLong = '',
        postalCode = '',
        country = '',
        administrativeArea = '',
        locality = '',
        note = '',
        audioUrl = '',
        search = '';
}
