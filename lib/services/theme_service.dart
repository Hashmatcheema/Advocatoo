import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Persists and restores theme mode and large text preference.
class ThemeService {
  ThemeService._();
  static final ThemeService _instance = ThemeService._();
  static ThemeService get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

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

  Future<bool> getLargeTextEnabled() async {
    await init();
    return _prefs!.getBool(AppConstants.keyLargeText) ?? false;
  }

  Future<void> setLargeTextEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool(AppConstants.keyLargeText, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    await init();
    return _prefs!.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool(AppConstants.keyNotificationsEnabled, enabled);
  }
}
