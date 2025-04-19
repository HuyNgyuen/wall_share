import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/social/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wall_share/widgets/user_image_avatar.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    // Get current user id
    final authProvider = context.read<AuthenticationProvider>();
    final currentUserUid = authProvider.isLoggedIn;
    // Check if its our comment or not
    final isOurComment = comment.uid == currentUserUid;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          UserImageAvatar(imageUrl: comment.profilePic, radius: 20.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isOurComment ? 'You' : comment.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      timeago.format(comment.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  comment.comment,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }
}
