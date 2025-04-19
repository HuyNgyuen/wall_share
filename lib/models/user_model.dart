import 'package:wall_share/constants.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String profilePic;
  String profileId;
  String phone;
  String aboutMe;
  String fcmToken;
  String createdAt;
  bool onLine;
  int followers;
  int following;
  int posts;

  // constructor
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.profileId,
    required this.phone,
    required this.aboutMe,
    required this.fcmToken,
    required this.createdAt,
    required this.onLine,
    required this.followers,
    required this.following,
    required this.posts,
  });

  // factory from Map method
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map[Constants.uid] ?? '',
      name: map[Constants.name] ?? '',
      email: map[Constants.email] ?? '',
      profilePic: map[Constants.profilePic] ?? '',
      profileId: map[Constants.profileId] ?? '',
      phone: map[Constants.phone] ?? '',
      aboutMe: map[Constants.aboutMe] ?? '',
      fcmToken: map[Constants.fcmToken] ?? '',
      createdAt: map[Constants.createdAt] ?? '',
      onLine: map[Constants.onLine] ?? false,
      followers: map[Constants.followers] ?? 0,
      following: map[Constants.following] ?? 0,
      posts: map[Constants.posts] ?? 0,
    );
  }

  // top map method
  Map<String, dynamic> toMap() {
    return {
      Constants.uid: uid,
      Constants.name: name,
      Constants.email: email,
      Constants.profilePic: profilePic,
      Constants.profileId: profileId,
      Constants.phone: phone,
      Constants.aboutMe: aboutMe,
      Constants.fcmToken: fcmToken,
      Constants.createdAt: createdAt,
      Constants.onLine: onLine,
      Constants.followers: followers,
      Constants.following: following,
      Constants.posts: posts,
    };
  }
}
