import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'app_database.g.dart';

class Courts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get hierarchy => text()(); // District/High/Supreme
  TextColumn get city => text().nullable()();
}

class Cases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get caseType => text().nullable()(); // Civil/Criminal/Family/Corporate
  TextColumn get status => text().withDefault(const Constant('Active'))(); // Active/Closed
  TextColumn get registrationNumber => text().nullable()();
  TextColumn get dateFiled => text().nullable()(); // ISO date
  IntColumn get courtId => integer().nullable().references(Courts, #id)();
  TextColumn get bench => text().nullable()();
  TextColumn get courtroomNumber => text().nullable()();
  TextColumn get clientName => text().nullable()();
  TextColumn get clientPhone => text().nullable()();
  TextColumn get clientCnic => text().nullable()();
  TextColumn get clientAddress => text().nullable()();
  TextColumn get oppositeParty => text().nullable()();
  TextColumn get oppositeCounsel => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}

class Hearings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caseId => integer().references(Cases, #id, onDelete: KeyAction.cascade)();
  TextColumn get hearingDate => text()(); // ISO date YYYY-MM-DD
  TextColumn get hearingTime => text().nullable()(); // 24h HH:mm
  TextColumn get purpose => text().nullable()(); // Bail/Evidence/Arguments/etc.
  TextColumn get outcome => text().nullable()();
  TextColumn get notes => text().nullable()();
}

class DocumentFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caseId => integer().references(Cases, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get createdAt => text()();
}

class DocumentImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get folderId => integer().references(DocumentFolders, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get addedAt => text()();
}

class ActivityLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // case_added, hearing_added, document_uploaded
  IntColumn get caseId => integer().nullable().references(Cases, #id)();
  IntColumn get hearingId => integer().nullable()();
  TextColumn get title => text()(); // short description for list
  TextColumn get createdAt => text()();
}

class NotificationHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get triggeredAt => text()(); // ISO datetime
  TextColumn get summary => text()();
}

@DriftDatabase(tables: [Courts, Cases, Hearings, DocumentFolders, DocumentImages, ActivityLog, NotificationHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance!;

  static Future<void> init() async {
    if (_instance != null) return;
    _instance = AppDatabase._(
      driftDatabase(
        name: 'advocato_db',
        web: kIsWeb
            ? DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              )
            : null,
      ),
    );
  }

  /// For tests only: init with an in-memory (or other) executor to avoid path_provider.
  static void initForTest(QueryExecutor executor) {
    _instance = AppDatabase._(executor);
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.createTable(hearings);
          }
          if (from < 3) {
            await migrator.createTable(documentFolders);
            await migrator.createTable(documentImages);
          }
          if (from < 4) {
            await migrator.createTable(activityLog);
            await migrator.createTable(notificationHistory);
          }
        },
      );

  // Courts
  Future<int> insertCourt(CourtsCompanion court) => into(courts).insert(court);
  Future<bool> updateCourt(Court court) => update(courts).replace(court);
  Future<int> deleteCourt(Court court) => delete(courts).delete(court);
  Future<List<Court>> getAllCourts() => select(courts).get();
  Stream<List<Court>> watchCourts() => select(courts).watch();
  Future<Court?> getCourtById(int id) =>
      (select(courts)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<Set<int>> getCourtIdsByHierarchy(String hierarchy) =>
      (select(courts)..where((t) => t.hierarchy.equals(hierarchy)))
          .get()
          .then((l) => l.map((c) => c.id).toSet());
  Future<int> countCasesByCourtId(int courtId) =>
      (select(cases)..where((c) => c.courtId.equals(courtId))).get().then((l) => l.length);

  // Cases
  Future<int> insertCase(CasesCompanion caseRow) => into(cases).insert(caseRow);
  Future<bool> updateCase(Case caseRow) => update(cases).replace(caseRow);
  Future<int> deleteCase(Case caseRow) => delete(cases).delete(caseRow);
  Future<Case?> getCaseById(int id) =>
      (select(cases)..where((c) => c.id.equals(id))).getSingleOrNull();
  Future<List<Case>> getAllCases() => select(cases).get();
  Stream<List<Case>> watchAllCases() => select(cases).watch();

  Future<List<Case>> getCasesFiltered({
    String? searchQuery,
    String? caseType,
    String? courtLevel,
    String? status,
  }) async {
    var list = await select(cases).get();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((c) => c.title.toLowerCase().contains(q)).toList();
    }
    if (caseType != null && caseType.isNotEmpty) {
      list = list.where((c) => c.caseType == caseType).toList();
    }
    if (status != null && status.isNotEmpty) {
      list = list.where((c) => c.status == status).toList();
    }
    if (courtLevel != null && courtLevel.isNotEmpty) {
      final courtIds = await (select(courts)..where((t) => t.hierarchy.equals(courtLevel)))
          .get()
          .then((l) => l.map((c) => c.id).toSet());
      list = list.where((c) => c.courtId != null && courtIds.contains(c.courtId)).toList();
    }
    return list;
  }

  // Hearings
  Future<int> insertHearing(HearingsCompanion hearing) =>
      into(hearings).insert(hearing);
  Future<bool> updateHearing(Hearing hearing) =>
      update(hearings).replace(hearing);
  Future<int> deleteHearing(Hearing hearing) =>
      delete(hearings).delete(hearing);
  Future<Hearing?> getHearingById(int id) =>
      (select(hearings)..where((h) => h.id.equals(id))).getSingleOrNull();
  Stream<List<Hearing>> watchHearingsForCase(int caseId) =>
      (select(hearings)..where((h) => h.caseId.equals(caseId))).watch();
  Future<List<Hearing>> getHearingsForCase(int caseId) =>
      (select(hearings)..where((h) => h.caseId.equals(caseId))).get();
  Future<List<Hearing>> getHearingsForDate(String isoDate) =>
      (select(hearings)..where((h) => h.hearingDate.equals(isoDate))).get();

  /// Upcoming = hearing_date >= today (ISO string comparison).
  Future<List<Hearing>> getUpcomingHearings() async {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return (select(hearings)..where((h) => h.hearingDate.isBiggerOrEqualValue(todayStr)))
        .get();
  }

  /// Count hearings per calendar day for badge. Keys: DateTime(year,month,day).
  Future<Map<DateTime, int>> getHearingCountByDay() async {
    final all = await select(hearings).get();
    final map = <DateTime, int>{};
    for (final h in all) {
      final parts = h.hearingDate.split('-');
      if (parts.length == 3) {
        final k = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        map[k] = (map[k] ?? 0) + 1;
      }
    }
    return map;
  }

  /// True if this case already has a hearing on the given ISO date (for duplicate check).
  /// Pass [excludeHearingId] when editing to allow same date for the current hearing.
  Future<bool> hasHearingOnDate(int caseId, String isoDate,
      {int? excludeHearingId}) async {
    final list = await (select(hearings)
          ..where((h) {
            var p =
                h.caseId.equals(caseId) & h.hearingDate.equals(isoDate);
            if (excludeHearingId != null) {
              p = p & h.id.isNotValue(excludeHearingId);
            }
            return p;
          }))
        .get();
    return list.isNotEmpty;
  }

  // Document folders
  Future<int> insertDocumentFolder(DocumentFoldersCompanion folder) =>
      into(documentFolders).insert(folder);
  Future<bool> updateDocumentFolder(DocumentFolder folder) =>
      update(documentFolders).replace(folder);
  Future<int> deleteDocumentFolder(DocumentFolder folder) =>
      delete(documentFolders).delete(folder);
  Future<DocumentFolder?> getDocumentFolderById(int id) =>
      (select(documentFolders)..where((f) => f.id.equals(id))).getSingleOrNull();
  Stream<List<DocumentFolder>> watchDocumentFoldersForCase(int caseId) =>
      (select(documentFolders)..where((f) => f.caseId.equals(caseId))).watch();
  Future<List<DocumentFolder>> getDocumentFoldersForCase(int caseId) =>
      (select(documentFolders)..where((f) => f.caseId.equals(caseId))).get();

  // Document images
  Future<int> insertDocumentImage(DocumentImagesCompanion image) =>
      into(documentImages).insert(image);
  Future<bool> updateDocumentImage(DocumentImage image) =>
      update(documentImages).replace(image);
  Future<int> deleteDocumentImage(DocumentImage image) =>
      delete(documentImages).delete(image);
  Future<DocumentImage?> getDocumentImageById(int id) =>
      (select(documentImages)..where((i) => i.id.equals(id))).getSingleOrNull();
  Stream<List<DocumentImage>> watchDocumentImagesForFolder(int folderId) =>
      (select(documentImages)..where((i) => i.folderId.equals(folderId))..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).watch();
  Future<List<DocumentImage>> getDocumentImagesForFolder(int folderId) =>
      (select(documentImages)..where((i) => i.folderId.equals(folderId))..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  Future<int> countImagesInFolder(int folderId) =>
      (select(documentImages)..where((i) => i.folderId.equals(folderId))).get().then((l) => l.length);

  /// Hearings in date range (inclusive); dates as ISO YYYY-MM-DD.
  Future<List<Hearing>> getHearingsFromUntil(String fromIso, String toIso) async {
    final all = await (select(hearings)
          ..where((h) =>
              h.hearingDate.isBiggerOrEqualValue(fromIso) &
              h.hearingDate.isSmallerOrEqualValue(toIso)))
        .get();
    return all;
  }

  /// Hearings with date < today and no outcome (overdue).
  Future<List<Hearing>> getOverdueHearings() async {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final list = await (select(hearings)
          ..where((h) =>
              h.hearingDate.isSmallerThanValue(todayStr) &
              (h.outcome.isNull() | h.outcome.equals(''))))
        .get();
    return list;
  }

  // Activity log
  Future<int> insertActivityLog(ActivityLogCompanion entry) =>
      into(activityLog).insert(entry);
  Future<List<ActivityLogData>> getRecentActivityLog({int limit = 30}) =>
      (select(activityLog)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])..limit(limit)).get();

  // Notification history
  Future<int> insertNotificationHistory(NotificationHistoryCompanion entry) =>
      into(notificationHistory).insert(entry);
  Future<List<NotificationHistoryData>> getNotificationHistory({int limit = 50}) =>
      (select(notificationHistory)
            ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)])
            ..limit(limit))
          .get();
}
