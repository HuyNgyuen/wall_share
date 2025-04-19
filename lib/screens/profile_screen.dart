import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/providers/theme_provider.dart';
import 'package:wall_share/providers/wallpaper_provider.dart';
import 'package:wall_share/utilities/utilities.dart';
import 'package:wall_share/widgets/user_info_section.dart';
import 'package:wall_share/widgets/wallpapers_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isOwner = widget.uid.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Profile'),
        actions:
            isOwner
                ? [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        themeProvider.toggleTheme();
                      });
                    },
                    icon: Icon(
                      !themeProvider.getIsDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // navigate tp notifications screen
                    },
                    icon: const Icon(Icons.notifications),
                  ),
                ]
                : null,
      ),
      body: Column(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: UserInfoSection(uid: widget.uid),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: WallpapersGrid(
                query: context
                    .read<WallpaperProvider>()
                    .getCurrentUserWallpapersQuery(widget.uid),
                crossAxisCount: 3,
                onTap: (wallpaper) {
                  // navigate to the wallpaper detail screen
                  Utilities.navigateToWallpaperDetailsScreen(
                    context,
                    wallpaper,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
