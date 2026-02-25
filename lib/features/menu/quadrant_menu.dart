import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/settings/app_settings.dart';
import '../../services/profile_service.dart';

/// Shows the menu panel as a right-side overlay (half screen width),
/// with glassmorphism, profile header, and staggered entrance animations.
/// Closes on outside tap (barrier) or the close button.
Future<String?> showMenuPanel({
  required BuildContext context,
  required Widget child,
}) {
  return showGeneralDialog<String>(
    context: context,
    barrierLabel: 'Menu',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      FocusManager.instance.primaryFocus?.unfocus();

      return Align(
        alignment: Alignment.centerRight,
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () {
              Navigator.of(context).pop(null);
            },
          },
          child: FocusScope(
            autofocus: true,
            child: SafeArea(
          child: Builder(
            builder: (context) {
              final size = MediaQuery.sizeOf(context);
              final width = math.min(size.width * 0.75, 480.0);
              return SizedBox(
                width: width,
                height: size.height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withAlpha(230),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 24,
                            offset: const Offset(-4, 0),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
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

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved,
          child: child,
        ),
      );
    },
  );
}

/// Content for the menu panel: profile header, quick toggles, nav items, footer.
/// Uses ConsumerStatefulWidget so toggle changes (theme, large text) update in real-time.
class MenuPanelContent extends ConsumerStatefulWidget {
  const MenuPanelContent({
    super.key,
    required this.onClose,
    required this.onProfile,
    required this.onCourtsManager,
    required this.onSettings,
    required this.onFaqs,
    required this.onAbout,
    required this.onSendFeedback,
    this.appVersion = '1.0.0',
  });

  final VoidCallback onClose;
  final VoidCallback onProfile;
  final VoidCallback onCourtsManager;
  final VoidCallback onSettings;
  final VoidCallback onFaqs;
  final VoidCallback onAbout;
  final VoidCallback onSendFeedback;
  final String appVersion;

  @override
  ConsumerState<MenuPanelContent> createState() => _MenuPanelContentState();
}

class _MenuPanelContentState extends ConsumerState<MenuPanelContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  String _profileName = '';
  String _profileBarNumber = '';

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.instance.getProfile();
    if (mounted) {
      setState(() {
        _profileName = profile.name.isEmpty ? 'Advocate' : profile.name;
        _profileBarNumber = profile.barNumber;
      });
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  /// Creates a stagger interval for the [index]-th item.
  Animation<double> _stagger(int index) {
    final begin = (index * 0.06).clamp(0.0, 0.7);
    final end = (begin + 0.4).clamp(begin, 1.0);
    return CurvedAnimation(
      parent: _staggerController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  Widget _staggeredItem(int index, Widget child) {
    final anim = _stagger(index);
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(12 * (1 - anim.value), 0),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read settings reactively so toggles update immediately.
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    int idx = 0;

    return Column(
      children: [
        // Profile header.
        _staggeredItem(
          idx++,
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 8, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withAlpha(120),
                  colorScheme.surface.withAlpha(60),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    _profileName.isNotEmpty ? _profileName[0].toUpperCase() : 'A',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profileName,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_profileBarNumber.isNotEmpty)
                        Text(
                          _profileBarNumber,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  tooltip: 'Close menu',
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ),

        Divider(height: 1, color: colorScheme.outlineVariant.withAlpha(80)),

        // Theme selector (vertical layout).
        _staggeredItem(
          idx++,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                  child: Text(
                    'Theme',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  label: 'Light Mode',
                  isSelected: settings.themeMode == ThemeMode.light,
                  onTap: () => notifier.setThemeMode(ThemeMode.light),
                ),
                const SizedBox(height: 4),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark Mode',
                  isSelected: settings.themeMode == ThemeMode.dark,
                  onTap: () => notifier.setThemeMode(ThemeMode.dark),
                ),
                const SizedBox(height: 4),
                _ThemeOption(
                  icon: Icons.brightness_auto_rounded,
                  label: 'System Auto',
                  isSelected: settings.themeMode == ThemeMode.system,
                  onTap: () => notifier.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
        ),

        _staggeredItem(
          idx++,
          SwitchListTile(
            secondary: Icon(Icons.text_increase_rounded, color: colorScheme.primary, size: 20),
            title: const Text('Large Text'),
            value: settings.largeText,
            onChanged: (enabled) => notifier.setLargeText(enabled),
            dense: true,
          ),
        ),

        Divider(height: 8, indent: 16, endIndent: 16, color: colorScheme.outlineVariant.withAlpha(60)),

        // Navigation items.
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _staggeredItem(idx++, _menuTile(Icons.person_rounded, 'Profile', widget.onProfile, colorScheme)),
                _staggeredItem(idx++, _menuTile(Icons.account_balance_rounded, 'Courts', widget.onCourtsManager, colorScheme)),
                _staggeredItem(idx++, _menuTile(Icons.settings_rounded, 'Settings', widget.onSettings, colorScheme)),
                _staggeredItem(idx++, _menuTile(Icons.help_rounded, 'FAQs', widget.onFaqs, colorScheme)),
                _staggeredItem(idx++, _menuTile(Icons.info_rounded, 'About', widget.onAbout, colorScheme)),

                Divider(height: 8, indent: 16, endIndent: 16, color: colorScheme.outlineVariant.withAlpha(60)),

                _staggeredItem(idx++, _menuTile(Icons.feedback_rounded, 'Feedback', widget.onSendFeedback, colorScheme)),
              ],
            ),
          ),
        ),

        // Footer.
        _staggeredItem(
          idx++,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              'v${widget.appVersion}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(140),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuTile(IconData icon, String label, VoidCallback onTap, ColorScheme cs) {
    return ListTile(
      leading: Icon(icon, color: cs.primary, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : colorScheme.outlineVariant.withAlpha(50),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Icon(Icons.check_circle_rounded, size: 18, color: colorScheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
