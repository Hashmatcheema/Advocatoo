import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';

abstract class CourtsRepository {
  Future<int> insertCourt(CourtsCompanion court);
  Future<bool> updateCourt(Court court);
  Future<int> deleteCourt(Court court);
  Future<List<Court>> getAllCourts();
  Stream<List<Court>> watchCourts();
  Future<Court?> getCourtById(int id);
  Future<Set<int>> getCourtIdsByHierarchy(String hierarchy);
  Future<int> countCasesByCourtId(int courtId);
}

class DriftCourtsRepository implements CourtsRepository {
  final AppDatabase _db;
  DriftCourtsRepository(this._db);

  @override
  Future<int> insertCourt(CourtsCompanion court) => _db.insertCourt(court);

  @override
  Future<bool> updateCourt(Court court) => _db.updateCourt(court);

  @override
  Future<int> deleteCourt(Court court) => _db.deleteCourt(court);

  @override
  Future<List<Court>> getAllCourts() => _db.getAllCourts();

  @override
  Stream<List<Court>> watchCourts() => _db.watchCourts();

  @override
  Future<Court?> getCourtById(int id) => _db.getCourtById(id);

  @override
  Future<Set<int>> getCourtIdsByHierarchy(String hierarchy) => _db.getCourtIdsByHierarchy(hierarchy);

  @override
  Future<int> countCasesByCourtId(int courtId) => _db.countCasesByCourtId(courtId);
}

final courtsRepositoryProvider = Provider<CourtsRepository>((ref) {
  return DriftCourtsRepository(AppDatabase.instance);
});
