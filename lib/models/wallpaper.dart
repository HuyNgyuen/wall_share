import 'package:wall_share/constants.dart';
import 'package:wall_share/utilities/assets_manager.dart';

class Wallpaper {
  final String wallpaperId;
  final String name;
  final String imageUrl;
  final String creatorId;
  final String prompt;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isAIGenerated;

  // constructor
  Wallpaper({
    required this.wallpaperId,
    required this.name,
    required this.imageUrl,
    required this.creatorId,
    required this.prompt,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.isAIGenerated,
  });

  // factory to Map JSON to Wallpaper
  factory Wallpaper.fromMap(Map<String, dynamic> map) {
    return Wallpaper(
      wallpaperId: map[Constants.wallpaperId] ?? '',
      name: map[Constants.name] ?? '',
      imageUrl: map[Constants.imageUrl] ?? '',
      creatorId: map[Constants.creatorId] ?? '',
      prompt: map[Constants.prompt] ?? '',
      category: map[Constants.category] ?? '',
      tags: List<String>.from(map[Constants.tags] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[Constants.createdAt] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      likes: map[Constants.likes] ?? 0,
      comments: map[Constants.comments] ?? 0,
      isAIGenerated: map[Constants.isAIGenerated] ?? false,
    );
  }

  // topMap
  Map<String, dynamic> toMap() {
    return {
      Constants.wallpaperId: wallpaperId,
      Constants.name: name,
      Constants.imageUrl: imageUrl,
      Constants.creatorId: creatorId,
      Constants.prompt: prompt,
      Constants.category: category,
      Constants.tags: tags,
      Constants.createdAt: createdAt.millisecondsSinceEpoch,
      Constants.likes: likes,
      Constants.comments: comments,
      Constants.isAIGenerated: isAIGenerated,
    };
  }

  static List<String> categories = [
    'All',
    'Abstract',
    'Nature',
    'Urban',
    'Minimal',
    'Sci-Fi',
    'Fantasy',
    'Artistic',
    'Geometric',
    'Space',
    'Vintage',
    'Other',
  ];

  // list of ten wallpapers
  static List<Wallpaper> wallpapers = [
    Wallpaper(
      wallpaperId: '1',
      name: 'Abtract Neon Lights',
      imageUrl: AssetsManager.abstrctNeonLights,
      creatorId: '1',
      prompt:
          'Generate an abstract wallpaper with vibrant neon lights, glowing geometric shapes, and a futuristic cyberpunk vibe.',
      category: 'Abstract',
      tags: [],
      createdAt: DateTime.now(),
      likes: 10,
      comments: 2,
      isAIGenerated: true,
    ),
    Wallpaper(
      wallpaperId: '2',
      name: 'Serene Nature Scene',
      imageUrl: AssetsManager.sereneNatureScene,
      category: 'Nature',
      prompt:
          'Create a peaceful forest landscape at sunrise, with soft light filtering through the trees, and a clear lake reflecting the sky.',
      tags: [],
      likes: 5,
      comments: 1,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '2',
    ),
    Wallpaper(
      wallpaperId: '3',
      name: 'Cosmic Galaxy',
      imageUrl: AssetsManager.cosmicGalaxy,
      category: 'Abstract',
      prompt:
          'Design a cosmic scene with swirling galaxies, colorful nebula clouds, and shining stars, showcasing the vastness of space.',
      tags: [],
      likes: 8,
      comments: 3,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '3',
    ),
    Wallpaper(
      wallpaperId: '4',
      name: 'Minimalist Geometric Patterns',
      imageUrl: AssetsManager.minimalistGeometriPatterns,
      category: 'Minimal',
      prompt:
          'Generate a minimalist wallpaper with clean geometric patterns, using soft pastel colors and gradients.',
      tags: [],
      likes: 12,
      comments: 4,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '4',
    ),
    Wallpaper(
      wallpaperId: '5',
      name: 'Vintage Sunset',
      imageUrl: AssetsManager.vintageSunset,
      category: 'Minimal',
      prompt:
          'Create a retro sunset beach scene with soft orange, pink, and purple hues, palm trees in the foreground, and a vintage grainy texture.',
      tags: [],
      likes: 7,
      comments: 2,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '5',
    ),
    Wallpaper(
      wallpaperId: '6',
      name: 'Urban Night Skyline',
      imageUrl: AssetsManager.urbanNightSkyline,
      category: 'Urban',
      prompt:
          'Design an urban cityscape at night, with tall skyscrapers, twinkling lights, and reflections in the water, under a dark sky.',
      tags: [],
      likes: 9,
      comments: 3,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '6',
    ),
    Wallpaper(
      wallpaperId: '7',
      name: 'Futuristic Sci-Fi City',
      imageUrl: AssetsManager.futuristicSciFiCity,
      category: 'Sci-Fi',
      prompt:
          'Generate a futuristic city with towering buildings, flying cars, and glowing blue lights, set in a distant future.',
      tags: [],
      likes: 11,
      comments: 5,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '7',
    ),
    Wallpaper(
      wallpaperId: '8',
      name: 'Floral Watercolor',
      imageUrl: AssetsManager.floralWatercolor,
      category: 'Nature',
      prompt:
          'Create a soft, watercolor-style wallpaper with large blooming flowers in various colors, set against a white or light pastel background.',
      tags: [],
      likes: 6,
      comments: 1,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '8',
    ),
    Wallpaper(
      wallpaperId: '9',
      name: 'Mountain Range at Dusk',
      imageUrl: AssetsManager.mountainRangeAtDusk,
      category: 'Nature',
      prompt:
          'Design a scenic mountain range with snow-capped peaks, fading light at dusk, and a gradient sky from orange to dark blue.',
      tags: [],
      likes: 13,
      comments: 6,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '9',
    ),
    Wallpaper(
      wallpaperId: '10',
      name: 'Underwater Paradise',
      imageUrl: AssetsManager.underwaterParadise,
      category: 'Nature',
      prompt:
          'Generate an underwater scene with colorful coral reefs, schools of fish, and rays of light shining through the clear ocean water.',
      tags: [],
      likes: 14,
      comments: 7,
      isAIGenerated: true,
      createdAt: DateTime.now(),
      creatorId: '10',
    ),
  ];
}
