import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wall_share/utilities/assets_manager.dart';
import 'package:wall_share/utilities/my_image_cachemanager.dart';

class UserImageAvatar extends StatelessWidget {
  const UserImageAvatar({
    super.key,
    required this.radius,
    this.fileImage,
    this.imageUrl = '',
    this.avatarPadding = 8.0,
    this.isViewOnly = false,
    this.onPressed,
  });

  final double radius;
  final File? fileImage;
  final String imageUrl;
  final double avatarPadding;
  final bool isViewOnly;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey,
            backgroundImage: _showImage(fileImage),
          ),
          if (onPressed != null && !isViewOnly)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onPressed,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _showImage(File? fileImage) {
    if (fileImage != null) {
      return FileImage(File(fileImage.path)) as ImageProvider;
    } else if (imageUrl.isNotEmpty) {
      return CachedNetworkImageProvider(
        imageUrl,
        cacheManager: MyImageCachemanager.profileImageCacheManager,
      );
    } else {
      return AssetImage(AssetsManager.userIcon);
    }
  }
}
