import 'package:flutter/material.dart';

class HomeSearchbar extends StatelessWidget {
  const HomeSearchbar({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: TextField(
        onChanged: (value) => onSearch(value),
        decoration: InputDecoration(
          hintText: 'Search wallpapers...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
