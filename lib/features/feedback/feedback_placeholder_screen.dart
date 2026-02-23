import 'package:flutter/material.dart';

/// Placeholder until Increment 6 (opens email/WhatsApp chooser).
class FeedbackPlaceholderScreen extends StatelessWidget {
  const FeedbackPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
      ),
      body: const Center(
        child: Text('Send Feedback (Increment 6)'),
      ),
    );
  }
}
