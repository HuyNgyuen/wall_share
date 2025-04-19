import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/screens/profile_screen.dart';
import 'package:wall_share/utilities/assets_manager.dart';
import 'package:wall_share/utilities/utilities.dart';
import 'package:wall_share/widgets/sign_in_button.dart';
import 'package:wall_share/widgets/user_image_avatar.dart';

class UserInfoData extends StatelessWidget {
  const UserInfoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        // check if user is logged in
        bool isSignedIn = authProvider.isLoggedIn.isNotEmpty;
        // get user uid
        String uid = isSignedIn ? authProvider.userModel!.uid : '';
        // get the user image
        String imageUrl = isSignedIn ? authProvider.userModel!.profilePic : '';

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              isSignedIn
                  ? TextButton(
                    onPressed: () {
                      // navigate to the profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(uid: uid),
                        ),
                      );
                    },
                    child: Text(
                      authProvider.userModel!.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : SignInButton(
                    logoUrl: AssetsManager.googleIcon,
                    label: 'Sign In',
                    onPressed: () async {
                      // sign in with google
                      await authProvider.signInUser(
                        showLoading: (value) {
                          if (value) {
                            // sshow loading diaalog
                            Utilities.showAnimatedDialog(
                              context: context,
                              title: 'Authenticating',
                              content: const LinearProgressIndicator(),
                            );
                          } else {
                            // disable loading
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
              UserImageAvatar(radius: 20, imageUrl: imageUrl, isViewOnly: true),
            ],
          ),
        );
      },
    );
  }
}
