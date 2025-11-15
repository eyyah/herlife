import 'package:flutter/material.dart';

class CurvedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLeft; // Quick Tips = left, Hotline = right

  const CurvedButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        isLeft
            ? 'lib/images/tips.png'        // Quick Tips
            : 'lib/images/hotline.png',    // Call Hotline
        width: 180,
        height: 200,
      ),
    );
  }
}
