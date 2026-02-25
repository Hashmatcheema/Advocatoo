import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/router/app_router.dart';
import 'app/settings/app_settings.dart';
import 'app/theme/advocato_theme.dart';
import 'utils/constants.dart';

void main() {
  // Global error handler for async Dart errors.
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      usePathUrlStrategy();

      // Global error handler for Flutter framework errors.
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        debugPrint('[FlutterError] ${details.exceptionAsString()}');
      };

      runApp(
        const ProviderScope(
          child: AdvocatoApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint('[ZoneError] $error\n$stack');
    },
  );
}

class AdvocatoApp extends ConsumerStatefulWidget {
  const AdvocatoApp({super.key});

  @override
  ConsumerState<AdvocatoApp> createState() => _AdvocatoAppState();
}

class _AdvocatoAppState extends ConsumerState<AdvocatoApp> {
  // Cache themes so they are not rebuilt on every frame.
  late final ThemeData _lightTheme = buildAdvocatoLightTheme();
  late final ThemeData _darkTheme = buildAdvocatoDarkTheme();

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final router = ref.watch(routerProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final light = lightDynamic != null
            ? _lightTheme.copyWith(colorScheme: lightDynamic)
            : _lightTheme;
        final dark = darkDynamic != null
            ? _darkTheme.copyWith(colorScheme: darkDynamic)
            : _darkTheme;

        return MaterialApp.router(
          title: 'Advocato',
          theme: light,
          darkTheme: dark,
          themeMode: settings.themeMode,
          routerConfig: router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: settings.largeText
                    ? TextScaler.linear(AppConstants.largeTextScaleFactor)
                    : null,
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}

