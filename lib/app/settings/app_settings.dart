import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/notification_service.dart';
import '../../services/theme_service.dart';
import '../../utils/constants.dart';

/// App-wide settings model; persisted via [ThemeService].
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.largeText = false,
    this.remindersEnabled = true,
    this.reminderHour = 7,
    this.reminderMinute = 0,
    this.excludedDays = const {DateTime.sunday},
    this.dateFormat = AppConstants.dateFormatPattern,
    this.use24hTime = false,
    this.appLockEnabled = false,
  });

  final ThemeMode themeMode;
  final bool largeText;
  final bool remindersEnabled;
  final int reminderHour;
  final int reminderMinute;
  final Set<int> excludedDays;
  final String dateFormat;
  final bool use24hTime;
  final bool appLockEnabled;

  /// The time format pattern derived from [use24hTime].
  String get timeFormatPattern =>
      use24hTime ? AppConstants.timeFormat24hPattern : AppConstants.timeFormat12hPattern;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? largeText,
    bool? remindersEnabled,
    int? reminderHour,
    int? reminderMinute,
    Set<int>? excludedDays,
    String? dateFormat,
    bool? use24hTime,
    bool? appLockEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      largeText: largeText ?? this.largeText,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      excludedDays: excludedDays ?? this.excludedDays,
      dateFormat: dateFormat ?? this.dateFormat,
      use24hTime: use24hTime ?? this.use24hTime,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
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
    // Load persisted advanced settings.
    _loadAdvancedSettings();
  }

  Future<void> _loadAdvancedSettings() async {
    final ts = ThemeService.instance;
    final hour = await ts.getReminderHour();
    final minute = await ts.getReminderMinute();
    final excluded = await ts.getExcludedDays();
    final dateFmt = await ts.getDateFormat();
    final use24h = await ts.getUse24hTime();
    final appLock = await ts.getAppLockEnabled();
    state = state.copyWith(
      reminderHour: hour,
      reminderMinute: minute,
      excludedDays: excluded,
      dateFormat: dateFmt,
      use24hTime: use24h,
      appLockEnabled: appLock,
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
        await NotificationService.instance.scheduleDailyReminders(
          hour: state.reminderHour,
          minute: state.reminderMinute,
          excludedDays: state.excludedDays,
        );
      } else {
        await NotificationService.instance.cancelAll();
      }
    } catch (_) {
      // Skip if plugin not available (e.g. web).
    }
    state = state.copyWith(remindersEnabled: enabled);
  }

  Future<void> setReminderTime(int hour, int minute) async {
    await ThemeService.instance.setReminderTime(hour, minute);
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    // Reschedule reminders with the new time.
    if (state.remindersEnabled) {
      try {
        await NotificationService.instance.scheduleDailyReminders(
          hour: hour,
          minute: minute,
          excludedDays: state.excludedDays,
        );
      } catch (_) {}
    }
  }

  Future<void> setExcludedDays(Set<int> days) async {
    await ThemeService.instance.setExcludedDays(days);
    state = state.copyWith(excludedDays: days);
    // Reschedule reminders with new excluded days.
    if (state.remindersEnabled) {
      try {
        await NotificationService.instance.scheduleDailyReminders(
          hour: state.reminderHour,
          minute: state.reminderMinute,
          excludedDays: days,
        );
      } catch (_) {}
    }
  }

  Future<void> setDateFormat(String format) async {
    await ThemeService.instance.setDateFormat(format);
    state = state.copyWith(dateFormat: format);
  }

  Future<void> setUse24hTime(bool use24h) async {
    await ThemeService.instance.setUse24hTime(use24h);
    state = state.copyWith(use24hTime: use24h);
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await ThemeService.instance.setAppLockEnabled(enabled);
    state = state.copyWith(appLockEnabled: enabled);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);
