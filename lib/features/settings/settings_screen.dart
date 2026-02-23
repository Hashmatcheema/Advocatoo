import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/settings/app_settings.dart';
import '../../utils/constants.dart';

/// Settings: theme, accessibility, reminders. Reactive via [appSettingsProvider].
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme section
          const ListTile(
            title: Text('Theme'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PaletteSwatch(color: Theme.of(context).colorScheme.primary),
                _PaletteSwatch(color: Theme.of(context).colorScheme.secondary),
                _PaletteSwatch(color: Theme.of(context).colorScheme.tertiary),
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
          // Accessibility
          const ListTile(
            title: Text('Accessibility'),
          ),
          SwitchListTile(
            title: const Text('Large Text'),
            subtitle: const Text('Increase text size across the app'),
            value: settings.largeText,
            onChanged: (value) => notifier.setLargeText(value),
          ),
          ListTile(
            title: Text(
              'Aa',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: settings.largeText
                        ? (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24) *
                            AppConstants.largeTextScaleFactor
                        : null,
                  ),
            ),
            subtitle: const Text('Preview'),
          ),
          const Divider(),
          // Reminders
          SwitchListTile(
            title: const Text('Daily reminders'),
            subtitle: Text(
              settings.remindersEnabled
                  ? 'Hearing reminders at 07:00 (Mon–Sat)'
                  : 'Reminders off',
            ),
            value: settings.remindersEnabled,
            onChanged: (value) => notifier.setRemindersEnabled(value),
          ),
          if (settings.remindersEnabled) ...[
            ListTile(
              title: const Text('Reminder time'),
              subtitle: Text(
                '${AppConstants.reminderHour.toString().padLeft(2, '0')}:${AppConstants.reminderMinute.toString().padLeft(2, '0')}',
              ),
            ),
            const ListTile(
              title: Text('Reminder days'),
              subtitle: Text('Mon–Sat (Sunday excluded)'),
            ),
          ],
          const Divider(),
          ListTile(
            title: const Text('Date format'),
            subtitle: Text(AppConstants.dateFormatPattern),
          ),
          const ListTile(
            title: Text('Time format'),
            subtitle: Text('12-hour (AM/PM)'),
          ),
        ],
      ),
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
