import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SRD 5.7: Navy/blue-grey #1E3A5F primary; consistent radii and typography.
const Color _kAdvocatoSeed = Color(0xFF1E3A5F);

/// Builds light theme using flex_color_scheme and Inter via google_fonts.
ThemeData buildAdvocatoLightTheme() {
  final base = FlexThemeData.light(
    scheme: FlexScheme.materialBaseline,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _kAdvocatoSeed,
      brightness: Brightness.light,
      primary: _kAdvocatoSeed,
    ),
    subThemesData: const FlexSubThemesData(
      defaultRadius: 16,
      elevatedButtonRadius: 16,
      inputDecoratorRadius: 16,
      cardRadius: 16,
      dialogRadius: 18,
    ),
  );
  return _applyTypography(base);
}

/// Builds dark theme; SRD: #121212, #1E1E1E, same accent.
ThemeData buildAdvocatoDarkTheme() {
  final base = FlexThemeData.dark(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _kAdvocatoSeed,
      brightness: Brightness.dark,
      primary: _kAdvocatoSeed,
      surface: const Color(0xFF121212),
    ),
    subThemesData: const FlexSubThemesData(
      defaultRadius: 16,
      cardRadius: 16,
      inputDecoratorRadius: 16,
    ),
  );
  final withSurface = base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
  return _applyTypography(withSurface);
}

ThemeData _applyTypography(ThemeData base) {
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
  );
}
