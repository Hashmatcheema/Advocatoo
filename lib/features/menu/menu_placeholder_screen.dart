import 'package:flutter/material.dart';

/// Placeholder body when Menu tab is selected (panel overlays this).
class MenuPlaceholderScreen extends StatelessWidget {
  const MenuPlaceholderScreen({super.key, this.largeText = false});

  final bool largeText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Use the menu panel to open Profile, Settings, and more.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
