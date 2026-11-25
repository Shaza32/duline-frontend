import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final double dimOpacity;

  const AppBackground({
    super.key,
    required this.child,
    this.dimOpacity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/duline_background.png',
          fit: BoxFit.cover,
        ),

        ColoredBox(
          color: Colors.black.withValues(
            alpha: dimOpacity,
          ),
        ),

        child,
      ],
    );
  }
}