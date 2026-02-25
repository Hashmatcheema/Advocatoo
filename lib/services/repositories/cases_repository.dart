import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';

abstract class CasesRepository {
  Future<int> insertCase(CasesCompanion caseRow);
  Future<bool> updateCase(Case caseRow);
  Future<int> deleteCase(Case caseRow);
  Future<Case?> getCaseById(int id);
  Future<List<Case>> getAllCases();
  Stream<List<Case>> watchAllCases();
  Future<List<Case>> getCasesFiltered({
    String? searchQuery,
    String? caseType,
    String? courtLevel,
    String? status,
  });
}

class DriftCasesRepository implements CasesRepository {
  final AppDatabase _db;
  DriftCasesRepository(this._db);

  @override
  Future<int> insertCase(CasesCompanion caseRow) => _db.insertCase(caseRow);

  @override
  Future<bool> updateCase(Case caseRow) => _db.updateCase(caseRow);

  @override
  Future<int> deleteCase(Case caseRow) => _db.deleteCase(caseRow);

  @override
  Future<Case?> getCaseById(int id) => _db.getCaseById(id);

  @override
  Future<List<Case>> getAllCases() => _db.getAllCases();

  @override
  Stream<List<Case>> watchAllCases() => _db.watchAllCases();

  @override
  Future<List<Case>> getCasesFiltered({
    String? searchQuery,
    String? caseType,
    String? courtLevel,
    String? status,
  }) {
    return _db.getCasesFiltered(
      searchQuery: searchQuery,
      caseType: caseType,
      courtLevel: courtLevel,
      status: status,
    );
  }
}

final casesRepositoryProvider = Provider<CasesRepository>((ref) {
  return DriftCasesRepository(AppDatabase.instance);
});
