import 'package:wall_share/constants.dart';

class Comment {
  final String uid;
  final String name;
  final String profilePic;
  final String commentId;
  final String comment;
  final String wallpaperId;
  String? parentId; // For nested comments
  final DateTime createdAt;
  final int likes;

  // Constructor
  Comment({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.commentId,
    required this.comment,
    required this.wallpaperId,
    this.parentId,
    required this.createdAt,
    this.likes = 0,
  });

  // To Map
  Map<String, dynamic> toMap() {
    return {
      Constants.uid: uid,
      Constants.name: name,
      Constants.profilePic: profilePic,
      Constants.commentId: commentId,
      Constants.comment: comment,
      Constants.wallpaperId: wallpaperId,
      Constants.parentId: parentId,
      Constants.createdAt: createdAt.millisecondsSinceEpoch,
      Constants.likes: likes,
    };
  }

  // from Map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      uid: map[Constants.uid] ?? '',
      name: map[Constants.name] ?? '',
      profilePic: map[Constants.profilePic] ?? '',
      commentId: map[Constants.commentId] ?? '',
      comment: map[Constants.comment] ?? '',
      wallpaperId: map[Constants.wallpaperId] ?? '',
      parentId: map[Constants.parentId] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[Constants.createdAt] ?? 0,
      ),
      likes: map[Constants.likes] ?? 0,
    );
  }
}
