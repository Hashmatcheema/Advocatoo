import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';
import 'hearings_calendar.dart';
import 'hearing_detail_screen.dart';
import 'upcoming_hearings_list.dart';

/// Hearings tab: calendar with badges, tap date for list, upcoming list from DB.
class HearingsScreen extends StatefulWidget {
  const HearingsScreen({super.key, this.largeText = false});

  final bool largeText;

  @override
  State<HearingsScreen> createState() => _HearingsScreenState();
}

class _HearingsScreenState extends State<HearingsScreen> {
  Map<DateTime, int> _countByDay = {};
  DateTime? _selectedDay;
  List<Hearing> _upcoming = [];
  Map<int, String> _caseTitles = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = AppDatabase.instance;
    final countMap = await db.getHearingCountByDay();
    final upcoming = await db.getUpcomingHearings();
    final caseIds = upcoming.map((h) => h.caseId).toSet();
    final titles = <int, String>{};
    for (final id in caseIds) {
      final c = await db.getCaseById(id);
      if (c != null) titles[id] = c.title;
    }
    if (mounted) {
      setState(() {
        _countByDay = countMap;
        _upcoming = upcoming;
        _caseTitles = titles;
        _loading = false;
      });
    }
  }

  void _onDaySelected(DateTime? selected, DateTime focused) {
    setState(() {
      _selectedDay = selected != null
          ? DateTime(selected.year, selected.month, selected.day)
          : null;
    });
    if (selected != null) _showHearingsForDate(selected);
  }

  Future<void> _showHearingsForDate(DateTime day) async {
    final iso =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    final list = await AppDatabase.instance.getHearingsForDate(iso);
    if (!mounted) return;
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'No hearings on ${DateFormat(AppConstants.dateFormatPattern).format(day)}')),
      );
      return;
    }
    final db = AppDatabase.instance;
    final titles = <int, String>{};
    for (final h in list) {
      if (!titles.containsKey(h.caseId)) {
        final c = await db.getCaseById(h.caseId);
        titles[h.caseId] = c?.title ?? 'Case';
      }
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => _HearingsOnDateSheet(
        date: day,
        hearings: list,
        caseTitles: titles,
        onTap: (h) {
          Navigator.of(ctx).pop();
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => HearingDetailScreen(
                hearingId: h.id,
                caseId: h.caseId,
                onDeleted: _load,
              ),
            ),
          ).then((_) => _load());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hearings'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HearingsCalendar(
                      hearingCountByDay: _countByDay,
                      selectedDay: _selectedDay,
                      onDaySelected: _onDaySelected,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Upcoming',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (_upcoming.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 48,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No upcoming hearings. Add hearings from a case.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                    UpcomingHearingsList(
                      isLoading: false,
                      hearings: _upcoming,
                      caseTitles: _caseTitles,
                      onHearingTap: (h) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => HearingDetailScreen(
                              hearingId: h.id,
                              caseId: h.caseId,
                              onDeleted: _load,
                            ),
                          ),
                        ).then((_) => _load());
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _HearingsOnDateSheet extends StatelessWidget {
  const _HearingsOnDateSheet({
    required this.date,
    required this.hearings,
    required this.caseTitles,
    required this.onTap,
  });

  final DateTime date;
  final List<Hearing> hearings;
  final Map<int, String> caseTitles;
  final void Function(Hearing) onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(AppConstants.dateFormatPattern).format(date);
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Hearings on $dateStr',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: hearings.length,
                itemBuilder: (context, index) {
                  final h = hearings[index];
                  String timeStr = '—';
                  if (h.hearingTime != null && h.hearingTime!.length >= 5) {
                    final parts = h.hearingTime!.split(':');
                    if (parts.length >= 2) {
                      final hour = int.tryParse(parts[0]) ?? 0;
                      final minute = int.tryParse(parts[1]) ?? 0;
                      timeStr =
                          TimeOfDay(hour: hour, minute: minute).format(context);
                    }
                  }
                  final title = caseTitles[h.caseId] ?? 'Case';
                  return ListTile(
                    title: Text(title),
                    subtitle: Text('${h.purpose ?? 'Hearing'} • $timeStr'),
                    onTap: () => onTap(h),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
