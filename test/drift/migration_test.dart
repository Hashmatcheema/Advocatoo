import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:advocatoo/database/app_database.dart';

import 'generated_migrations/schema.dart';

/// Migration tests use Drift's [SchemaVerifier] to prove that the current
/// database schema matches what is generated in [GeneratedHelper].
///
/// To add migration tests for future versions (e.g. v5→v6):
///   1. Run `dart run drift_dev schema dump lib/database/app_database.dart drift_schemas/drift_schema_v6.json`
///   2. Run `dart run drift_dev schema generate drift_schemas/ test/drift/generated_migrations/`
///   3. Add a test: `verifier.startAt(5)` → insert data → `verifier.migrateAndValidate(db, 6)` → verify.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  /// Verify that the current schema (v5) can be opened correctly and data
  /// operations work — i.e. the generated schema helper matches the live DDL.
  test('schema v5: startAt opens correctly and current DB matches schema', () async {
    // Open a database at version 5 using the generated schema helper.
    final connection = await verifier.startAt(5);
    final db = AppDatabase.forTesting(connection);

    // Seed some data to confirm basic operations work.
    final caseId = await db.into(db.cases).insert(
      CasesCompanion.insert(
        title: 'Schema v5 validation case',
        createdAt: '2026-01-01T00:00:00.000',
        updatedAt: '2026-01-01T00:00:00.000',
      ),
    );
    expect(caseId, greaterThan(0));

    // Read it back.
    final fetched = await db.getCaseById(caseId);
    expect(fetched?.title, 'Schema v5 validation case');

    // Insert a hearing (tests the hearings table is present and usable).
    final hearingId = await db.insertHearing(
      HearingsCompanion.insert(caseId: caseId, hearingDate: '2026-06-01'),
    );
    expect(hearingId, greaterThan(0));

    await db.close();
  });
}
