class WormModel {
  final int createdOn;
  final String createdByUid;
  final String id;
  final String createdByEmail;
  final String createdByName;
  final bool isEnable;
  final String locationImg;
  final List<String> wormsImg;
  final String latLong;
  final String postalCode;
  final String country;
  final String administrativeArea;
  final String locality;
  final String note;
  final String audioUrl;
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
