import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/providers/wallpaper_provider.dart';
import 'package:wall_share/utilities/utilities.dart';
import 'package:wall_share/widgets/main_app_button.dart';
import 'package:wall_share/widgets/style_selector_button.dart';

class PrompInputField extends StatefulWidget {
  const PrompInputField({super.key, required this.onGenerated});

  final Function(String) onGenerated;

  @override
  State<PrompInputField> createState() => _PrompInputFieldState();
}

class _PrompInputFieldState extends State<PrompInputField> {
  final TextEditingController _promptController = TextEditingController();
  ImageAIStyle? _selectedStyle;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  // generate wallpaper
  Future<void> _generateWallpaper() async {
    if (_promptController.text.isEmpty) {
      // show snackbar that prompt is empty
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a prompt')));
      return;
    }

    // check if the user is authenticated
    final authProvider = context.read<AuthenticationProvider>();
    // check if user is logged in
    bool isSignedIn = authProvider.isLoggedIn.isNotEmpty;
    if (!isSignedIn) {
      // show snackbar that you need to sign in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to generate wallpaper')),
      );
      return;
    }

    // show loading dialog
    Utilities.showAnimatedDialog(
      context: context,
      title: 'Generating Wallpaper',
      content: const LinearProgressIndicator(),
    );

    // generate wallpaper
    context.read<WallpaperProvider>().generateWallpaper(
      prompt: _promptController.text,
      imageAIStyle: _selectedStyle ?? ImageAIStyle.noStyle,
      onComplete: (message) {
        widget.onGenerated(_promptController.text);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // choode style text
          const Padding(
            padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              'Choose Style',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          // style selector button
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.surface),
            ),
            child: StyleSelectorButton(
              selectedStyle: _selectedStyle,
              onStyleSelected:
                  (style) => setState(() {
                    _selectedStyle = style;
                  }),
            ),
          ),

          // Prompt input section
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _promptController,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'describe the wallpaper you want to create...',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor.withOpacity(0.6),
                  fontSize: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Generate button
          MainAppButton(
            icon: Icons.auto_awesome,
            label: 'Generate Wallpaper',
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Colors.white,
            onPressed: _generateWallpaper,
          ),
        ],
      ),
    );
  }
}
