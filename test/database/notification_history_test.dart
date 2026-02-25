import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

void main() {
  setUp(() {
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  group('NotificationHistory', () {
    test('insertNotificationHistory returns valid id', () async {
      final db = AppDatabase.instance;
      final id = await db.insertNotificationHistory(
        NotificationHistoryCompanion.insert(
          triggeredAt: '2026-02-01T07:00:00.000',
          summary: '3 hearings today',
        ),
      );
      expect(id, greaterThan(0));
    });

    test('getNotificationHistory returns entries in descending triggeredAt order', () async {
      final db = AppDatabase.instance;
      await db.insertNotificationHistory(NotificationHistoryCompanion.insert(
        triggeredAt: '2026-02-01T07:00:00.000',
        summary: 'Day 1',
      ));
      await db.insertNotificationHistory(NotificationHistoryCompanion.insert(
        triggeredAt: '2026-02-02T07:00:00.000',
        summary: 'Day 2',
      ));
      await db.insertNotificationHistory(NotificationHistoryCompanion.insert(
        triggeredAt: '2026-02-03T07:00:00.000',
        summary: 'Day 3',
      ));

      final history = await db.getNotificationHistory();

      expect(history.length, 3);
      expect(history.first.summary, 'Day 3');
      expect(history.last.summary, 'Day 1');
    });

    test('getNotificationHistory respects limit', () async {
      final db = AppDatabase.instance;
      for (int i = 1; i <= 10; i++) {
        await db.insertNotificationHistory(NotificationHistoryCompanion.insert(
          triggeredAt: '2026-02-${i.toString().padLeft(2, '0')}T07:00:00.000',
          summary: 'Batch $i',
        ));
      }

      final limited = await db.getNotificationHistory(limit: 3);
      expect(limited.length, 3);
    });
  });
}
