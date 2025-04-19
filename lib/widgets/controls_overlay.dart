import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_share/models/wallpaper.dart';
import 'package:wall_share/providers/authentication_provider.dart';
import 'package:wall_share/providers/wallpaper_provider.dart';
import 'package:wall_share/utilities/utilities.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({
    super.key,
    required this.isAIMode,
    required this.onSharePressed,
  });

  final bool isAIMode;
  final Function(String title, String category) onSharePressed;

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                context.read<WallpaperProvider>().clearState();
              },
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(Icons.close),
            ),
            FloatingActionButton(
              onPressed: () {
                if (!widget.isAIMode) {
                  final authProvider = context.read<AuthenticationProvider>();
                  // check if user is logged in
                  bool isSignedIn = authProvider.isLoggedIn.isNotEmpty;
                  if (!isSignedIn) {
                    // show snackbar that you need to sign in
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please sign in to generate wallpaper'),
                      ),
                    );
                    return;
                  }
                  // show dialog for user inputs
                  String selectedCategory =
                      Wallpaper.categories.where((cat) => cat != 'All').first;

                  // show dialog for user inputs
                  Utilities.showAnimatedDialog(
                    context: context,
                    title: 'Enter a title for your wallpaper',
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _titleController,
                              maxLength: 25,
                              decoration: const InputDecoration(
                                hintText: 'Enter a title',
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Select Category',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              width: double.maxFinite,
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    Wallpaper.categories
                                        .where((cat) => cat != 'All')
                                        .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 2.5,
                                    ),
                                itemBuilder: (context, index) {
                                  final category = Wallpaper.categories
                                      .where((cat) => cat != 'All')
                                      .elementAt(index);

                                  final isSelected =
                                      selectedCategory == category;

                                  return InkWell(
                                    onTap:
                                        () => setState(
                                          () => selectedCategory = category,
                                        ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_titleController.text.isNotEmpty) {
                            Navigator.pop(context);
                            // share the wallpaper
                            widget.onSharePressed(
                              _titleController.text,
                              selectedCategory,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a title'),
                              ),
                            );
                          }
                        },
                        child: const Text('Share'),
                      ),
                    ],
                  );

                  // check if the user is authenticated
                } else {
                  // share the wallpaper
                  widget.onSharePressed('', '');
                }
              },
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }
}
