import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';

abstract class ActivityRepository {
  Future<int> insertActivityLog(ActivityLogCompanion entry);
  Future<List<ActivityLogData>> getRecentActivityLog({int limit = 30});
  
  Future<int> insertNotificationHistory(NotificationHistoryCompanion entry);
  Future<List<NotificationHistoryData>> getNotificationHistory({int limit = 50});
}

class DriftActivityRepository implements ActivityRepository {
  final AppDatabase _db;
  DriftActivityRepository(this._db);

  @override
  Future<int> insertActivityLog(ActivityLogCompanion entry) => _db.insertActivityLog(entry);

  @override
  Future<List<ActivityLogData>> getRecentActivityLog({int limit = 30}) => _db.getRecentActivityLog(limit: limit);

  @override
  Future<int> insertNotificationHistory(NotificationHistoryCompanion entry) => _db.insertNotificationHistory(entry);

  @override
  Future<List<NotificationHistoryData>> getNotificationHistory({int limit = 50}) => _db.getNotificationHistory(limit: limit);
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return DriftActivityRepository(AppDatabase.instance);
});
