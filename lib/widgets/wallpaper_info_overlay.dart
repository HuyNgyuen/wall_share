import 'package:flutter/material.dart';

class WallpaperInfoOverlay extends StatelessWidget {
  const WallpaperInfoOverlay({
    super.key,
    required this.wallpaperName,
    required this.likes,
    required this.comments,
    this.nameFontSize = 16.0,
    this.iconFontSize = 14.0,
  });

  final String wallpaperName;
  final int likes;
  final int comments;
  final double nameFontSize;
  final double iconFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wallpaperName,
            style: TextStyle(
              color: Colors.white,
              fontSize: nameFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: iconFontSize),
              const SizedBox(width: 4),
              Text(
                likes.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: iconFontSize - 2,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.comment, color: Colors.white, size: iconFontSize),
              const SizedBox(width: 4),
              Text(
                comments.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: iconFontSize - 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
