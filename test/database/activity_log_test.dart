import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

void main() {
  setUp(() {
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  group('ActivityLog', () {
    test('insertActivityLog returns valid id', () async {
      final db = AppDatabase.instance;
      final id = await db.insertActivityLog(ActivityLogCompanion.insert(
        type: 'case_added',
        title: 'Added case Alpha',
        createdAt: '2026-01-01T10:00:00.000',
      ));
      expect(id, greaterThan(0));
    });

    test('getRecentActivityLog returns inserted entries in descending order', () async {
      final db = AppDatabase.instance;
      await db.insertActivityLog(ActivityLogCompanion.insert(
        type: 'case_added',
        title: 'First entry',
        createdAt: '2026-01-01T08:00:00.000',
      ));
      await db.insertActivityLog(ActivityLogCompanion.insert(
        type: 'hearing_added',
        title: 'Second entry',
        createdAt: '2026-01-01T09:00:00.000',
      ));
      await db.insertActivityLog(ActivityLogCompanion.insert(
        type: 'document_uploaded',
        title: 'Third entry',
        createdAt: '2026-01-01T10:00:00.000',
      ));

      final log = await db.getRecentActivityLog();

      expect(log.length, 3);
      // Should be descending by createdAt.
      expect(log.first.title, 'Third entry');
      expect(log.last.title, 'First entry');
    });

    test('getRecentActivityLog respects limit parameter', () async {
      final db = AppDatabase.instance;
      for (int i = 1; i <= 5; i++) {
        await db.insertActivityLog(ActivityLogCompanion.insert(
          type: 'case_added',
          title: 'Entry $i',
          createdAt: '2026-01-0${i}T00:00:00.000',
        ));
      }

      final limited = await db.getRecentActivityLog(limit: 2);
      expect(limited.length, 2);
    });

    test('getRecentActivityLog stores and retrieves caseId', () async {
      final db = AppDatabase.instance;
      // Insert a case first so the foreign key is valid.
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'My Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      // The companion's caseId is a nullable Value<int?> field.
      await db.insertActivityLog(ActivityLogCompanion(
        type: const Value('case_added'),
        caseId: Value(caseId),
        title: const Value('My Case added'),
        createdAt: Value(DateTime.now().toIso8601String()),
      ));

      final log = await db.getRecentActivityLog();
      expect(log.first.caseId, caseId);
    });
  });
}
