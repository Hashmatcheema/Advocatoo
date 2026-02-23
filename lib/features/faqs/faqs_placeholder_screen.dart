import 'package:flutter/material.dart';

/// Placeholder until Increment 6.
class FaqsPlaceholderScreen extends StatelessWidget {
  const FaqsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: const Center(
        child: Text('FAQs (Increment 6)'),
      ),
    );
  }
}
