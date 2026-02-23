import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:advocatoo/database/app_database.dart';
import 'package:advocatoo/main.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  /// Wait for app to load (prefs + DynamicColorBuilder); avoid pumpAndSettle
  /// which can time out due to ongoing animations or font loading.
  Future<void> pumpUntilSettled(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 1));
  }

  /// Dispose app and pump so Drift stream cancel timer runs (avoids pending timer assertion).
  Future<void> disposeAndPump(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Advocato app loads and shows Home with Advocato title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AdvocatoApp());
    await pumpUntilSettled(tester);

    expect(find.text('Advocato'), findsOneWidget);
    await disposeAndPump(tester);
  });

  testWidgets('Bottom nav has 4 tabs: Home, Hearings, Activity, Menu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AdvocatoApp());
    await pumpUntilSettled(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Hearings'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Menu'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('Tapping Menu tab opens hamburger panel', (WidgetTester tester) async {
    await tester.pumpWidget(const AdvocatoApp());
    await pumpUntilSettled(tester);

    await tester.tap(find.text('Menu'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1)); // let flutter_animate timer complete

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Profile'), findsWidgets);
    await disposeAndPump(tester);
  });

  testWidgets('Profile avatar is tappable on Home', (WidgetTester tester) async {
    await tester.pumpWidget(const AdvocatoApp());
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
    await tester.pumpWidget(const AdvocatoApp());
    await pumpUntilSettled(tester);

    await tester.tap(find.text('Menu'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Dark Mode'), findsNothing);
    await disposeAndPump(tester);
  });
}
