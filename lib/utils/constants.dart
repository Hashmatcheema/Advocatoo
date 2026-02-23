/// Global date and time format constants for Advocato.
/// SRD: DD/MM/YYYY and 12-hour (AM/PM) throughout.
class AppConstants {
  AppConstants._();

  /// Date format for display and input (Pakistan locale).
  static const String dateFormatPattern = 'dd/MM/yyyy';

  /// Time format for display (12-hour with AM/PM).
  static const String timeFormat12hPattern = 'hh:mm a';

  /// Time format for storage (24h); convert to 12h for display.
  static const String timeFormat24hPattern = 'HH:mm';

  /// Reminder time (SRD: 07:00 Mon–Sat).
  static const int reminderHour = 7;
  static const int reminderMinute = 0;

  /// SharedPreferences keys.
  static const String keyThemeMode = 'theme_mode'; // light, dark, system
  static const String keyLargeText = 'large_text_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyProfileName = 'profile_name';
  static const String keyProfileBarNumber = 'profile_bar_number';
  static const String keyProfileSpecialisation = 'profile_specialisation';
  static const String keyProfilePhone = 'profile_phone';
  static const String keyProfileEmail = 'profile_email';
  static const String keyProfilePhotoPath = 'profile_photo_path';

  /// Large text scale factor (SRD: 20% increase).
  static const double largeTextScaleFactor = 1.2;

  /// Horizontal screen padding; use for consistent layout.
  static const double screenPadding = 16;

  /// Spacing between filter chips / options (responsive via LayoutBuilder).
  static const double filterChipSpacing = 8;
}
