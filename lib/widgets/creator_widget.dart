import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/models/user_model.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/screens/profile_screen.dart';
import 'package:wall_share/widgets/user_image_avatar.dart';

class CreatorWidget extends StatelessWidget {
  const CreatorWidget({super.key, required this.creatorId});

  final String creatorId;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationProvider>();
    final stream =
        FirebaseFirestore.instance
            .collection(Constants.usersCollection)
            .doc(creatorId)
            .snapshots();
    return InkWell(
      onTap: () {
        // Navigate to creator's profile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(uid: creatorId),
          ),
        );
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          // check document exists
          if (!snapshot.hasData) {
            return const Text('User data not found');
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          UserModel userModel = UserModel.fromMap(data);
          bool isOwner = authProvider.isLoggedIn == creatorId;

          return Row(
            children: [
              UserImageAvatar(radius: 22, imageUrl: userModel.profilePic),
              const SizedBox(width: 8),
              Text(
                isOwner ? 'You' : userModel.name,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
