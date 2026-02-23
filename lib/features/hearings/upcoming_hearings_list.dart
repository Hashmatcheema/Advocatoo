import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';

/// Upcoming hearings list from DB; tap to open HearingDetailScreen.
class UpcomingHearingsList extends StatelessWidget {
  const UpcomingHearingsList({
    super.key,
    required this.isLoading,
    this.hearings = const [],
    this.caseTitles = const {},
    this.onHearingTap,
  });

  final bool isLoading;
  final List<Hearing> hearings;
  final Map<int, String> caseTitles;
  final void Function(Hearing)? onHearingTap;

  @override
  Widget build(BuildContext context) {
    final count = isLoading ? 5 : hearings.length;
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: count,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (isLoading || index >= hearings.length) {
            return Card(
              child: ListTile(
                title: Text('Case • DD/MM/YYYY • 10:00 AM'),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          }
          final h = hearings[index];
          final dateStr = h.hearingDate.length >= 10
              ? DateFormat(AppConstants.dateFormatPattern)
                  .format(DateTime.parse(h.hearingDate))
              : h.hearingDate;
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
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text('$dateStr • $timeStr • ${h.purpose ?? 'Hearing'}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onHearingTap != null ? () => onHearingTap!(h) : null,
            ),
          );
        },
      ),
    );
  }
}
