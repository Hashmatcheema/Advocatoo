import 'package:advocatoo/app/settings/app_settings.dart';
import 'package:advocatoo/features/settings/app_lock_gate.dart';
import 'package:advocatoo/features/settings/app_lock_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAppLockService implements AppLockService {
  bool authenticateResult = true;
  int authenticateCallCount = 0;

  @override
  Future<bool> authenticate() async {
    authenticateCallCount++;
    return authenticateResult;
  }
}

class FakeAppSettingsNotifier extends AppSettingsNotifier {
  @override
  AppSettings build() => const AppSettings(appLockEnabled: true);
}

void main() {
  group('AppLockGate Tests', () {
    testWidgets('shows child widget if AppLock is disabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AppLockGate(
              child: const Text('Sensitive Data'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // By default AppSettings has appLockEnabled=false
      expect(find.text('Sensitive Data'), findsOneWidget);
      expect(find.text('App Locked'), findsNothing);
    });

    testWidgets('shows lock screen if AppLock is enabled and auth fails', (tester) async {
      final fakeService = FakeAppLockService();
      fakeService.authenticateResult = false; // Force auth failure

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appSettingsProvider.overrideWith(() => FakeAppSettingsNotifier()),
            appLockServiceProvider.overrideWithValue(fakeService),
          ],
          child: MaterialApp(
            home: AppLockGate(
              child: const Text('Sensitive Data'),
            ),
          ),
        ),
      );

      await tester.pump(); // Start building
      
      // Wait for async auth to complete
      await tester.pumpAndSettle();

      expect(find.text('Sensitive Data'), findsNothing);
      expect(find.text('App Locked'), findsOneWidget);
      expect(fakeService.authenticateCallCount, 1);
    });

    testWidgets('shows child widget if AppLock is enabled and auth succeeds', (tester) async {
      final fakeService = FakeAppLockService();
      fakeService.authenticateResult = true; // Force auth success

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appSettingsProvider.overrideWith(() => FakeAppSettingsNotifier()),
            appLockServiceProvider.overrideWithValue(fakeService),
          ],
          child: MaterialApp(
            home: AppLockGate(
              child: const Text('Sensitive Data'),
            ),
          ),
        ),
      );

      await tester.pump(); // Start building
      
      // Wait for async auth to complete
      await tester.pumpAndSettle();

      expect(find.text('Sensitive Data'), findsOneWidget);
      expect(find.text('App Locked'), findsNothing);
      expect(fakeService.authenticateCallCount, 1);
    });
  });
}
