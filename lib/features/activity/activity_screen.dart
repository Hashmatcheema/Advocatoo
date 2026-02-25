import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';
import '../hearings/hearing_detail_screen.dart';

/// Activity tab: upcoming hearings, overdue, recent activity log, notification history (Increment 5).
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, this.largeText = false});

  final bool largeText;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Hearing> _upcoming = [];
  List<Hearing> _overdue = [];
  List<ActivityLogData> _activityLog = [];
  List<NotificationHistoryData> _notificationHistory = [];
  Map<int, String> _caseTitles = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = AppDatabase.instance;
    final upcoming = await db.getUpcomingHearings();
    final overdue = await db.getOverdueHearings();
    final activity = await db.getRecentActivityLog(limit: 10);
    final notifications = await db.getNotificationHistory(limit: 5);
    final caseIds = {...upcoming.map((h) => h.caseId), ...overdue.map((h) => h.caseId)};
    final titles = <int, String>{};
    for (final id in caseIds) {
      final c = await db.getCaseById(id);
      if (c != null) titles[id] = c.title;
    }
    if (mounted) {
      setState(() {
        _upcoming = upcoming;
        _overdue = overdue;
        _activityLog = activity;
        _notificationHistory = notifications;
        _caseTitles = titles;
        _loading = false;
      });
    }
  }

  void _openHearing(Hearing h) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HearingDetailScreen(hearingId: h.id, caseId: h.caseId),
      ),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Activity')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenPadding, vertical: 12),
          children: [
            _buildUpcomingSection(),
            _buildOverdueSection(),
            _buildActivityLogSection(),
            _buildNotificationHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSection() {
    return _Section(
      title: 'Next hearings',
      child: _upcoming.isEmpty
          ? const _Empty(text: 'No upcoming hearings')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _upcoming.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final h = _upcoming[index];
                final title = _caseTitles[h.caseId] ?? 'Case';
                final dateStr = h.hearingDate.length >= 10
                    ? DateFormat(AppConstants.dateFormatPattern).format(DateTime.parse(h.hearingDate))
                    : h.hearingDate;
                String timeStr = '—';
                if (h.hearingTime != null && h.hearingTime!.length >= 5) {
                  final parts = h.hearingTime!.split(':');
                  if (parts.length >= 2) {
                    final hour = int.tryParse(parts[0]) ?? 0;
                    final minute = int.tryParse(parts[1]) ?? 0;
                    timeStr = TimeOfDay(hour: hour, minute: minute).format(context);
                  }
                }
                return Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text('$dateStr • $timeStr • ${h.purpose ?? 'Hearing'}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openHearing(h),
                  ),
                ).animate().fadeIn(duration: 200.ms, delay: (index * 40).ms).slideY(begin: 0.05, end: 0, duration: 200.ms);
              },
            ),
    );
  }

  Widget _buildOverdueSection() {
    return _Section(
      title: 'Overdue hearings',
      child: _overdue.isEmpty
          ? const _Empty(text: 'No overdue hearings')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _overdue.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final h = _overdue[index];
                final title = _caseTitles[h.caseId] ?? 'Case';
                final dateStr = h.hearingDate.length >= 10
                    ? DateFormat(AppConstants.dateFormatPattern).format(DateTime.parse(h.hearingDate))
                    : h.hearingDate;
                return Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text('$dateStr — outcome not recorded'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openHearing(h),
                  ),
                ).animate().fadeIn(duration: 200.ms, delay: (index * 40).ms);
              },
            ),
    );
  }

  Widget _buildActivityLogSection() {
    return _Section(
      title: 'Recent activity',
      child: _activityLog.isEmpty
          ? const _Empty(text: 'No recent activity')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _activityLog.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final e = _activityLog[index];
                final dateStr = e.createdAt.length >= 19
                    ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(e.createdAt.substring(0, 19)))
                    : e.createdAt;
                return ListTile(
                  dense: true,
                  leading: Icon(_iconForType(e.type), size: 20, color: Theme.of(context).colorScheme.primary),
                  title: Text(e.title, style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                );
              },
            ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'case_added':
        return Icons.folder_open;
      case 'hearing_added':
        return Icons.event;
      case 'document_uploaded':
        return Icons.photo_library;
      default:
        return Icons.circle;
    }
  }

  Widget _buildNotificationHistorySection() {
    return _Section(
      title: 'Notification history',
      child: _notificationHistory.isEmpty
          ? const _Empty(text: 'No reminders sent yet')
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notificationHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final n = _notificationHistory[index];
                final dateStr = n.triggeredAt.length >= 19
                    ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(n.triggeredAt.substring(0, 19)))
                    : n.triggeredAt;
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.notifications, size: 20, color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    n.summary,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                );
              },
            ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        child,
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
