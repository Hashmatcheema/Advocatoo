import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

import '../database/app_database.dart';
import '../utils/constants.dart';

/// Schedules daily reminder at 07:00 (Mon–Sat) with next 7 days' hearings.
/// Requires [NotificationService.init] and [NotificationService.scheduleDailyReminders] after DB is ready.
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const int _reminderId = 1;
  static const String _channelId = 'advocato_reminders';
  static const String _channelName = 'Hearing Reminders';

  bool _initialized = false;

  /// Call once after WidgetsFlutterBinding and before scheduling.
  Future<void> init() async {
    if (kIsWeb) return;
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
    } catch (_) {
      // Fallback to local if Asia/Karachi not found
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
    );
    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings: initSettings);
    _initialized = true;
  }

  /// Request notification permission (Android 13+). Call on first launch or when enabling in settings.
  Future<bool> requestPermission() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return true;
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;
    final granted = await android.requestNotificationsPermission();
    return granted ?? false;
  }

  /// Cancel all pending reminders.
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAllPendingNotifications();
  }

  /// Build summary of hearings from [fromIso] to [toIso] (inclusive).
  Future<String> _buildNext7DaysSummary(String fromIso, String toIso) async {
    final db = AppDatabase.instance;
    final hearings = await db.getHearingsFromUntil(fromIso, toIso);
    if (hearings.isEmpty) return 'No hearings in the next 7 days.';
    final buffer = StringBuffer();
    for (final h in hearings) {
      final caseRow = await db.getCaseById(h.caseId);
      final title = caseRow?.title ?? 'Case #${h.caseId}';
      final timeStr = h.hearingTime != null && h.hearingTime!.isNotEmpty ? ' ${h.hearingTime}' : '';
      buffer.writeln('• $title: ${h.hearingDate}$timeStr${h.purpose != null && h.purpose!.isNotEmpty ? ' — ${h.purpose}' : ''}');
    }
    return buffer.toString().trim();
  }

  /// Schedule daily reminders for the next 6 allowed weekdays.
  /// [hour] and [minute] are the notification time; [excludedDays] are skipped.
  Future<void> scheduleDailyReminders({
    int hour = AppConstants.reminderHour,
    int minute = AppConstants.reminderMinute,
    Set<int> excludedDays = const {DateTime.sunday},
  }) async {
    if (kIsWeb) return;
    if (!_initialized) return;

    await cancelAll();

    final db = AppDatabase.instance;
    final now = tz.TZDateTime.now(tz.local);
    final today = DateTime(now.year, now.month, now.day);

    // Next 6 weekdays (skip excluded days)
    final weekdays = <DateTime>[];
    for (var i = 0; weekdays.length < 6; i++) {
      final d = today.add(Duration(days: i));
      if (excludedDays.contains(d.weekday)) continue;
      weekdays.add(d);
    }

    for (var i = 0; i < weekdays.length; i++) {
      final day = weekdays[i];
      final fromIso = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final endDay = day.add(const Duration(days: 6));
      final toIso =
          '${endDay.year}-${endDay.month.toString().padLeft(2, '0')}-${endDay.day.toString().padLeft(2, '0')}';
      final summary = await _buildNext7DaysSummary(fromIso, toIso);

      final scheduledDate = tz.TZDateTime(
        tz.local,
        day.year,
        day.month,
        day.day,
        hour,
        minute,
      );
      // If that time is in the past, skip (shouldn't happen for "next" weekdays, but safe)
      if (scheduledDate.isBefore(now)) continue;

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Daily hearing reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );
      const iosDetails = DarwinNotificationDetails();
      const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _plugin.zonedSchedule(
        id: _reminderId + i,
        title: 'Advocato Reminder',
        body: summary.length > 200 ? '${summary.substring(0, 197)}...' : summary,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      await db.insertNotificationHistory(NotificationHistoryCompanion.insert(
        triggeredAt: scheduledDate.toUtc().toIso8601String(),
        summary: summary.length > 500 ? '${summary.substring(0, 497)}...' : summary,
      ));
    }
  }
}
