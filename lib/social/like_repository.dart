import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/social/like.dart';

class LikeRepository {
  // likes collection
  final CollectionReference _likesCollection = FirebaseFirestore.instance
      .collection(Constants.likesCollection);
  // wallpapers collection
  final CollectionReference _wallpapersCollection = FirebaseFirestore.instance
      .collection(Constants.wallpapersCollection);

  // Toggle like
  Future<void> toggleLike(String wallpaperId, String uid) async {
    // get like id
    String likeId = '$wallpaperId-$uid';
    // get like document
    final likeDoc = _likesCollection.doc(likeId);
    // get wallpaper document
    final wallpaperDoc = _wallpapersCollection.doc(wallpaperId);

    // run a transaction
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // get like snapshot
      final likeSnapshot = await transaction.get(likeDoc);
      // get wallpaper snapshot
      final wallpaperSnapshot = await transaction.get(wallpaperDoc);

      // Cast the wallpaper snapshot to a map
      final wallpaperData = wallpaperSnapshot.data() as Map<String, dynamic>;

      // check if like does not exists
      if (!likeSnapshot.exists) {
        // add like
        transaction.set(
          likeDoc,
          Like(
            uid: uid,
            likeId: likeId,
            wallpaperId: wallpaperId,
            createdAt: DateTime.now(),
          ).toMap(),
        );

        // Increment the like count
        transaction.update(wallpaperDoc, {
          Constants.likes: ((wallpaperData[Constants.likes] as int?) ?? 0) + 1,
        });
      } else {
        // delete like
        transaction.delete(likeDoc);

        // Decrement the like count
        transaction.update(wallpaperDoc, {
          Constants.likes: ((wallpaperData[Constants.likes] as int?) ?? 0) - 1,
        });
      }
    });
  }

  // Stream likes count
  Stream<int> getLikesCount(String wallpaperId) {
    // get likes collection
    return _likesCollection
        .where(Constants.wallpaperId, isEqualTo: wallpaperId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Check if user has liked the wallpaper
  Stream<bool> hasLiked(String wallpaperId, String uid) {
    if (uid.isEmpty) {
      return Stream.value(false);
    }
    // get like id
    String likeId = '$wallpaperId-$uid';
    return _likesCollection
        .doc(likeId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }
}
