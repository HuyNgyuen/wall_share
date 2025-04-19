import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/widgets/bottom_content.dart';
import 'package:wall_share/social/comment_button.dart';
import 'package:wall_share/social/like_button.dart';
import 'package:wall_share/widgets/wallpaper_image.dart';

class WallpaperDetailsScreen extends StatelessWidget {
  const WallpaperDetailsScreen({super.key, required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          LikeButton(
            wallpaperId: wallpaper.wallpaperId,
            uid: authProvider.isLoggedIn,
          ),
          CommentButton(
            wallpaperId: wallpaper.wallpaperId,
            uid: authProvider.isLoggedIn,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          WallpaperImage(imageUrl: wallpaper.imageUrl),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),

          // Bottom content
          BottomContent(wallpaper: wallpaper, uid: authProvider.isLoggedIn),
        ],
      ),
    );
  }
}
