import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wall_share/constants.dart';

class MyImageCachemanager {
  // profile image cache manager
  static CacheManager profileImageCacheManager = CacheManager(
    Config(
      Constants.userImageKey,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 50,
    ),
  );

  // wallpaper image cache manager
  static CacheManager wallpaperImageCacheManager = CacheManager(
    Config(
      Constants.wallpaperImageKey,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );
}
