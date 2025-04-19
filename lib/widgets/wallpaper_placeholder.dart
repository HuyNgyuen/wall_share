import 'package:flutter/material.dart';

class WallpaperPlaceholder extends StatelessWidget {
  const WallpaperPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Text(
          'Your wallpaper will appear here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
