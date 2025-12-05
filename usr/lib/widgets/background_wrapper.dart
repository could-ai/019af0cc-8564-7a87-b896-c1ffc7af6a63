import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image Placeholder
          Container(
            decoration: const BoxDecoration(
              color: Colors.grey, // Fallback color
              // image: DecorationImage(
              //   image: AssetImage('assets/fondo.png'), // Will be enabled when user provides image
              //   fit: BoxFit.cover,
              //   opacity: 0.5, // 50% transparency as requested
              // ),
            ),
          ),
          // White area with light gray tone overlay (simulated by the child container usually)
          Container(
            color: Colors.grey.withOpacity(0.1),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
