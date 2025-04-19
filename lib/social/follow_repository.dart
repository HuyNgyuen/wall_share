import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall_share/constants.dart';

class FollowRepository {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Follow a user
  Future<void> followUser(String currentUserId, String userIdToFollow) async {
    try {
      final batch = _firestore.batch();

      // followersRef
      final followersRef = _firestore
          .collection(Constants.usersCollection)
          .doc(userIdToFollow)
          .collection(Constants.followers)
          .doc(currentUserId);
      // FolowingsRef
      final followingsRef = _firestore
          .collection(Constants.usersCollection)
          .doc(currentUserId)
          .collection(Constants.following)
          .doc(userIdToFollow);

      // Update followers count forthe target user
      final targetUserRef = _firestore
          .collection(Constants.usersCollection)
          .doc(userIdToFollow);

      // Update the followers count for current user
      final currentUserRef = _firestore
          .collection(Constants.usersCollection)
          .doc(currentUserId);

      // set the followers count for the target user
      batch.set(followersRef, {
        Constants.createdAt: FieldValue.serverTimestamp(),
      });

      // set the followings count for the current user
      batch.set(followingsRef, {
        Constants.createdAt: FieldValue.serverTimestamp(),
      });

      // Update the followers count for the target user
      batch.update(targetUserRef, {
        Constants.followers: FieldValue.increment(1),
      });

      // Update the followings count for the current user
      batch.update(currentUserRef, {
        Constants.following: FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  // Unfollow a user
  Future<void> unfollowUser(
    String currentUserId,
    String userIdToUnfollow,
  ) async {
    try {
      final batch = _firestore.batch();

      // followersRef
      final followersRef = _firestore
          .collection(Constants.usersCollection)
          .doc(userIdToUnfollow)
          .collection(Constants.followers)
          .doc(currentUserId);
      // FolowingsRef
      final followingsRef = _firestore
          .collection(Constants.usersCollection)
          .doc(currentUserId)
          .collection(Constants.following)
          .doc(userIdToUnfollow);

      // Update followers count forthe target user
      final targetUserRef = _firestore
          .collection(Constants.usersCollection)
          .doc(userIdToUnfollow);

      // Update the followers count for current user
      final currentUserRef = _firestore
          .collection(Constants.usersCollection)
          .doc(currentUserId);

      // delete the followers count for the target user
      batch.delete(followersRef);
      // delete the followings count for the current user
      batch.delete(followingsRef);

      // update the followers count for the target user
      batch.update(targetUserRef, {
        Constants.followers: FieldValue.increment(-1),
      });
      // update the followings count for the current user
      batch.update(currentUserRef, {
        Constants.following: FieldValue.increment(-1),
      });

      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  // Check if user is following a user
  Stream<bool> isFollowingUser(String currentUserId, String userIdToCheck) {
    if (currentUserId.isEmpty) {
      return Stream.value(false);
    }
    return _firestore
        .collection(Constants.usersCollection)
        .doc(userIdToCheck)
        .collection(Constants.followers)
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }
}
