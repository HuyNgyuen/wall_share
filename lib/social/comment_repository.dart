import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/social/comment.dart';

class CommentRepository {
  // comments collection reference
  final CollectionReference _commentsCollection = FirebaseFirestore.instance
      .collection(Constants.commentsCollection);
  // Wallpapers collection reference
  final CollectionReference _wallpapersCollection = FirebaseFirestore.instance
      .collection(Constants.wallpapersCollection);

  // Add comment
  Future<void> addComment({
    required String wallpaperId,
    required String comment,
    required String uid,
    required String username,
    required String profilePic,
    String? parentId,
  }) async {
    // comment id
    final commentId = _commentsCollection.doc().id;
    // comment document
    final commentDoc = _commentsCollection.doc(commentId);
    // wallpaper document
    final wallpaperDoc = _wallpapersCollection.doc(wallpaperId);

    // return a transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // get the wallpaper document
      final wallpaperDocSnapshot = await transaction.get(wallpaperDoc);

      // Cast the document snapshot to a map
      final wallpaperMap = wallpaperDocSnapshot.data() as Map<String, dynamic>?;

      // Add a comment to the wallpaper document
      transaction.set(
        commentDoc,
        Comment(
          uid: uid,
          name: username,
          profilePic: profilePic,
          commentId: commentId,
          comment: comment,
          wallpaperId: wallpaperId,
          parentId: parentId,
          createdAt: DateTime.now(),
        ).toMap(),
      );

      // Update the wallpaper document
      transaction.update(wallpaperDoc, {
        Constants.comments:
            ((wallpaperMap?[Constants.comments] as int?) ?? 0) + 1,
      });
    });
  }

  // Delete comment
  Future<void> deleteComment(String commentId) async {
    // comment document
    final commentDoc = _commentsCollection.doc(commentId);

    // delete the comment
    await commentDoc.delete();
  }

  // Gert comments query
  Query getCommentsQuery(String wallpaperId) {
    return _commentsCollection
        .where(Constants.wallpaperId, isEqualTo: wallpaperId)
        .orderBy(Constants.createdAt, descending: true);
  }

  // Stream comments list
  Stream<List<Comment>> getComments(String wallpaperId) {
    return getCommentsQuery(wallpaperId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
