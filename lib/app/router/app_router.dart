import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../settings/app_settings.dart';
import '../../app_shell.dart';
import '../../splash_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/courts/courts_manager_screen.dart';
import '../../features/faqs/faqs_screen.dart';
import '../../features/feedback/feedback_screen.dart';
import '../../features/case/add_edit_case_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';

import '../../features/home/home_screen.dart';
import '../../features/hearings/hearings_screen.dart';
import '../../features/activity/activity_screen.dart';
import '../../features/menu/menu_placeholder_screen.dart';
import '../../widgets/dashboard_sheet.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(
          onComplete: (mode, largeText, reminders) {
            ref.read(appSettingsProvider.notifier).setFromSplash(mode, largeText, reminders);
            context.go('/');
          },
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AppShell(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (context, state) {
                      final ltm = ref.watch(appSettingsProvider.select((s) => s.largeText));
                      return HomeScreen(
                        onProfileTap: () => context.push('/profile'),
                        onDashboardTap: () => showDashboardSheet(context),
                        onAddCase: () => context.push('/add-case'),
                        largeText: ltm,
                      );
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/hearings',
                    builder: (context, state) {
                      final ltm = ref.watch(appSettingsProvider.select((s) => s.largeText));
                      return HearingsScreen(largeText: ltm);
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/activity',
                    builder: (context, state) {
                      final ltm = ref.watch(appSettingsProvider.select((s) => s.largeText));
                      return ActivityScreen(largeText: ltm);
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/menu',
                    builder: (context, state) {
                      final ltm = ref.watch(appSettingsProvider.select((s) => s.largeText));
                      return MenuPlaceholderScreen(largeText: ltm);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/courts',
            builder: (context, state) => const CourtsManagerScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/faqs',
            builder: (context, state) => const FaqsScreen(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: '/feedback',
            builder: (context, state) => const FeedbackScreen(),
          ),
          GoRoute(
            path: '/add-case',
            builder: (context, state) => const AddEditCaseScreen(),
          ),
        ],
      )
    ],
  );
});
