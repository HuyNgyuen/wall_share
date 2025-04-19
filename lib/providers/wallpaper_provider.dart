import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:uuid/uuid.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/utilities/utilities.dart';

class WallpaperProvider with ChangeNotifier {
  bool _isLoading = false;
  Wallpaper? _wallpapers;
  dynamic _image;
  File? _imageFile;

  final StabilityAI _ai = StabilityAI();

  // stability api key
  final String apiKey = dotenv.env['STABILITY_API_KEY']!;

  // getters
  bool get isLoading => _isLoading;
  Wallpaper? get wallpaper => _wallpapers;
  dynamic get image => _image;
  File? get imageFile => _imageFile;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // users collection reference
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection(Constants.usersCollection);

  // wallpaer collection reference
  final CollectionReference _wallpapersCollection = FirebaseFirestore.instance
      .collection(Constants.wallpapersCollection);

  // Query for getting wallpapers with basic filtering
  Query<Map<String, dynamic>> getWallpapersQuery({
    String category = 'All',
    String searchQuery = '',
    String sortBy = Constants.createdAt,
    bool isDescending = true,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(
      Constants.wallpapersCollection,
    );

    // Apply the catergory filter if its not 'All'
    if (category != 'All') {
      query = query.where(Constants.category, isEqualTo: category);
    }

    // Apply search query if its not empty
    if (searchQuery.isNotEmpty) {
      // Convert the search query to lowercase for case-insensitive search
      final searchQueryLower = searchQuery.toLowerCase();

      query = query.where(Constants.tags, arrayContains: searchQueryLower);
    }

    // Apply sorting
    query = query.orderBy(sortBy, descending: isDescending);

    return query;
  }

  // Get current users wallpaper query
  Query<Map<String, dynamic>> getCurrentUserWallpapersQuery(String uid) {
    return _firestore
        .collection(Constants.wallpapersCollection)
        .where(Constants.creatorId, isEqualTo: uid);
  }

  // Get most liked wallpapers query top 10
  Query<Map<String, dynamic>> getMostLikedWallpapersQuery() {
    return _firestore
        .collection(Constants.wallpapersCollection)
        .orderBy(Constants.likes, descending: true)
        .limit(10);
  }

  // generate wallpaper with AI
  Future<Uint8List> generateWithAI(
    String prompt,
    ImageAIStyle imageAIStyle,
  ) async {
    /// Call the generateImage method with the required parameters.
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: prompt,
    );
    return image;
  }

  // generate wallpaper
  Future<void> generateWallpaper({
    required String prompt,
    required ImageAIStyle imageAIStyle,
    required Function(String) onComplete,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _image = await generateWithAI(prompt, imageAIStyle);

      // create a temp file
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/wallpaper${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(_image);

      _imageFile = file;

      // remove loading state
      _isLoading = false;

      notifyListeners();
      onComplete('Wallpaper generated successfully.');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      onComplete('An error occurred while generating the wallpaper.');
    }
  }

  // save wallpaper to firestore
  Future<void> saveWallpaperToFirestore({
    required String uid,
    required bool isAIGenerated,
    String title = '',
    String prompt = '',
    String category = '',
    required Function(String) onCompleted,
  }) async {
    // get the title of the wallaper
    final name =
        title.isNotEmpty ? title : Utilities.generateWallpaperName(prompt);

    // get a category of wallpaper from prompt
    final wallpaperCategore =
        category.isNotEmpty ? category : Utilities.generateCategory(prompt);

    // generate a unique wallpaper id
    final wallpaperId = const Uuid().v4();

    // generate tags
    final tags = Utilities.generateTags(name);

    _isLoading = true;
    notifyListeners();

    try {
      // upload image to firebase storage
      final imageUrl = await Utilities.uploadImageToFirebaseStorage(
        imageFile: _imageFile!,
        reference: '${Constants.wallpapersCollection}/$wallpaperId.jpg',
      );

      // create a wallpaper model
      _wallpapers = Wallpaper(
        wallpaperId: wallpaperId,
        name: name,
        imageUrl: imageUrl,
        creatorId: uid,
        prompt: prompt,
        category: wallpaperCategore,
        tags: tags,
        createdAt: DateTime.now(),
        likes: 0,
        comments: 0,
        isAIGenerated: isAIGenerated,
      );

      // save wallpaper to firestore
      await _wallpapersCollection.doc(wallpaperId).set(_wallpapers!.toMap());

      // update posts count
      await _usersCollection.doc(uid).update({
        Constants.posts: FieldValue.increment(1),
      });

      // remove loading state
      _isLoading = false;
      notifyListeners();
      onCompleted('Wallpaper saved successfully.');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      onCompleted('An error occurred while saving the wallpaper.');
    }
  }

  // clear state
  void clearState() {
    _isLoading = false;
    _image = null;
    _imageFile = null;
    _wallpapers = null;
    notifyListeners();
  }

  Future<void> setImage(XFile imagePath) async {
    _imageFile = File(imagePath.path);
    _image = imagePath.path;
    notifyListeners();
  }
}
