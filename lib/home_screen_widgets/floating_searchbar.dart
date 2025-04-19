import 'dart:ui';

import 'package:flutter/material.dart';

class FloatingSearchbar extends StatelessWidget {
  const FloatingSearchbar({
    super.key,
    required this.onArrowPressed,
    required this.onChanged,
  });

  final VoidCallback onArrowPressed;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  onPressed: onArrowPressed,
                  icon: const Icon(Icons.arrow_upward),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) => onChanged(value),
                    decoration: InputDecoration(
                      hintText: 'Search wallpapers...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
