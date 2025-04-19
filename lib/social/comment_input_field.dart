import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/social/comment_repository.dart';

class CommentInputField extends StatefulWidget {
  const CommentInputField({super.key, required this.wallpaperId});

  final String wallpaperId;

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final CommentRepository _commentRepository = CommentRepository();
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Sumbit comment
  void _submitComment() async {
    if (_commentController.text.isEmpty) {
      // show a snackbar to tell the user to enter a comment
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a comment')));
      return;
    }

    // check if user is logged in
    final authProvider = context.read<AuthenticationProvider>();
    if (authProvider.isLoggedIn.isEmpty) {
      // show a snackbar to tell the user to login
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login to comment')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _commentRepository.addComment(
        wallpaperId: widget.wallpaperId,
        comment: _commentController.text,
        uid: authProvider.userModel!.uid,
        username: authProvider.userModel!.name,
        profilePic: authProvider.userModel!.profileId,
      );

      setState(() {
        _isSubmitting = false;
        _commentController.clear();
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        // show a snackbar to tell the user to try again
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8.0),
              // Send Button
              IconButton(
                onPressed: _isSubmitting ? null : _submitComment,
                icon:
                    _isSubmitting
                        ? SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        )
                        : Icon(Icons.send, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
