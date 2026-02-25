import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'database/app_database.dart';
import 'services/notification_service.dart';
import 'services/theme_service.dart';

/// In-app splash shown while initializing (DB, notifications, settings).
/// Calls [onComplete] with loaded theme and large-text preference.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  final void Function(ThemeMode themeMode, bool largeText, bool remindersEnabled)
      onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _minDisplayDuration = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final stopwatch = Stopwatch()..start();

    await AppDatabase.init();
    try {
      await NotificationService.instance.init();
    } catch (_) {
      // Skip if plugin not available (e.g., in widget tests on host machine).
    }


    final themeMode = await ThemeService.instance.getThemeMode();
    final largeText = await ThemeService.instance.getLargeTextEnabled();
    final remindersEnabled =
        await ThemeService.instance.getNotificationsEnabled();

    try {
      if (remindersEnabled) {
        await NotificationService.instance.requestPermission();
        await NotificationService.instance.scheduleDailyReminders();
      } else {
        await NotificationService.instance.cancelAll();
      }
    } catch (_) {
      // Skip if plugin not available (e.g. web).
    }

    final elapsed = stopwatch.elapsed;
    if (elapsed < _minDisplayDuration) {
      await Future.delayed(_minDisplayDuration - elapsed);
    }

    if (mounted) {
      widget.onComplete(themeMode, largeText, remindersEnabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  'assets/lottie/splash.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Advocato',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
