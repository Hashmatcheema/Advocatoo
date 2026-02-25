import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'features/menu/quadrant_menu.dart';
import 'widgets/animated_add_case_fab.dart';

/// Bottom nav shell with 4 tabs managed by go_router StatefulShellRoute.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _menuOpen = false;

  void _onTabTapped(int index) {
    if (index == 3) {
      _openQuadrantMenu();
      return;
    }
    // Always navigate to the tab's root so Home/Hearings/Activity reset when switching.
    widget.navigationShell.goBranch(index, initialLocation: true);
  }

  void _openQuadrantMenu() {
    setState(() => _menuOpen = true);
    // Menu tab in go_router branch 3 is just a placeholder visually,
    // we don't actually goBranch(3) here to keep the background screen active.
    
    // We pass the root context to pop so that we don't run into deactivated widget issues.
    showMenuPanel(
      context: context,
      child: Builder(builder: (dialogContext) {
        return MenuPanelContent(
          onClose: () => Navigator.of(dialogContext).pop(),
          onProfile: () => Navigator.of(dialogContext).pop('/profile'),
          onCourtsManager: () => Navigator.of(dialogContext).pop('/courts'),
          onSettings: () => Navigator.of(dialogContext).pop('/settings'),
          onFaqs: () => Navigator.of(dialogContext).pop('/faqs'),
          onAbout: () => Navigator.of(dialogContext).pop('/about'),
          onSendFeedback: () => Navigator.of(dialogContext).pop('/feedback'),
          appVersion: '1.0.0',
        );
      }),
    ).then((routePath) {
      if (mounted) {
        setState(() {
          _menuOpen = false;
        });
        if (routePath != null && routePath.isNotEmpty) {
          // Delaying slightly to allow the dialog pop to finalize its animation,
          // though not strictly necessary, it prevents hero/routing race conditions.
          Future.microtask(() {
            if (mounted) context.push(routePath);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // Status-bar background: black in light mode, white in dark mode.
    // Icon brightness is automatically inverted to remain legible.
    final statusBarColor = isDark ? Colors.white : Colors.black;

    final statusBarStyle = isDark
        ? SystemUiOverlayStyle.dark    // dark icons on white background
        : SystemUiOverlayStyle.light;  // light icons on black background

    final overlayStyle = statusBarStyle.copyWith(
      statusBarColor: statusBarColor,
      // Keep the bottom system nav bar transparent so the app's
      // bottom NavigationBar blends in naturally.
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        body: widget.navigationShell,
        floatingActionButton: widget.navigationShell.currentIndex == 0
            ? AnimatedAddCaseFab(onPressed: () => context.push('/add-case'))
            : null,
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          selectedIndex: _menuOpen ? 3 : widget.navigationShell.currentIndex,
          onDestinationSelected: _onTabTapped,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: _buildAnimatedIcon(context, Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined),
              selectedIcon: _buildAnimatedIcon(context, Icons.calendar_today),
              label: 'Hearings',
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_outlined),
              selectedIcon: _buildAnimatedIcon(context, Icons.notifications),
              label: 'Activity',
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu),
              selectedIcon: _buildAnimatedIcon(context, Icons.menu),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    )
    .animate()
    .scale(duration: 300.ms, curve: Curves.easeOutBack, begin: const Offset(0.7, 0.7))
    .fade(duration: 200.ms);
  }
}
