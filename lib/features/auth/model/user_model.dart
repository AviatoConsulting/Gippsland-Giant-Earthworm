class UserModel {
  String uid;
  String username;
  String email;
  String? mobile;
  int? birthdate;
  String? profileImg;
  int createdOn;

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      this.mobile,
      this.birthdate,
      required this.createdOn,
      this.profileImg});

  // Convert a UserModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'mobile': mobile ?? '',
      'birthdate': birthdate ?? 0,
      'profile_img': profileImg ?? "",
      'created_on': createdOn
    };
  }

  // Convert a Map into a UserModel.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'],
      birthdate: map['birthdate'],
      profileImg: map['profile_img'],
      createdOn: map['created_on'],
    );
  }
}
