import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class PromptWidget extends StatelessWidget {
  const PromptWidget({super.key, required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prompt:',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ReadMoreText(
          prompt,
          style: const TextStyle(color: Colors.white70),
          trimMode: TrimMode.Line,
          trimLines: 2,
          colorClickableText: Colors.blue,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
