import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/models/user_model.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/screens/edit_profile_screen.dart';
import 'package:wall_share/widgets/follow_button.dart';
import 'package:wall_share/widgets/main_app_button.dart';
import 'package:wall_share/widgets/social_details.dart';
import 'package:wall_share/widgets/user_image_avatar.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection(Constants.usersCollection)
              .doc(uid)
              .snapshots(),
      builder: (context, snapshot) {
        // Check if has error
        if (snapshot.hasError) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Something went wrong!')),
          );
        }

        // Check if loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        //Check if data doen not exists
        if (!snapshot.data!.exists) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('User does not exist!')),
          );
        }

        // get user data
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        // create usermidel
        UserModel userModel = UserModel.fromMap(userData);
        // Get current user id
        final authProvider = context.read<AuthenticationProvider>();
        final currentUserUid = authProvider.isLoggedIn;
        final isOwner = currentUserUid == uid;

        return Column(
          children: [
            UserImageAvatar(radius: 50, imageUrl: userModel.profilePic),
            const SizedBox(height: 16),
            Text(
              userModel.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              userModel.profileId,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ReadMoreText(
              userModel.aboutMe,
              style: Theme.of(context).textTheme.bodyMedium,
              trimMode: TrimMode.Line,
              trimLines: 2,
              colorClickableText: Colors.blue,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              moreStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialDetails(label: 'Post', count: userModel.posts),
                SocialDetails(label: 'Followers', count: userModel.followers),
                SocialDetails(label: 'Following', count: userModel.following),
              ],
            ),
            const SizedBox(height: 16),
            isOwner
                ? MainAppButton(
                  icon: Icons.edit,
                  label: 'Edit Profile',
                  onPressed: () {
                    // navigate to edit profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                )
                : FollowButton(uid: uid),
          ],
        );
      },
    );
  }
}
