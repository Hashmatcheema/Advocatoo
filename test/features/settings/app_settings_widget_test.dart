import 'package:advocatoo/app/settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Fake notifier: returns a preset state without hitting ThemeService/SharedPrefs.
// ---------------------------------------------------------------------------

class _FakeSettingsNotifier extends AppSettingsNotifier {
  final AppSettings initial;
  _FakeSettingsNotifier(this.initial);

  @override
  AppSettings build() => initial;

  // Override mutators so they don't touch SharedPreferences.
  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
  }

  @override
  Future<void> setLargeText(bool enabled) async {
    state = state.copyWith(largeText: enabled);
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppSettings provider — theme mode toggles', () {
    test('default theme mode is system', () {
      const settings = AppSettings();
      expect(settings.themeMode, ThemeMode.system);
    });

    test('setThemeMode(dark) updates state to dark', () async {
      final notifier = _FakeSettingsNotifier(const AppSettings());
      notifier.build(); // initialise
      await notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.state.themeMode, ThemeMode.dark);
    });

    test('setThemeMode(light) updates state to light', () async {
      final notifier = _FakeSettingsNotifier(
        const AppSettings(themeMode: ThemeMode.dark),
      );
      await notifier.setThemeMode(ThemeMode.light);
      expect(notifier.state.themeMode, ThemeMode.light);
    });

    test('setThemeMode(system) resets to system', () async {
      final notifier = _FakeSettingsNotifier(
        const AppSettings(themeMode: ThemeMode.dark),
      );
      await notifier.setThemeMode(ThemeMode.system);
      expect(notifier.state.themeMode, ThemeMode.system);
    });
  });

  group('AppSettings provider — largeText toggle', () {
    test('default largeText is false', () {
      expect(const AppSettings().largeText, false);
    });

    test('setLargeText(true) updates state', () async {
      final notifier = _FakeSettingsNotifier(const AppSettings());
      await notifier.setLargeText(true);
      expect(notifier.state.largeText, true);
    });

    test('setLargeText(false) from true resets state', () async {
      final notifier = _FakeSettingsNotifier(
        const AppSettings(largeText: true),
      );
      await notifier.setLargeText(false);
      expect(notifier.state.largeText, false);
    });
  });

  group('AppSettings widget reflects provider state', () {
    testWidgets('default state shows system theme and largeText false', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appSettingsProvider.overrideWith(
              () => _FakeSettingsNotifier(const AppSettings()),
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final settings = ref.watch(appSettingsProvider);
              return MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      Text('themeMode:${settings.themeMode.name}'),
                      Text('largeText:${settings.largeText}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.text('themeMode:system'), findsOneWidget);
      expect(find.text('largeText:false'), findsOneWidget);
    });

    testWidgets('dark + largeText=true reflects in widget', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appSettingsProvider.overrideWith(
              () => _FakeSettingsNotifier(
                const AppSettings(themeMode: ThemeMode.dark, largeText: true),
              ),
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final settings = ref.watch(appSettingsProvider);
              return MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      Text('themeMode:${settings.themeMode.name}'),
                      Text('largeText:${settings.largeText}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.text('themeMode:dark'), findsOneWidget);
      expect(find.text('largeText:true'), findsOneWidget);
    });
  });
}
