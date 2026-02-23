import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'features/activity/activity_screen.dart';
import 'features/hearings/hearings_screen.dart';
import 'features/home/home_screen.dart';
import 'features/menu/menu_placeholder_screen.dart';
import 'features/menu/quadrant_menu.dart';
import 'widgets/animated_add_case_fab.dart';

/// Bottom nav shell with 4 tabs; Menu tab opens hamburger panel from bottom-left.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.themeMode,
    required this.largeTextMode,
    required this.onThemeModeChanged,
    required this.onLargeTextChanged,
    required this.onNavigateToProfile,
    required this.onNavigateToCourtsManager,
    required this.onNavigateToSettings,
    required this.onNavigateToFaqs,
    required this.onNavigateToAbout,
    required this.onNavigateToSendFeedback,
    required this.onAddCase,
    required this.onDashboardTap,
  });

  final ThemeMode themeMode;
  final bool largeTextMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onLargeTextChanged;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToCourtsManager;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onNavigateToFaqs;
  final VoidCallback onNavigateToAbout;
  final VoidCallback onNavigateToSendFeedback;
  final VoidCallback onAddCase;
  final VoidCallback onDashboardTap;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  bool _menuOpen = false;

  void _onTabTapped(int index) {
    if (index == 3) {
      _openQuadrantMenu();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _openQuadrantMenu() {
    setState(() => _menuOpen = true);
    showQuadrantMenu(
      context: context,
      child: QuadrantMenuContent(
        onClose: () => Navigator.of(context).pop(),
        themeMode: widget.themeMode,
        largeTextMode: widget.largeTextMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        onLargeTextChanged: widget.onLargeTextChanged,
        onProfile: () {
          Navigator.of(context).pop();
          widget.onNavigateToProfile();
        },
        onCourtsManager: () {
          Navigator.of(context).pop();
          widget.onNavigateToCourtsManager();
        },
        onSettings: () {
          Navigator.of(context).pop();
          widget.onNavigateToSettings();
        },
        onFaqs: () {
          Navigator.of(context).pop();
          widget.onNavigateToFaqs();
        },
        onAbout: () {
          Navigator.of(context).pop();
          widget.onNavigateToAbout();
        },
        onSendFeedback: () {
          Navigator.of(context).pop();
          widget.onNavigateToSendFeedback();
        },
        appVersion: '1.0.0',
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _menuOpen = false;
          _currentIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final largeText = widget.largeTextMode;
    return Scaffold(
      body: Stack(
        children: [
          PageTransitionSwitcher(
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
              key: ValueKey<int>(_currentIndex),
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  HomeScreen(
                    onProfileTap: widget.onNavigateToProfile,
                    onDashboardTap: widget.onDashboardTap,
                    onAddCase: widget.onAddCase,
                    largeText: largeText,
                  ),
                  HearingsScreen(largeText: largeText),
                  ActivityScreen(largeText: largeText),
                  MenuPlaceholderScreen(largeText: largeText),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? AnimatedAddCaseFab(onPressed: widget.onAddCase)
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _menuOpen ? 3 : _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Hearings',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            selectedIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
