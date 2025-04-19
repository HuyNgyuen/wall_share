import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.logoUrl,
    required this.label,
    this.imageHeight = 20.0,
    this.imageWidth = 20.0,
    required this.onPressed,
  });

  final String logoUrl;
  final String label;
  final double imageHeight;
  final double imageWidth;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(logoUrl, width: imageWidth, height: imageHeight),
            const SizedBox(width: 10.0),
            Text(label, style: const TextStyle(letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}
