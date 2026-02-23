import 'package:flutter/material.dart';

/// Placeholder until Increment 6.
class AboutPlaceholderScreen extends StatelessWidget {
  const AboutPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Text('About (Increment 6)'),
      ),
    );
  }
}
