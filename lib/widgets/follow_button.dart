import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/social/follow_repository.dart';
import 'package:wall_share/widgets/main_app_button.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({super.key, required this.uid});

  final String uid;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  final FollowRepository _followRepository = FollowRepository();
  StreamSubscription<bool>? _followSubscription;
  bool _isFollowing = false;

  @override
  void initState() {
    _setupFollowSubscription();
    super.initState();
  }

  void _setupFollowSubscription() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthenticationProvider>();
      _followSubscription = _followRepository
          .isFollowingUser(authProvider.isLoggedIn, widget.uid)
          .listen((isFollowing) {
            setState(() {
              _isFollowing = isFollowing;
            });
          });
    });
  }

  @override
  void dispose() {
    _followSubscription?.cancel();
    super.dispose();
  }

  void _toggleFollow() async {
    final authProvider = context.read<AuthenticationProvider>();
    // Check if the user is logged in
    if (authProvider.isLoggedIn.isEmpty) {
      // Show a snackbar or navigate to the login screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to follow users.')),
      );
      return;
    }
    if (_isFollowing) {
      await _followRepository.unfollowUser(authProvider.isLoggedIn, widget.uid);
    } else {
      await _followRepository.followUser(authProvider.isLoggedIn, widget.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppButton(
      icon: _isFollowing ? Icons.person_remove : Icons.person_add,
      label: _isFollowing ? 'Unfollow' : 'Follow',
      onPressed: _toggleFollow,
      backgroundColor: _isFollowing ? Colors.red : Colors.deepPurple,
      textColor: Colors.white,
    );
  }
}
