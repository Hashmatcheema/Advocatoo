import 'package:flutter/material.dart';

/// Placeholder until Increment 6.
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile screen (Increment 6)'),
      ),
    );
  }
}
