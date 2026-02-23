import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Hamburger panel sliding in from bottom-left (≈50% width, 55% height, rounded top-right).
/// SRD: Profile, Courts Manager, Settings, FAQs, About, Send Feedback, Dark/Large Text toggles.
class MenuPanel extends StatelessWidget {
  const MenuPanel({
    super.key,
    required this.onClose,
    required this.onProfile,
    required this.onCourtsManager,
    required this.onSettings,
    required this.onFaqs,
    required this.onAbout,
    required this.onSendFeedback,
    required this.themeMode,
    required this.largeTextMode,
    required this.onThemeModeChanged,
    required this.onLargeTextChanged,
  });

  final VoidCallback onClose;
  final VoidCallback onProfile;
  final VoidCallback onCourtsManager;
  final VoidCallback onSettings;
  final VoidCallback onFaqs;
  final VoidCallback onAbout;
  final VoidCallback onSendFeedback;
  final ThemeMode themeMode;
  final bool largeTextMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onLargeTextChanged;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final panelWidth = screenSize.width * 0.5;
    final panelHeight = screenSize.height * 0.55;

    return Stack(
      children: [
        // Translucent backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black54),
          ),
        ),
        // Panel from bottom-right with rounded top-left (slide + fade)
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: panelWidth,
            height: panelHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        onTap: onProfile,
                      ),
                      _MenuItem(
                        icon: Icons.account_balance_outlined,
                        label: 'Courts Manager',
                        onTap: onCourtsManager,
                      ),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: onSettings,
                      ),
                      _MenuItem(
                        icon: Icons.help_outline,
                        label: 'FAQs',
                        onTap: onFaqs,
                      ),
                      _MenuItem(
                        icon: Icons.info_outline,
                        label: 'About',
                        onTap: onAbout,
                      ),
                      _MenuItem(
                        icon: Icons.feedback_outlined,
                        label: 'Send Feedback',
                        onTap: onSendFeedback,
                      ),
                      const Divider(height: 24),
                      ListTile(
                        leading: const Icon(Icons.palette_outlined),
                        title: const Text('Theme'),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
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
                      ),
                      SwitchListTile(
                        secondary: const Icon(Icons.text_increase),
                        title: const Text('Large Text'),
                        value: largeTextMode,
                        onChanged: onLargeTextChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .slideX(begin: 0.15, end: 0, duration: 220.ms, curve: Curves.easeOut)
            .fadeIn(duration: 200.ms),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
}
