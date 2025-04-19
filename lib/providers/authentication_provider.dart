import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/models/user_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  String _isLoggedIn = '';
  bool _isLoading = false;
  UserModel? _userModel;

  // constructor
  AuthenticationProvider(String isLoggedIn) {
    _isLoggedIn = isLoggedIn;
  }

  // getters
  String get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  UserModel? get userModel => _userModel;

  // set isLoading
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in user
  Future<void> signInUser({required Function(bool) showLoading}) async {
    try {
      // sign in with google
      final User? user = await signInWithGoogle();
      if (user == null) return;
      // show loading
      showLoading(true);

      // check if user exists in firestore
      if (await checkUserExists(user.uid)) {
        // get user details
        _userModel = await getUserDetails(user.uid);
        // set isLoggedIn
        setIsLoggedIn(user.uid);
        // show loading
        showLoading(false);
        return;
      } else {
        // create user in firestore
        // create a profileID
        final profileId = generateProfileId(user.email!);

        // create user model
        _userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          profilePic: user.photoURL ?? '',
          profileId: profileId,
          phone: user.phoneNumber ?? '',
          aboutMe: 'Hello, I am using WallShare!',
          fcmToken: '',
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          onLine: true,
          followers: 0,
          following: 0,
          posts: 0,
        );

        // add user to firestore
        await _firestore
            .collection(Constants.usersCollection)
            .doc(user.uid)
            .set(_userModel!.toMap());

        // update firebase auth display name
        await _auth.currentUser!.updateDisplayName(_userModel!.name);
        await _auth.currentUser!.updatePhotoURL(_userModel!.profilePic);

        // set logged in
        setIsLoggedIn(user.uid);
        // show loading
        showLoading(false);
      }
    } catch (e) {
      print(e);
    }
  }

  // set isLoggedIn
  Future<void> setIsLoggedIn(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.uid, uid);
    _isLoggedIn = uid;
    notifyListeners();
  }

  // check if user logged in
  Future<String> checkIfUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString(Constants.uid) ?? '';
    if (_isLoggedIn.isNotEmpty) {
      // get user details
      _userModel = await getUserDetails(_isLoggedIn);
    }

    return _isLoggedIn;
  }

  // This takes and email and returns a profileId
  // this is used to create a unique profileId for each user
  // get the users profile and remove everything after the @, then from the remaining string, remove the last 2 characters
  // and replace with the random 4 digit number, the add @ at the beginning of the string and _profile at the end of the string
  // for example, if the email is john@gmail.com, the profileId will be @jo1526_profile
  String generateProfileId(String email) {
    String profileId = email.split('@')[0];
    profileId = profileId.substring(0, profileId.length - 2);
    profileId = profileId.replaceAll(
      profileId,
      '${profileId.substring(0, profileId.length - 2)}${Random().nextInt(9999).toString().padLeft(4, '0')}',
    );
    profileId = '@$profileId';
    profileId = '${profileId}_profile';
    return profileId;
  }

  // sign in with google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      // get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // sign in with google
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // get user details
      final User? user = userCredential.user;
      if (user == null) return null;

      // return user
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> checkUserExists(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection(Constants.usersCollection).doc(uid).get();
      if (userDoc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<UserModel> getUserDetails(String uid) async {
    final DocumentSnapshot userDoc =
        await _firestore.collection(Constants.usersCollection).doc(uid).get();
    return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _isLoggedIn = '';
    _userModel = null;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
