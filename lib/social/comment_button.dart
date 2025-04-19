import 'package:flutter/material.dart';
import 'package:wall_share/social/comment.dart';
import 'package:wall_share/social/comment_repository.dart';
import 'package:wall_share/social/comments_sheet.dart';
import 'package:wall_share/utilities/utilities.dart';

class CommentButton extends StatefulWidget {
  const CommentButton({
    super.key,
    required this.wallpaperId,
    required this.uid,
  });

  final String wallpaperId;
  final String uid;

  @override
  State<CommentButton> createState() => _CommentButtonState();
}

class _CommentButtonState extends State<CommentButton> {
  // Comments repository
  final CommentRepository _commentsRepository = CommentRepository();

  late Stream<List<Comment>> commentsStream;

  @override
  void initState() {
    commentsStream = _commentsRepository.getComments(widget.wallpaperId);
    super.initState();
  }

  // Show comments sheet
  void _showCommentsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(wallpaperId: widget.wallpaperId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
      stream: commentsStream,
      builder: (context, snapshot) {
        final commentCount = snapshot.data?.length ?? 0;

        return GestureDetector(
          onTap: _showCommentsSheet,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                const Icon(Icons.comment, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  Utilities.formatNumber(commentCount),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
