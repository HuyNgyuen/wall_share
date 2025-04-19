import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/social/like_repository.dart';
import 'package:wall_share/utilities/utilities.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.wallpaperId, required this.uid});

  final String wallpaperId;
  final String uid;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  // Like controller
  late AnimationController _likeController;
  // Scale animation
  late Animation<double> _scaleAnimation;

  bool isLiked = false;
  int localLikeCount = 0;
  int streamLikeCount = 0;
  bool hasLocalUpdate = false;

  // Like repository
  final LikeRepository _likeRepository = LikeRepository();

  late Stream<int> likeCountStream;
  late StreamSubscription<bool> _likeSubscription;

  @override
  void initState() {
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.8), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.8, end: 1), weight: 20),
    ]).animate(_likeController);

    // Initialize like count stream
    likeCountStream = _likeRepository.getLikesCount(widget.wallpaperId);

    _setLikeSubScription();

    super.initState();
  }

  // set like count
  void _setLikeSubScription() async {
    // make sure the widget has built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthenticationProvider>();

      _likeSubscription = _likeRepository
          .hasLiked(widget.wallpaperId, authProvider.isLoggedIn)
          .listen((liked) {
            setState(() {
              isLiked = liked;
            });
          });
    });
  }

  // toggle like
  void _handleLike() async {
    if (widget.uid.isEmpty) {
      // show a snackbar to notify user to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to like wallpaper')),
      );
      return;
    }

    // Set glag for local update
    hasLocalUpdate = true;

    // Optimistically update local count - to update the UI
    setState(() {
      isLiked = !isLiked;
      localLikeCount = streamLikeCount + (isLiked ? 1 : -1);
    });

    try {
      await _likeRepository.toggleLike(widget.wallpaperId, widget.uid);

      // On success, update local count
      setState(() {
        streamLikeCount = localLikeCount;
        hasLocalUpdate = false;
      });
    } catch (e) {
      if (mounted) {
        // Revert local count
        setState(() {
          isLiked = !isLiked;
          localLikeCount = streamLikeCount;
          hasLocalUpdate = false;
        });
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error liking the wallpaper'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _likeController.dispose();
    _likeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: likeCountStream,
      builder: (context, snapshot) {
        // Update stream count when new data arrives
        if (snapshot.hasData) {
          streamLikeCount = snapshot.data!;

          // Only update local count if there's no pending local update
          if (!hasLocalUpdate) {
            localLikeCount = streamLikeCount;
          }
        }

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Row(
              children: [
                GestureDetector(
                  onTap: _handleLike,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isLiked),
                        color: isLiked ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    Utilities.formatNumber(localLikeCount),
                    key: ValueKey<int>(localLikeCount),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
