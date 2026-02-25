import 'package:drift/drift.dart' hide Column, isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

void main() {
  setUp(() {
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  group('Court CRUD', () {
    test('insertCourt returns valid id', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCourt(CourtsCompanion.insert(
        name: 'Lahore High Court',
        hierarchy: 'High Court',
        city: const Value('Lahore'),
      ));
      expect(id, greaterThan(0));
    });

    test('getAllCourts returns inserted courts', () async {
      final db = AppDatabase.instance;
      await db.insertCourt(CourtsCompanion.insert(
        name: 'Court A',
        hierarchy: 'District Court',
      ));
      await db.insertCourt(CourtsCompanion.insert(
        name: 'Court B',
        hierarchy: 'High Court',
      ));
      final courts = await db.getAllCourts();
      expect(courts.length, 2);
    });

    test('updateCourt modifies fields', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCourt(CourtsCompanion.insert(
        name: 'Old Name',
        hierarchy: 'District Court',
      ));
      final court = await db.getCourtById(id);
      expect(court, isNotNull);
      await db.updateCourt(court!.copyWith(name: 'New Name'));
      final updated = await db.getCourtById(id);
      expect(updated!.name, 'New Name');
    });

    test('deleteCourt removes court', () async {
      final db = AppDatabase.instance;
      final id = await db.insertCourt(CourtsCompanion.insert(
        name: 'To Delete',
        hierarchy: 'Supreme Court',
      ));
      final court = await db.getCourtById(id);
      await db.deleteCourt(court!);
      expect(await db.getCourtById(id), isNull);
    });
  });

  group('countCasesByCourtId', () {
    test('returns correct count', () async {
      final db = AppDatabase.instance;
      final courtId = await db.insertCourt(CourtsCompanion.insert(
        name: 'Test Court',
        hierarchy: 'District Court',
      ));
      final now = DateTime.now().toIso8601String();
      await db.insertCase(CasesCompanion.insert(
        title: 'Case A',
        courtId: Value(courtId),
        createdAt: now,
        updatedAt: now,
      ));
      await db.insertCase(CasesCompanion.insert(
        title: 'Case B',
        courtId: Value(courtId),
        createdAt: now,
        updatedAt: now,
      ));
      final count = await db.countCasesByCourtId(courtId);
      expect(count, 2);
    });

    test('returns 0 for court with no cases', () async {
      final db = AppDatabase.instance;
      final courtId = await db.insertCourt(CourtsCompanion.insert(
        name: 'Empty Court',
        hierarchy: 'High Court',
      ));
      final count = await db.countCasesByCourtId(courtId);
      expect(count, 0);
    });
  });

  group('getCourtIdsByHierarchy', () {
    test('returns courts matching hierarchy', () async {
      final db = AppDatabase.instance;
      final id1 = await db.insertCourt(CourtsCompanion.insert(
        name: 'Court D1',
        hierarchy: 'District Court',
      ));
      await db.insertCourt(CourtsCompanion.insert(
        name: 'Court H1',
        hierarchy: 'High Court',
      ));
      final id3 = await db.insertCourt(CourtsCompanion.insert(
        name: 'Court D2',
        hierarchy: 'District Court',
      ));
      final ids = await db.getCourtIdsByHierarchy('District Court');
      expect(ids, containsAll([id1, id3]));
      expect(ids.length, 2);
    });
  });
}
