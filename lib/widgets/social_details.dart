import 'package:flutter/material.dart';
import 'package:wall_share/utilities/utilities.dart';

class SocialDetails extends StatelessWidget {
  const SocialDetails({
    super.key,
    required this.label,
    required this.count,
    this.onPressed,
  });

  final String label;
  final int count;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            Utilities.formatNumber(count),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
