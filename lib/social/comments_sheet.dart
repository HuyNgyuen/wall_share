import 'dart:developer';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:wall_share/social/comment.dart';
import 'package:wall_share/social/comment_card.dart';
import 'package:wall_share/social/comment_input_field.dart';
import 'package:wall_share/social/comment_repository.dart';
import 'package:wall_share/widgets/user_image_avatar.dart';

class CommentsSheet extends StatefulWidget {
  const CommentsSheet({super.key, required this.wallpaperId});

  final String wallpaperId;

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final CommentRepository _commentRepository = CommentRepository();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: theme.colorScheme.outline),

              Expanded(
                child: FirestorePagination(
                  query: _commentRepository.getCommentsQuery(
                    widget.wallpaperId,
                  ),
                  limit: 20,
                  isLive: true,
                  viewType: ViewType.list,
                  onEmpty: Center(
                    child: Center(
                      child: Text(
                        'No comments yet',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ),
                  bottomLoader: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  itemBuilder: (context, documentSnapshot, index) {
                    final comment = Comment.fromMap(
                      documentSnapshot[index].data() as Map<String, dynamic>,
                    );

                    return CommentCard(comment: comment);
                  },
                ),
              ),

              // Input field
              CommentInputField(wallpaperId: widget.wallpaperId),
            ],
          ),
        );
      },
    );
  }
}
