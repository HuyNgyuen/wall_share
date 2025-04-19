import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:wall_share/utilities/utilities.dart';

class StyleSelectorButton extends StatelessWidget {
  const StyleSelectorButton({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  final ImageAIStyle? selectedStyle;
  final ValueChanged<ImageAIStyle?> onStyleSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ImageAIStyle>(
      menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
      value: selectedStyle ?? ImageAIStyle.noStyle,
      items:
          ImageAIStyle.values.map((style) {
            return DropdownMenuItem<ImageAIStyle>(
              value: style,
              child: Text(
                Utilities.convertEnumToString(style),
                style: TextStyle(
                  color:
                      style == ImageAIStyle.noStyle
                          ? Theme.of(context).hintColor
                          : null,
                ),
              ),
            );
          }).toList(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      icon: const Icon(Icons.brush),
      onChanged: onStyleSelected,
    );
  }
}
