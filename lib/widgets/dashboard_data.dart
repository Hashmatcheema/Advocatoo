import '../../database/app_database.dart';

/// Data for the Dashboard modal (Increment 6).
class DashboardData {
  const DashboardData({
    required this.totalCases,
    required this.activeCases,
    required this.pendingHearings,
    required this.hearingsThisWeekCounts,
    required this.casesByType,
    this.nextHearing,
    this.nextHearingCaseTitle,
    required this.casesAddedThisMonth,
  });

  final int totalCases;
  final int activeCases;
  final int pendingHearings;
  /// Counts for 7 days starting today (index 0 = today).
  final List<int> hearingsThisWeekCounts;
  final Map<String, int> casesByType;
  final Hearing? nextHearing;
  final String? nextHearingCaseTitle;
  final int casesAddedThisMonth;

  static Future<DashboardData> load() async {
    final db = AppDatabase.instance;
    final cases = await db.getAllCases();
    final totalCases = cases.length;
    final activeCases = cases.where((c) => c.status != 'Closed').length;
    final upcoming = await db.getUpcomingHearings();
    final pendingHearings = upcoming.length;

    final now = DateTime.now();
    final counts = <int>[];
    final countByDay = await db.getHearingCountByDay();
    for (var i = 0; i < 7; i++) {
      final d = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      counts.add(countByDay[d] ?? 0);
    }

    final casesByType = <String, int>{};
    for (final c in cases) {
      final t = c.caseType ?? 'Other';
      casesByType[t] = (casesByType[t] ?? 0) + 1;
    }

    Hearing? nextHearing;
    String? nextHearingCaseTitle;
    if (upcoming.isNotEmpty) {
      nextHearing = upcoming.first;
      final c = await db.getCaseById(nextHearing.caseId);
      nextHearingCaseTitle = c?.title;
    }

    final monthPrefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final casesAddedThisMonth =
        cases.where((c) => c.createdAt.startsWith(monthPrefix)).length;

    return DashboardData(
      totalCases: totalCases,
      activeCases: activeCases,
      pendingHearings: pendingHearings,
      hearingsThisWeekCounts: counts,
      casesByType: casesByType,
      nextHearing: nextHearing,
      nextHearingCaseTitle: nextHearingCaseTitle,
      casesAddedThisMonth: casesAddedThisMonth,
    );
  }
}
