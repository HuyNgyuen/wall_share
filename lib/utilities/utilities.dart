import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/screens/wallpaper_details_screen.dart';

class Utilities {
  // Method to format a number with thound separators
  static String formatNumber(int number) {
    if (number >= 1000 && number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else {
      return number.toString();
    }
  }

  // Method to navigate to wallpaper details screen
  static void navigateToWallpaperDetailsScreen(
    BuildContext context,
    Wallpaper wallpaper,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperDetailsScreen(wallpaper: wallpaper),
      ),
    );
  }

  // animated dialog
  static Future<void> showAnimatedDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: content,
              actions: actions,
            ),
          ),
        );
      },
    );
  }

  // generate a wallpaper name from prompt
  static String generateWallpaperName(String prompt) {
    // Convert prompt to lowercase for consistent processing
    prompt = prompt.toLowerCase();

    // List of words to remove (articles, common verbs, etc.)
    final stopWords = {
      'a',
      'an',
      'the',
      'with',
      'and',
      'or',
      'in',
      'at',
      'on',
      'to',
      'for',
      'of',
      'create',
      'generate',
      'design',
      'showcase',
      'featuring',
      'using',
      'set',
      'against',
      'through',
    };

    // List of key themes to look for
    final themes = {
      'neon': 'Neon',
      'cyberpunk': 'Cyber',
      'forest': 'Forest',
      'nature': 'Natural',
      'galaxy': 'Galactic',
      'cosmic': 'Cosmic',
      'space': 'Space',
      'geometric': 'Geo',
      'minimalist': 'Minimal',
      'vintage': 'Retro',
      'retro': 'Retro',
      'urban': 'Urban',
      'city': 'City',
      'future': 'Future',
      'sci-fi': 'Sci-Fi',
      'floral': 'Floral',
      'watercolor': 'Watercolor',
      'mountain': 'Mountain',
      'underwater': 'Aqua',
    };

    // List of style/mood keywords
    final styles = {
      'abstract': 'Abstract',
      'nature': 'Nature',
      'urban': 'Urban',
      'fantasy': 'Fantasy',
      'serene': 'Serene',
      'peaceful': 'Peaceful',
      'minimal': 'Minimal',
      'futuristic': 'Future',
      'vibrant': 'Vibrant',
    };

    // Split the prompt into words
    final words =
        prompt.split(' ').where((word) => !stopWords.contains(word)).toList();

    // Find theme and style matches
    String? themeWord;
    String? styleWord;

    for (var word in words) {
      themes.forEach((key, value) {
        if (word.contains(key)) themeWord = value;
      });
      styles.forEach((key, value) {
        if (word.contains(key)) styleWord = value;
      });
    }

    // Construct the name
    final List<String> nameParts = [];

    if (styleWord != null) nameParts.add(styleWord!);
    if (themeWord != null) nameParts.add(themeWord!);

    // If no matches found, use first 2-3 significant words
    if (nameParts.isEmpty) {
      nameParts.addAll(words.take(2));
    }

    // Capitalize first letter of each word and join with spaces between
    final name = nameParts
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return name;
  }

  // john - ['j','jo', 'joh', 'john'] - example
  static List<String> generateTags(String title) {
    final terms = title.toLowerCase().split(' ');
    final searchTerms = <String>[];

    for (var term in terms) {
      for (var i = 1; i <= term.length; i++) {
        searchTerms.add(term.substring(0, i));
      }
    }

    return searchTerms;
  }

  // store image to storage
  static Future<String> uploadImageToFirebaseStorage({
    required File imageFile,
    required String reference,
  }) async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(reference)
          .putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image to Firebase Storage');
    }
  }

  // determine wallpaper category from prompt
  static String generateCategory(String prompt) {
    // list of categories
    List<String> categories = [
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

    // get lowercase prompt
    final promptLower = prompt.toLowerCase();

    // determine wallpaper category from prompt using regex
    if (promptLower.contains(RegExp(r'abstract|pattern|'))) {
      return categories[0];
    } else if (promptLower.contains(RegExp(r'nature|trees|flowers|mountain'))) {
      return categories[1];
    } else if (promptLower.contains(RegExp(r'city|building|street|urban'))) {
      return categories[2];
    } else if (promptLower.contains(
      RegExp(r'minimal|simple|clean|minimalist'),
    )) {
      return categories[3];
    } else if (promptLower.contains(
      RegExp(r'sci-fi|futuristic|space|alien|robot'),
    )) {
      return categories[4];
    } else if (promptLower.contains(RegExp(r'fantasy|magic|mythical|dragon'))) {
      return categories[5];
    } else if (promptLower.contains(
      RegExp(r'art|painting|abstract|expressionist'),
    )) {
      return categories[6];
    } else if (promptLower.contains(RegExp(r'geometric|shape|cube|square'))) {
      return categories[7];
    } else if (promptLower.contains(RegExp(r'space|galaxy|nebula|star'))) {
      return categories[8];
    } else if (promptLower.contains(RegExp(r'vintage|retro|old|nostalgic'))) {
      return categories[9];
    } else {
      return categories[10];
    }
  }

  // convert enum value to readable string from ImageAIStyle
  static String convertEnumToString(ImageAIStyle style) {
    switch (style) {
      case ImageAIStyle.noStyle:
        return 'No Style';
      case ImageAIStyle.anime:
        return 'Anime';
      case ImageAIStyle.moreDetails:
        return 'More Details';
      case ImageAIStyle.cyberPunk:
        return 'Cyber Punk';
      case ImageAIStyle.kandinskyPainter:
        return 'Kandinsky';
      case ImageAIStyle.aivazovskyPainter:
        return 'Aivazovsky';
      case ImageAIStyle.malevichPainter:
        return 'Malevich';
      case ImageAIStyle.picassoPainter:
        return 'Picasso';
      case ImageAIStyle.goncharovaPainter:
        return 'Goncharova';
      case ImageAIStyle.classicism:
        return 'Classicism';
      case ImageAIStyle.renaissance:
        return 'Renaissance';
      case ImageAIStyle.oilPainting:
        return 'Oil Painting';
      case ImageAIStyle.pencilDrawing:
        return 'Pencil Drawing';
      case ImageAIStyle.digitalPainting:
        return 'Digital Painting';
      case ImageAIStyle.medievalStyle:
        return 'Medieval';
      case ImageAIStyle.render3D:
        return '3D Render';
      case ImageAIStyle.cartoon:
        return 'Cartoon';
      case ImageAIStyle.sovietCartoon:
        return 'Soviet Cartoon';
      case ImageAIStyle.studioPhoto:
        return 'Studio Photo';
      case ImageAIStyle.portraitPhoto:
        return 'Portrait Photo';
      case ImageAIStyle.khokhlomaPainter:
        return 'Khokhloma';
      case ImageAIStyle.christmas:
        return 'Christmas';
    }
  }
}
