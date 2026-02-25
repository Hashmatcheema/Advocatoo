import 'package:drift/drift.dart' hide Column, isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

void main() {
  setUp(() {
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  group('Case CRUD', () {
    test('insertCase returns valid id', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCase(CasesCompanion.insert(
        title: 'Test Case',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      expect(id, greaterThan(0));
    });

    test('getCaseById returns inserted case', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCase(CasesCompanion.insert(
        title: 'My Case',
        caseType: const Value('Civil'),
        status: const Value('Active'),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      final c = await db.getCaseById(id);
      expect(c, isNotNull);
      expect(c!.title, 'My Case');
      expect(c.caseType, 'Civil');
      expect(c.status, 'Active');
    });

    test('updateCase modifies fields', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCase(CasesCompanion.insert(
        title: 'Old Title',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      final c = await db.getCaseById(id);
      await db.updateCase(c!.copyWith(title: 'New Title', status: 'Closed'));
      final updated = await db.getCaseById(id);
      expect(updated!.title, 'New Title');
      expect(updated.status, 'Closed');
    });

    test('deleteCase removes case', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCase(CasesCompanion.insert(
        title: 'To Delete',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      final c = await db.getCaseById(id);
      expect(c, isNotNull);
      await db.deleteCase(c!);
      expect(await db.getCaseById(id), isNull);
    });

    test('deleteCase does not auto-delete hearings (no CASCADE)', () async {
      final db = AppDatabase.instance;
      final caseId = await db.insertCase(CasesCompanion.insert(
        title: 'No Cascade Test',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
      await db.insertHearing(HearingsCompanion.insert(
        caseId: caseId,
        hearingDate: '2026-05-01',
      ));
      expect((await db.getHearingsForCase(caseId)).length, 1);
      final c = await db.getCaseById(caseId);
      await db.deleteCase(c!);
      // Without CASCADE, hearings remain orphaned.
      expect((await db.getHearingsForCase(caseId)).length, 1);
    });
  });

  group('getCasesFiltered', () {
    Future<void> seedCases(AppDatabase db) async {
      final now = DateTime.now().toIso8601String();
      await db.insertCase(CasesCompanion.insert(
        title: 'Civil Case Alpha',
        caseType: const Value('Civil'),
        status: const Value('Active'),
        createdAt: now,
        updatedAt: now,
      ));
      await db.insertCase(CasesCompanion.insert(
        title: 'Criminal Case Beta',
        caseType: const Value('Criminal'),
        status: const Value('Active'),
        createdAt: now,
        updatedAt: now,
      ));
      await db.insertCase(CasesCompanion.insert(
        title: 'Family Case Gamma',
        caseType: const Value('Family'),
        status: const Value('Closed'),
        createdAt: now,
        updatedAt: now,
      ));
    }

    test('filter by search query (case-insensitive)', () async {
      final db = AppDatabase.instance;
      await seedCases(db);
      final results = await db.getCasesFiltered(searchQuery: 'alpha');
      expect(results.length, 1);
      expect(results.first.title, 'Civil Case Alpha');
    });

    test('filter by case type', () async {
      final db = AppDatabase.instance;
      await seedCases(db);
      final results = await db.getCasesFiltered(caseType: 'Criminal');
      expect(results.length, 1);
      expect(results.first.caseType, 'Criminal');
    });

    test('filter by status', () async {
      final db = AppDatabase.instance;
      await seedCases(db);
      final results = await db.getCasesFiltered(status: 'Closed');
      expect(results.length, 1);
      expect(results.first.title, 'Family Case Gamma');
    });

    test('combined search + type filter', () async {
      final db = AppDatabase.instance;
      await seedCases(db);
      final results = await db.getCasesFiltered(
        searchQuery: 'case',
        caseType: 'Civil',
      );
      expect(results.length, 1);
      expect(results.first.title, 'Civil Case Alpha');
    });

    test('no match returns empty list', () async {
      final db = AppDatabase.instance;
      await seedCases(db);
      final results = await db.getCasesFiltered(searchQuery: 'nonexistent');
      expect(results, isEmpty);
    });
  });
}
