import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../utils/constants.dart';

/// About screen: version, credits (Increment 6).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              'Advocato',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0, duration: 400.ms),
            const SizedBox(height: 8),
            Text(
              'Legal Practice Management for Pakistani Lawyers',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                title: const Text('Version'),
                trailing: Text('$appVersion+$buildNumber'),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideX(begin: 0.05, end: 0, duration: 300.ms),
            const SizedBox(height: 24),
            Text(
              'Credits',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            const SizedBox(height: 8),
            Text(
              'Built with Flutter. Offline-first, single-user. '
              'Designed for advocates practising in Pakistan. '
              'Date format: ${AppConstants.dateFormatPattern}. '
              'Time format: 12-hour (AM/PM).',
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
            const SizedBox(height: 16),
            Text(
              '© 2026 Advocato. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
