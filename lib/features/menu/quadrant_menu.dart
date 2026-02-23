import 'dart:ui';

import 'package:flutter/material.dart';

/// Shows the quadrant menu as a bottom-left overlay with scrim, blur, and slide+fade.
Future<void> showQuadrantMenu({
  required BuildContext context,
  required Widget child,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Menu',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: SafeArea(
          minimum: const EdgeInsets.all(12),
          child: Builder(
            builder: (context) {
              final size = MediaQuery.sizeOf(context);
              final width = size.width * 0.62;
              final height = size.height * 0.55;
              return SizedBox(
                width: width,
                height: height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(28),
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Material(
                      elevation: 16,
                      color: Theme.of(context).colorScheme.surface,
                      child: child,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.10, 0.10),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Content for the quadrant menu: title, quick toggles, nav items, footer.
class QuadrantMenuContent extends StatelessWidget {
  const QuadrantMenuContent({
    super.key,
    required this.onClose,
    required this.themeMode,
    required this.largeTextMode,
    required this.onThemeModeChanged,
    required this.onLargeTextChanged,
    required this.onProfile,
    required this.onCourtsManager,
    required this.onSettings,
    required this.onFaqs,
    required this.onAbout,
    required this.onSendFeedback,
    this.appVersion = '1.0.0',
  });

  final VoidCallback onClose;
  final ThemeMode themeMode;
  final bool largeTextMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onLargeTextChanged;
  final VoidCallback onProfile;
  final VoidCallback onCourtsManager;
  final VoidCallback onSettings;
  final VoidCallback onFaqs;
  final VoidCallback onAbout;
  final VoidCallback onSendFeedback;
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                tooltip: 'Close menu',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Quick toggles
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            selected: {themeMode},
            onSelectionChanged: (Set<ThemeMode> selected) {
              if (selected.isNotEmpty) {
                onThemeModeChanged(selected.first);
              }
            },
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.text_increase),
          title: const Text('Large Text'),
          value: largeTextMode,
          onChanged: onLargeTextChanged,
        ),
        const Divider(height: 24),
        // Navigation items
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Profile'),
          onTap: onProfile,
        ),
        ListTile(
          leading: const Icon(Icons.account_balance_outlined),
          title: const Text('Courts Manager'),
          onTap: onCourtsManager,
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: onSettings,
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('FAQs'),
          onTap: onFaqs,
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: onAbout,
        ),
        const Divider(height: 24),
        // Footer
        ListTile(
          leading: const Icon(Icons.feedback_outlined),
          title: const Text('Send feedback'),
          onTap: onSendFeedback,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'Version $appVersion',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        ],
      ),
    );
  }
}
