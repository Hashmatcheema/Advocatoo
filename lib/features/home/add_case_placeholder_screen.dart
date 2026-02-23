import 'package:flutter/material.dart';

/// Placeholder until Increment 2 (full Add Case modal).
class AddCasePlaceholderScreen extends StatelessWidget {
  const AddCasePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Case'),
      ),
      body: const Center(
        child: Text('Add Case form (Increment 2)'),
      ),
    );
  }
}
