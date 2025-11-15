import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  final Function()? onTap;
  final String text; // <-- ADD THIS

  const LogInButton({
    super.key,
    required this.onTap,
    required this.text, // <-- USE IT HERE
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB3AE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text, // <-- THIS MAKES THE BUTTON TEXT COME FROM THE LOGIN PAGE
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
