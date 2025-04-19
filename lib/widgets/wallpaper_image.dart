import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wall_share/utilities/my_image_cachemanager.dart';

class WallpaperImage extends StatelessWidget {
  const WallpaperImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheManager: MyImageCachemanager.wallpaperImageCacheManager,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return const Center(child: CircularProgressIndicator());
      },
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
