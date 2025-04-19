import 'package:flutter/material.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/service/wallpaper_service.dart';
import 'package:wall_share/widgets/creator_widget.dart';
import 'package:wall_share/widgets/main_app_button.dart';
import 'package:wall_share/widgets/prompt_widget.dart';

class BottomContent extends StatelessWidget {
  const BottomContent({super.key, required this.wallpaper, required this.uid});

  final Wallpaper wallpaper;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wallpaper.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(wallpaper.name, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            wallpaper.prompt.isEmpty
                ? const SizedBox()
                : PromptWidget(prompt: wallpaper.prompt),

            MainAppButton(
              icon: Icons.download_outlined,
              label: 'Download',
              onPressed: () {
                if (uid.isEmpty) {
                  // show a snackbar to notify user to login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please login to download wallpaper'),
                    ),
                  );
                  return;
                }

                WallpaperService.downloadWallpaper(
                  context: context,
                  wallpaperUrl: wallpaper.imageUrl,
                  walllpapeName: wallpaper.name,
                );
              },
            ),
            const SizedBox(height: 8),

            MainAppButton(
              icon: Icons.image,
              label: 'Set Wallpaper',
              onPressed: () {
                if (uid.isEmpty) {
                  // show a snackbar to notify user to login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please login to download wallpaper'),
                    ),
                  );
                  return;
                }

                WallpaperService.setWallpaper(
                  context: context,
                  wallpaperUrl: wallpaper.imageUrl,
                );
              },
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.white,
            ),

            const SizedBox(height: 16),

            // creators name and image
            CreatorWidget(creatorId: wallpaper.creatorId),
          ],
        ),
      ),
    );
  }
}
