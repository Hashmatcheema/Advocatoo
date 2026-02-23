import 'package:animations/animations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/settings/app_settings.dart';
import 'app/theme/advocato_theme.dart';
import 'app_shell.dart';
import 'splash_screen.dart';
import 'widgets/dashboard_sheet.dart';
import 'features/about/about_screen.dart';
import 'features/courts/courts_manager_screen.dart';
import 'features/faqs/faqs_screen.dart';
import 'features/feedback/feedback_screen.dart';
import 'features/case/add_edit_case_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AdvocatoApp(),
    ),
  );
}

class AdvocatoApp extends ConsumerStatefulWidget {
  const AdvocatoApp({super.key});

  @override
  ConsumerState<AdvocatoApp> createState() => _AdvocatoAppState();
}

class _AdvocatoAppState extends ConsumerState<AdvocatoApp> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    final lightTheme = buildAdvocatoLightTheme();
    final darkTheme = buildAdvocatoDarkTheme();
    final settings = ref.watch(appSettingsProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final light = lightDynamic != null
            ? lightTheme.copyWith(colorScheme: lightDynamic)
            : lightTheme;
        final dark = darkDynamic != null
            ? darkTheme.copyWith(colorScheme: darkDynamic)
            : darkTheme;
        final themeMode =
            _loading ? ThemeMode.system : settings.themeMode;

        return MaterialApp(
          title: 'Advocato',
          theme: light,
          darkTheme: dark,
          themeMode: themeMode,
          home: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<bool>(_loading),
              child: _loading
                  ? SplashScreen(
                      onComplete: (ThemeMode mode, bool largeText,
                          bool remindersEnabled) {
                        ref.read(appSettingsProvider.notifier).setFromSplash(
                              mode,
                              largeText,
                              remindersEnabled,
                            );
                        setState(() => _loading = false);
                      },
                    )
                  : MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: settings.largeText
                            ? TextScaler.linear(
                                AppConstants.largeTextScaleFactor)
                            : null,
                      ),
                      child: _AdvocatoShell(
                        themeMode: settings.themeMode,
                        largeTextMode: settings.largeText,
                        onThemeModeChanged: (mode) =>
                            ref.read(appSettingsProvider.notifier).setThemeMode(mode),
                        onLargeTextChanged: (enabled) =>
                            ref.read(appSettingsProvider.notifier).setLargeText(enabled),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _AdvocatoShell extends StatelessWidget {
  const _AdvocatoShell({
    required this.themeMode,
    required this.largeTextMode,
    required this.onThemeModeChanged,
    required this.onLargeTextChanged,
  });

  final ThemeMode themeMode;
  final bool largeTextMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onLargeTextChanged;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: largeTextMode
            ? TextScaler.linear(AppConstants.largeTextScaleFactor)
            : null,
      ),
      child: AppShell(
        themeMode: themeMode,
        largeTextMode: largeTextMode,
        onThemeModeChanged: onThemeModeChanged,
        onLargeTextChanged: onLargeTextChanged,
        onNavigateToProfile: () => _push(context, const ProfileScreen()),
        onNavigateToCourtsManager: () =>
            _push(context, const CourtsManagerScreen()),
        onNavigateToSettings: () =>
            _push(context, const SettingsScreen()),
        onNavigateToFaqs: () => _push(context, const FaqsScreen()),
        onNavigateToAbout: () => _push(context, const AboutScreen()),
        onNavigateToSendFeedback: () =>
            _push(context, const FeedbackScreen()),
        onAddCase: () => _push(context, const AddEditCaseScreen()),
        onDashboardTap: () => showDashboardSheet(context),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }
}
