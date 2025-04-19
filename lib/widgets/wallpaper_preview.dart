import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class WallpaperPreview extends StatelessWidget {
  const WallpaperPreview({super.key, required this.imageSource});

  final dynamic imageSource;

  @override
  Widget build(BuildContext context) {
    Widget buildWallpaperPreview() {
      Widget imageWidget;

      if (imageSource is String) {
        imageWidget = Image.file(
          File(imageSource),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else if (imageSource is Uint8List) {
        imageWidget = Image.memory(
          imageSource,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else {
        imageWidget = const Center(child: Text('Invalid image source'));
      }

      return imageWidget;
    }

    return buildWallpaperPreview();
  }
}
