import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns an ISO date string shifted [days] from today.
String _relativeDate(int days) {
  final d = DateTime.now().add(Duration(days: days));
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    // SQLite disables FK enforcement by default; enable it so CASCADE
    // delete constraints (e.g. hearings.caseId onDelete: cascade) work.
    AppDatabase.initForTest(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
      ),
    );
  });

  // ── original tests ────────────────────────────────────────────────────────

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
    // Use 3 different cases so we don't violate UNIQUE(case_id, hearing_date).
    for (final title in ['Case A', 'Case B', 'Case C']) {
      final id = await db.insertCase(CasesCompanion.insert(
        title: title,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(
        caseId: id,
        hearingDate: '2026-04-01',
      ));
    }
    final countByDay = await db.getHearingCountByDay();
    final apr1 = DateTime(2026, 4, 1);
    expect(countByDay[apr1], 3);
  });

  // ── new: getUpcomingHearings ──────────────────────────────────────────────

  group('getUpcomingHearings', () {
    test('includes today and future, excludes past', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));

      final past = _relativeDate(-5);
      final today = _relativeDate(0);
      final future = _relativeDate(10);

      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: past));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: today));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: future));

      final upcoming = await db.getUpcomingHearings();
      final dates = upcoming.map((h) => h.hearingDate).toList();

      expect(dates, contains(today));
      expect(dates, contains(future));
      expect(dates, isNot(contains(past)));
    });

    test('returns empty when no upcoming hearings', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      // only past hearings
      await db.insertHearing(HearingsCompanion.insert(
        caseId: caseId,
        hearingDate: _relativeDate(-3),
      ));
      expect(await db.getUpcomingHearings(), isEmpty);
    });
  });

  // ── new: getOverdueHearings ───────────────────────────────────────────────

  group('getOverdueHearings', () {
    test('past hearing with no outcome is overdue', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(
        caseId: caseId,
        hearingDate: _relativeDate(-7),
        // no outcome set
      ));
      final overdue = await db.getOverdueHearings();
      expect(overdue.length, 1);
    });

    test('past hearing WITH outcome is not overdue', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(
        caseId: caseId,
        hearingDate: _relativeDate(-7),
        outcome: const Value('Adjourned'),
      ));
      expect(await db.getOverdueHearings(), isEmpty);
    });

    test('future hearing is not overdue even without outcome', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(
        caseId: caseId,
        hearingDate: _relativeDate(5),
      ));
      expect(await db.getOverdueHearings(), isEmpty);
    });
  });

  // ── new: getHearingsFromUntil ─────────────────────────────────────────────

  group('getHearingsFromUntil', () {
    test('returns hearings within inclusive date range', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));

      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-06-01'));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-06-15'));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-06-30'));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-07-10'));

      final range = await db.getHearingsFromUntil('2026-06-01', '2026-06-30');
      expect(range.length, 3);
      expect(range.map((h) => h.hearingDate), contains('2026-06-15'));
    });

    test('returns empty when no hearings in range', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-08-01'));
      final range = await db.getHearingsFromUntil('2026-06-01', '2026-06-30');
      expect(range, isEmpty);
    });
  });

  // ── new: CASCADE delete ───────────────────────────────────────────────────

  group('Hearings CASCADE when case deleted', () {
    test('deleting a case deletes its hearings (onDelete: cascade)', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'Cascade Test',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-09-01'));
      await db.insertHearing(HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-09-02'));
      expect((await db.getHearingsForCase(caseId)).length, 2);

      final c = await db.getCaseById(caseId);
      await db.deleteCase(c!);

      // Hearings table uses onDelete:cascade, so rows must be gone.
      expect((await db.getHearingsForCase(caseId)).length, 0);
    });
  });
}

