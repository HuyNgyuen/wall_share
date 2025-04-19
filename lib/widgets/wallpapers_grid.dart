import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/widgets/wallpaper_item.dart';

class WallpapersGrid extends StatelessWidget {
  const WallpapersGrid({
    super.key,
    required this.query,
    required this.onTap,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.paginationKey,
    this.limit = 10,
  });

  final Query<Map<String, dynamic>> query;
  final Function(Wallpaper) onTap;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final GlobalKey? paginationKey;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return FirestorePagination(
      query: query,
      key: paginationKey,
      limit: limit,
      isLive: true,
      viewType: ViewType.grid,
      onEmpty: const Center(child: Text('No Wallpapers found.')),
      itemBuilder: (context, documentSnapshot, index) {
        final wallpaper = Wallpaper.fromMap(
          documentSnapshot[index].data() as Map<String, dynamic>,
        );
        return WallpaperItem(
          wallpaper: wallpaper,
          onTap: () {
            onTap(wallpaper);
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
    );
  }
}
