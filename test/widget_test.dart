import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:advocatoo/database/app_database.dart';
import 'package:advocatoo/main.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    AppDatabase.initForTest(NativeDatabase.memory());

    // Mock the flutter_local_notifications platform channel so
    // NotificationService.init() doesn't throw LateInitializationError.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      (call) async {
        if (call.method == 'initialize') return true;
        if (call.method == 'requestExactAlarmsPermission') return true;
        if (call.method == 'requestNotificationsPermission') return true;
        if (call.method == 'getNotificationAppLaunchDetails') return null;
        return null;
      },
    );

    // Mock local_auth channel so AppLockGate doesn't crash.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/local_auth'),
      (call) async => false,
    );
  });

  /// Wait for app to load (prefs + DynamicColorBuilder); avoid pumpAndSettle
  /// which can time out due to ongoing animations or font loading.
  Future<void> pumpUntilSettled(WidgetTester tester) async {
    await tester.pump(); // start frame
    await tester.pump(const Duration(milliseconds: 500));  // let DB.init() resolve
    await tester.pump(const Duration(seconds: 1));         // wait past 900ms splash delay
    await tester.pump(const Duration(seconds: 1));         // let GoRouter navigate to /
    await tester.pump(const Duration(milliseconds: 500));  // let page animations settle
  }

  /// Dispose app and pump so Drift stream cancel timer runs (avoids pending timer assertion).
  Future<void> disposeAndPump(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Advocato app loads and shows Home with Advocato title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    expect(find.text('Advocato'), findsOneWidget);
    await disposeAndPump(tester);
  });

  testWidgets('Bottom nav has 4 tabs: Home, Hearings, Activity, Menu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Hearings'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Menu'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('Tapping Menu tab opens hamburger panel', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    await tester.tap(find.text('Menu'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1)); // let flutter_animate timer complete

    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('Profile'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('Profile avatar is tappable on Home', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    final profileButton = find.byIcon(Icons.person);
    expect(profileButton, findsOneWidget);
    await tester.tap(profileButton);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Profile'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('Hamburger panel has Close and closes on backdrop tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    await tester.tap(find.text('Menu'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Dark Mode'), findsNothing);
    await disposeAndPump(tester);
  });

  // ── New tests ─────────────────────────────────────────────────────────────

  testWidgets('Tapping Hearings tab does not crash the app',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    await tester.tap(find.text('Hearings'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    // Just assert the nav bar label is still present (app didn't crash).
    // NavigationBar renders 2 text widgets for each label so use findsWidgets.
    expect(find.text('Hearings'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('Tapping Activity tab does not crash the app',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    await tester.tap(find.text('Activity'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Activity'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('FAB is present on initial Home tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpUntilSettled(tester);

    // FAB is present on the home screen (index 0).
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await disposeAndPump(tester);
  });
}

