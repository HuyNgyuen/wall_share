import 'package:flutter/material.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/widgets/wallpaper_image.dart';
import 'package:wall_share/widgets/wallpaper_info_overlay.dart';

class WallpaperItem extends StatelessWidget {
  const WallpaperItem({
    super.key,
    required this.wallpaper,
    required this.onTap,
  });

  final Wallpaper wallpaper;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
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
            WallpaperInfoOverlay(
              wallpaperName: wallpaper.name,
              likes: wallpaper.likes,
              comments: wallpaper.comments,
              nameFontSize: 14,
              iconFontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
