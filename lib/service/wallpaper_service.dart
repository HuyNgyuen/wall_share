import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:wall_share/utilities/utilities.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

class WallpaperService {
  // download wallpaper
  static Future<void> downloadWallpaper({
    required BuildContext context,
    required String wallpaperUrl,
    required walllpapeName,
  }) async {
    // remove all spaces from the wallpaper name if there is any and replace with _
    final newWalllpapeName = walllpapeName
        .replaceAll(' ', '')
        .replaceAll('_', '-');

    try {
      // show the loading dialog
      Utilities.showAnimatedDialog(
        context: context,
        title: 'Downloading Wallpaper',
        content: const LinearProgressIndicator(),
      );

      // download the wallpaper
      final response = await Dio().get(
        wallpaperUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // save to gallery
      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: '$newWalllpapeName${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        // hidee the loading dialog
        Navigator.pop(context);

        // show snackbar that the wallpaper was downloaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['isSuccess']
                  ? 'Wallpaper downloaded successfully'
                  : 'There was an error downloading the wallpaper',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // hidee the loading dialog
        Navigator.pop(context);

        // show snackbar that there was an error downloading the wallpaper
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error downloading the wallpaper'),
          ),
        );
        return;
      }
    }
  }

  // Set wallpaper
  static Future<void> setWallpaper({
    required BuildContext context,
    required String wallpaperUrl,
  }) async {
    try {
      // get file path
      final filePath = await DefaultCacheManager().getSingleFile(wallpaperUrl);

      if (context.mounted) {
        // Show options dialog
        Utilities.showAnimatedDialog(
          context: context,
          title: 'Set Wallaper',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose where to set the wallpaper'),
              const SizedBox(height: 16),

              // Home Screen
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home Screen'),
                onTap: () async {
                  // pop the dialog
                  Navigator.pop(context);

                  // apply wallapper to home screen
                  await _applyWallpaper(
                    context,
                    filePath,
                    WallpaperManagerPlus.homeScreen,
                  );
                },
              ),

              // Lock Screen
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Lock Screen'),
                onTap: () async {
                  // pop the dialog
                  Navigator.pop(context);

                  // apply wallapper to home screen
                  await _applyWallpaper(
                    context,
                    filePath,
                    WallpaperManagerPlus.lockScreen,
                  );
                },
              ),

              // Both
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Both'),
                onTap: () async {
                  // pop the dialog
                  Navigator.pop(context);

                  // apply wallapper to home screen
                  await _applyWallpaper(
                    context,
                    filePath,
                    WallpaperManagerPlus.bothScreens,
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // pop the dialog
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      }
    } catch (e) {
      if (context.mounted) {
        // hidee the loading dialog
        Navigator.pop(context);

        // show snackbar that there was an error setting the wallpaper
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error setting the wallpaper'),
          ),
        );
      }
    }
  }

  static Future<void> _applyWallpaper(
    BuildContext context,
    File filePath,
    int location,
  ) async {
    try {
      // show loading dialog
      Utilities.showAnimatedDialog(
        context: context,
        title: 'Setting Wallpaper',
        content: const LinearProgressIndicator(),
      );

      // set wallpaper
      final result = await WallpaperManagerPlus().setWallpaper(
        filePath,
        location,
      );

      if (context.mounted) {
        // hide the loading dialog
        Navigator.pop(context);

        // show snackbar that the wallpaper was set successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? 'There was an error setting the wallpaper'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // hide the loading dialog
        Navigator.pop(context);

        // show snackbar that there was an error setting the wallpaper
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error setting the wallpaper'),
          ),
        );
      }
    }
  }
}
