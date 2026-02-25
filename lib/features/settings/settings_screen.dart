import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/settings/app_settings.dart';
import 'backup_restore_service.dart';

/// Settings: theme, accessibility, reminders (configurable), date/time format.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _dateFormats = ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd'];
  static const _weekdayLabels = {
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Theme ──
          _sectionHeader(context, 'Theme'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PaletteSwatch(color: colorScheme.primary),
                _PaletteSwatch(color: colorScheme.secondary),
                _PaletteSwatch(color: colorScheme.tertiary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto, size: 18),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (Set<ThemeMode> selected) {
                if (selected.isNotEmpty) {
                  notifier.setThemeMode(selected.first);
                }
              },
            ),
          ),

          const Divider(),

          // ── Accessibility ──
          _sectionHeader(context, 'Accessibility'),
          SwitchListTile(
            title: const Text('Large Text'),
            subtitle: const Text('Increase text size across the app'),
            value: settings.largeText,
            onChanged: (value) => notifier.setLargeText(value),
          ),

          const Divider(),

          // ── Reminders ──
          _sectionHeader(context, 'Reminders'),
          SwitchListTile(
            title: const Text('Daily reminders'),
            subtitle: Text(
              settings.remindersEnabled
                  ? 'Reminders at ${_formatTime(settings.reminderHour, settings.reminderMinute)}'
                  : 'Reminders off',
            ),
            value: settings.remindersEnabled,
            onChanged: (value) => notifier.setRemindersEnabled(value),
          ),
          if (settings.remindersEnabled) ...[
            ListTile(
              title: const Text('Reminder time'),
              subtitle: Text(_formatTime(settings.reminderHour, settings.reminderMinute)),
              trailing: const Icon(Icons.access_time_rounded, size: 20),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute),
                );
                if (picked != null) {
                  notifier.setReminderTime(picked.hour, picked.minute);
                }
              },
            ),
            ListTile(
              title: const Text('Excluded days'),
              subtitle: Text(_excludedDaysLabel(settings.excludedDays)),
              trailing: const Icon(Icons.edit_calendar_rounded, size: 20),
              onTap: () => _showExcludedDaysPicker(context, settings.excludedDays, notifier),
            ),
          ],

          const Divider(),

          // ── Date & Time Format ──
          _sectionHeader(context, 'Date & Time Format'),
          ListTile(
            title: const Text('Date format'),
            subtitle: Text(settings.dateFormat),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _showDateFormatPicker(context, settings.dateFormat, notifier),
          ),
          SwitchListTile(
            title: const Text('24-hour time'),
            subtitle: Text(settings.use24hTime ? 'Using 24h format (e.g. 14:30)' : 'Using 12h format (e.g. 2:30 PM)'),
            value: settings.use24hTime,
            onChanged: (value) => notifier.setUse24hTime(value),
          ),
          const Divider(),

          // ── Data ──
          _sectionHeader(context, 'Data Management'),
          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Export Backup'),
            subtitle: const Text('Save your database as a JSON file'),
            onTap: () async {
              final service = ref.read(backupRestoreServiceProvider);
              if (kIsWeb) {
                final success = await service.shareBackup();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup shared successfully!')));
                }
              } else {
                final path = await service.exportBackup();
                if (path != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup saved to $path')));
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text('Share Backup'),
            subtitle: const Text('Share your backup file via other apps'),
            onTap: () async {
              final success = await ref.read(backupRestoreServiceProvider).shareBackup();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup shared successfully!')));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Restore Backup'),
            subtitle: const Text('Import data from a backup JSON file'),
            onTap: () async {
              final success = await ref.read(backupRestoreServiceProvider).importBackup();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Restore successful!' : 'Restore failed.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    final tod = TimeOfDay(hour: hour, minute: minute);
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  String _excludedDaysLabel(Set<int> days) {
    if (days.isEmpty) return 'None';
    return days.map((d) => _weekdayLabels[d] ?? '?').join(', ');
  }

  void _showExcludedDaysPicker(BuildContext context, Set<int> current, AppSettingsNotifier notifier) {
    final selected = Set<int>.from(current);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Excluded Days'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: _weekdayLabels.entries.map((e) {
                  return CheckboxListTile(
                    title: Text(e.value),
                    value: selected.contains(e.key),
                    onChanged: (v) {
                      setDialogState(() {
                        if (v == true) {
                          selected.add(e.key);
                        } else {
                          selected.remove(e.key);
                        }
                      });
                    },
                    dense: true,
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    notifier.setExcludedDays(selected);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDateFormatPicker(BuildContext context, String current, AppSettingsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Date Format'),
          children: _dateFormats.map((fmt) {
            final selected = fmt == current;
            return ListTile(
              title: Text(fmt),
              leading: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? Theme.of(ctx).colorScheme.primary : null,
              ),
              onTap: () {
                notifier.setDateFormat(fmt);
                Navigator.of(ctx).pop();
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
    );
  }
}
