import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';

abstract class HearingsRepository {
  Future<int> insertHearing(HearingsCompanion hearing);
  Future<bool> updateHearing(Hearing hearing);
  Future<int> deleteHearing(Hearing hearing);
  Future<Hearing?> getHearingById(int id);
  Stream<List<Hearing>> watchHearingsForCase(int caseId);
  Future<List<Hearing>> getHearingsForCase(int caseId);
  Future<List<Hearing>> getHearingsForDate(String isoDate);
  Future<List<Hearing>> getUpcomingHearings();
  Future<Map<DateTime, int>> getHearingCountByDay();
  Future<bool> hasHearingOnDate(int caseId, String isoDate, {int? excludeHearingId});
  Future<List<Hearing>> getHearingsFromUntil(String fromIso, String toIso);
  Future<List<Hearing>> getOverdueHearings();
}

class DriftHearingsRepository implements HearingsRepository {
  final AppDatabase _db;
  DriftHearingsRepository(this._db);

  @override
  Future<int> insertHearing(HearingsCompanion hearing) => _db.insertHearing(hearing);

  @override
  Future<bool> updateHearing(Hearing hearing) => _db.updateHearing(hearing);

  @override
  Future<int> deleteHearing(Hearing hearing) => _db.deleteHearing(hearing);

  @override
  Future<Hearing?> getHearingById(int id) => _db.getHearingById(id);

  @override
  Stream<List<Hearing>> watchHearingsForCase(int caseId) => _db.watchHearingsForCase(caseId);

  @override
  Future<List<Hearing>> getHearingsForCase(int caseId) => _db.getHearingsForCase(caseId);

  @override
  Future<List<Hearing>> getHearingsForDate(String isoDate) => _db.getHearingsForDate(isoDate);

  @override
  Future<List<Hearing>> getUpcomingHearings() => _db.getUpcomingHearings();

  @override
  Future<Map<DateTime, int>> getHearingCountByDay() => _db.getHearingCountByDay();

  @override
  Future<bool> hasHearingOnDate(int caseId, String isoDate, {int? excludeHearingId}) =>
      _db.hasHearingOnDate(caseId, isoDate, excludeHearingId: excludeHearingId);

  @override
  Future<List<Hearing>> getHearingsFromUntil(String fromIso, String toIso) =>
      _db.getHearingsFromUntil(fromIso, toIso);

  @override
  Future<List<Hearing>> getOverdueHearings() => _db.getOverdueHearings();
}

final hearingsRepositoryProvider = Provider<HearingsRepository>((ref) {
  return DriftHearingsRepository(AppDatabase.instance);
});
