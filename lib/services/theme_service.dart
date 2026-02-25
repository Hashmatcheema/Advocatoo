import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Persists and restores theme mode, large text, reminders, date/time format.
class ThemeService {
  ThemeService._();
  static final ThemeService _instance = ThemeService._();
  static ThemeService get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Theme mode.
  Future<ThemeMode> getThemeMode() async {
    await init();
    final value = _prefs!.getString(AppConstants.keyThemeMode);
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await init();
    final value = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system';
    await _prefs!.setString(AppConstants.keyThemeMode, value);
  }

  // Large text.
  Future<bool> getLargeTextEnabled() async {
    await init();
    return _prefs!.getBool(AppConstants.keyLargeText) ?? false;
  }

  Future<void> setLargeTextEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool(AppConstants.keyLargeText, enabled);
  }

  // Notifications.
  Future<bool> getNotificationsEnabled() async {
    await init();
    return _prefs!.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool(AppConstants.keyNotificationsEnabled, enabled);
  }

  // Reminder time.
  Future<int> getReminderHour() async {
    await init();
    return _prefs!.getInt(AppConstants.keyReminderHour) ?? AppConstants.reminderHour;
  }

  Future<int> getReminderMinute() async {
    await init();
    return _prefs!.getInt(AppConstants.keyReminderMinute) ?? AppConstants.reminderMinute;
  }

  Future<void> setReminderTime(int hour, int minute) async {
    await init();
    await _prefs!.setInt(AppConstants.keyReminderHour, hour);
    await _prefs!.setInt(AppConstants.keyReminderMinute, minute);
  }

  // Excluded days (stored as comma-separated weekday ints, e.g. "7" for Sunday).
  Future<Set<int>> getExcludedDays() async {
    await init();
    final raw = _prefs!.getString(AppConstants.keyExcludedDays);
    if (raw == null || raw.isEmpty) return {DateTime.sunday};
    return raw.split(',').map((s) => int.tryParse(s.trim()) ?? 0).where((d) => d >= 1 && d <= 7).toSet();
  }

  Future<void> setExcludedDays(Set<int> days) async {
    await init();
    await _prefs!.setString(AppConstants.keyExcludedDays, days.join(','));
  }

  // Date format.
  Future<String> getDateFormat() async {
    await init();
    return _prefs!.getString(AppConstants.keyDateFormat) ?? AppConstants.dateFormatPattern;
  }

  Future<void> setDateFormat(String format) async {
    await init();
    await _prefs!.setString(AppConstants.keyDateFormat, format);
  }

  // Time format.
  Future<bool> getUse24hTime() async {
    await init();
    return _prefs!.getBool(AppConstants.keyUse24hTime) ?? false;
  }

  Future<void> setUse24hTime(bool use24h) async {
    await init();
    await _prefs!.setBool(AppConstants.keyUse24hTime, use24h);
  }

  // App Lock
  Future<bool> getAppLockEnabled() async {
    await init();
    return _prefs!.getBool('app_lock_enabled') ?? false;
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool('app_lock_enabled', enabled);
  }
}
