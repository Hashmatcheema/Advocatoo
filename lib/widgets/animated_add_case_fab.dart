import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// FAB for "Add Case" with entrance animation and tap scale feedback (flutter_animate).
class AnimatedAddCaseFab extends StatefulWidget {
  const AnimatedAddCaseFab({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<AnimatedAddCaseFab> createState() => _AnimatedAddCaseFabState();
}

class _AnimatedAddCaseFabState extends State<AnimatedAddCaseFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: FloatingActionButton(
        onPressed: () {
          setState(() => _pressed = true);
          widget.onPressed();
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) setState(() => _pressed = false);
          });
        },
        child: const Icon(Icons.add),
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 250.ms);
  }
}
