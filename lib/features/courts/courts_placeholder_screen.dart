import 'package:flutter/material.dart';

/// Placeholder until Increment 2.
class CourtsPlaceholderScreen extends StatelessWidget {
  const CourtsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts Manager'),
      ),
      body: const Center(
        child: Text('Courts Manager (Increment 2)'),
      ),
    );
  }
}
