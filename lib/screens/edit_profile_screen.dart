import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/screens/home_screen.dart';
import 'package:wall_share/widgets/main_app_button.dart';
import 'package:wall_share/widgets/user_image_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // text editing controllers
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Get user data from provider
  void getUserData() {
    // Make widget rebuild

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final authProvider = context.read<AuthenticationProvider>();
        _nameController.text = authProvider.userModel!.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                UserImageAvatar(
                  radius: 50,
                  imageUrl: authProvider.userModel!.profilePic,
                  isViewOnly: false,
                  onPressed: () {},
                ),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                const SizedBox(height: 16),

                // logout button
                MainAppButton(
                  icon: Icons.logout,
                  label: 'Logout',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  onPressed: () async {
                    final authProvider = context.read<AuthenticationProvider>();

                    await authProvider.signOut().whenComplete(() {
                      // navigaet user to home screen
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
