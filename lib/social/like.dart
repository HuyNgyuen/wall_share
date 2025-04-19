import 'package:wall_share/constants.dart';

class Like {
  final String uid;
  final String likeId;
  final String wallpaperId;
  final DateTime createdAt;

  // Constructor
  Like({
    required this.uid,
    required this.likeId,
    required this.wallpaperId,
    required this.createdAt,
  });

  // to Map
  Map<String, dynamic> toMap() {
    return {
      Constants.uid: uid,
      Constants.likeId: likeId,
      Constants.wallpaperId: wallpaperId,
      Constants.createdAt: createdAt.millisecondsSinceEpoch,
    };
  }

  // from Map
  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      uid: map[Constants.uid] ?? '',
      likeId: map[Constants.likeId] ?? '',
      wallpaperId: map[Constants.wallpaperId] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[Constants.createdAt] ?? 0,
      ),
    );
  }
}
