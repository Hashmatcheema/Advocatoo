import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/notification_service.dart';
import '../../services/theme_service.dart';

/// App-wide settings model; persisted via [ThemeService].
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.largeText = false,
    this.remindersEnabled = true,
  });

  final ThemeMode themeMode;
  final bool largeText;
  final bool remindersEnabled;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? largeText,
    bool? remindersEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      largeText: largeText ?? this.largeText,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }
}

/// Notifier that holds [AppSettings] and persists via [ThemeService].
class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setFromSplash(ThemeMode themeMode, bool largeText, bool remindersEnabled) {
    state = state.copyWith(
      themeMode: themeMode,
      largeText: largeText,
      remindersEnabled: remindersEnabled,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ThemeService.instance.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLargeText(bool enabled) async {
    await ThemeService.instance.setLargeTextEnabled(enabled);
    state = state.copyWith(largeText: enabled);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    await ThemeService.instance.setNotificationsEnabled(enabled);
    try {
      if (enabled) {
        await NotificationService.instance.requestPermission();
        await NotificationService.instance.scheduleDailyReminders();
      } else {
        await NotificationService.instance.cancelAll();
      }
    } catch (_) {
      // Skip if plugin not available (e.g. web).
    }
    state = state.copyWith(remindersEnabled: enabled);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);
