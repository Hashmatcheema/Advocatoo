import 'package:advocatoo/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:advocatoo/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

/// Helper: pump with explicit delays instead of bare pumpAndSettle,
/// which can timeout when animations / Lottie splash are running.
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  testWidgets('Smoke: app launches and shows AppShell with 4 tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpApp(tester);

    expect(find.text('Advocato'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Hearings'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Menu'), findsWidgets);
  });

  testWidgets('Case flow: tap FAB → navigate to Add Case screen → back', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpApp(tester);

    // Tap the FAB to add a case.
    final fab = find.byIcon(Icons.add);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    // Should be on the Add Case screen.
    expect(find.text('Add Case'), findsWidgets);
    expect(find.byType(TextFormField).first, findsOneWidget);

    // Navigate back.
    await tester.pageBack();
    await pumpApp(tester);

    // Back on Home — FAB should be visible again.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Hearings tab smoke: shows calendar', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpApp(tester);

    await tester.tap(find.text('Hearings'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(TableCalendar<dynamic>), findsOneWidget);
  });

  testWidgets('Activity tab smoke: renders without crash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdvocatoApp()));
    await pumpApp(tester);

    await tester.tap(find.text('Activity'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    // No assertion beyond "did not crash" — Activity tab label is still in nav.
    expect(find.text('Activity'), findsOneWidget);
  });
}

