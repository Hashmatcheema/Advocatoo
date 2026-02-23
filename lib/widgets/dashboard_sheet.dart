import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../database/app_database.dart';
import '../utils/constants.dart';
import 'dashboard_data.dart';
import 'hearings_this_week_chart.dart';

Future<void> showDashboardSheet(BuildContext context) async {
  final data = await DashboardData.load();
  if (!context.mounted) return;
  final textTheme = Theme.of(context).textTheme;
  WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalContext) {
      return [
        WoltModalSheetPage(
          topBarTitle: Text('Dashboard', style: textTheme.titleMedium),
          isTopBarLayerAlwaysVisible: true,
          trailingNavBarWidget: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatTile(label: 'Total cases', value: data.totalCases),
                  const SizedBox(height: 8),
                  _StatTile(label: 'Active cases', value: data.activeCases),
                  const SizedBox(height: 8),
                  _StatTile(
                      label: 'Pending hearings',
                      value: data.pendingHearings),
                  const SizedBox(height: 8),
                  _StatTile(
                      label: 'Hearings this week',
                      value:
                          data.hearingsThisWeekCounts.fold<int>(0, (a, b) => a + b)),
                  if (data.nextHearing != null && data.nextHearingCaseTitle != null) ...[
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next hearing',
                              style: textTheme.labelLarge?.copyWith(
                                  color: Theme.of(modalContext)
                                      .colorScheme
                                      .primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.nextHearingCaseTitle!,
                              style: textTheme.titleSmall,
                            ),
                            Text(
                              _formatHearingDate(data.nextHearing!),
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _CasesByTypeSection(casesByType: data.casesByType),
                  const SizedBox(height: 8),
                  _StatTile(
                      label: 'Cases added this month',
                      value: data.casesAddedThisMonth),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: WoltModalSheet.of(modalContext).showNext,
                    child: const Text('Hearings this week'),
                  ),
                ],
              ),
            ),
          ),
        ),
        WoltModalSheetPage(
          topBarTitle: Text('Hearings this week', style: textTheme.titleMedium),
          leadingNavBarWidget: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: WoltModalSheet.of(modalContext).showPrevious,
          ),
          trailingNavBarWidget: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: HearingsThisWeekBarChart(
              counts: data.hearingsThisWeekCounts,
            ),
          ),
        ),
      ];
    },
  );
}

String _formatHearingDate(Hearing h) {
  final dateStr = h.hearingDate.length >= 10
      ? DateFormat(AppConstants.dateFormatPattern)
          .format(DateTime.parse(h.hearingDate))
      : h.hearingDate;
  String timeStr = '';
  if (h.hearingTime != null && h.hearingTime!.length >= 5) {
    final parts = h.hearingTime!.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final h12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final minStr = minute.toString().padLeft(2, '0');
      timeStr = ' $h12:$minStr ${hour >= 12 ? 'PM' : 'AM'}';
    }
  }
  return '$dateStr$timeStr • ${h.purpose ?? 'Hearing'}';
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: _AnimatedCount(
          value: value,
          duration: const Duration(milliseconds: 350),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _AnimatedCount extends StatefulWidget {
  const _AnimatedCount({
    required this.value,
    required this.duration,
    this.style,
  });

  final int value;
  final Duration duration;
  final TextStyle? style;

  @override
  State<_AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<_AnimatedCount>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.value.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Text(
          '${_animation.value.round()}',
          style: widget.style,
        );
      },
    );
  }
}

class _CasesByTypeSection extends StatelessWidget {
  const _CasesByTypeSection({required this.casesByType});
  final Map<String, int> casesByType;

  @override
  Widget build(BuildContext context) {
    if (casesByType.isEmpty) return const SizedBox.shrink();
    final types = ['Civil', 'Criminal', 'Family', 'Corporate'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cases by type',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in types)
                  if ((casesByType[t] ?? 0) > 0)
                    Chip(
                      label: Text('$t: ${casesByType[t]}'),
                      avatar: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          '${(casesByType[t] ?? 0)}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      ),
                    ),
                if (casesByType['Other'] != null && casesByType['Other']! > 0)
                  Chip(
                      label: Text('Other: ${casesByType['Other']}'),
                      avatar: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          '${casesByType['Other']}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
