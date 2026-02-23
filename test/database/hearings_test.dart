import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

void main() {
  setUp(() {
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  test('insert case then insert hearing', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test Case',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    final hearingId = await db.insertHearing(HearingsCompanion.insert(
      caseId: caseId,
      hearingDate: '2026-03-01',
      hearingTime: const Value('09:30'),
      purpose: const Value('Evidence'),
    ));
    expect(hearingId, greaterThan(0));
    final list = await db.getHearingsForCase(caseId);
    expect(list.length, 1);
    expect(list.first.purpose, 'Evidence');
    expect(list.first.hearingDate, '2026-03-01');
  });

  test('hasHearingOnDate returns true when hearing exists', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    await db.insertHearing(HearingsCompanion.insert(
      caseId: caseId,
      hearingDate: '2026-03-15',
    ));
    final has = await db.hasHearingOnDate(caseId, '2026-03-15');
    expect(has, true);
    final hasOther = await db.hasHearingOnDate(caseId, '2026-03-16');
    expect(hasOther, false);
  });

  test('hasHearingOnDate with excludeHearingId allows same date when editing', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    final hearingId = await db.insertHearing(HearingsCompanion.insert(
      caseId: caseId,
      hearingDate: '2026-03-20',
    ));
    final hasExcluding = await db.hasHearingOnDate(
      caseId,
      '2026-03-20',
      excludeHearingId: hearingId,
    );
    expect(hasExcluding, false);
  });

  test('getHearingCountByDay returns correct counts', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    await db.insertHearing(HearingsCompanion.insert(
      caseId: caseId,
      hearingDate: '2026-04-01',
    ));
    await db.insertHearing(HearingsCompanion.insert(
      caseId: caseId,
      hearingDate: '2026-04-01',
    ));
    final caseId2 = await db.insertCase(CasesCompanion.insert(
      title: 'Test 2',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    await db.insertHearing(HearingsCompanion.insert(
      caseId: caseId2,
      hearingDate: '2026-04-01',
    ));
    final countByDay = await db.getHearingCountByDay();
    final apr1 = DateTime(2026, 4, 1);
    expect(countByDay[apr1], 3);
  });
}
