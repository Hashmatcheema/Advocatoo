import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Month view with per-day badge counts; tap to select date and show hearings.
class HearingsCalendar extends StatefulWidget {
  const HearingsCalendar({
    super.key,
    this.hearingCountByDay = const {},
    this.selectedDay,
    this.onDaySelected,
  });

  final Map<DateTime, int> hearingCountByDay;
  final DateTime? selectedDay;
  final void Function(DateTime? selected, DateTime focused)? onDaySelected;

  @override
  State<HearingsCalendar> createState() => _HearingsCalendarState();
}

class _HearingsCalendarState extends State<HearingsCalendar> {
  DateTime _focusedDay = DateTime.now();

  int _countForDay(DateTime day) {
    final k = DateTime(day.year, day.month, day.day);
    return widget.hearingCountByDay[k] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<void>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (d) => isSameDay(widget.selectedDay, d),
      onDaySelected: (selected, focused) {
        setState(() => _focusedDay = focused);
        widget.onDaySelected?.call(selected, focused);
      },
      onPageChanged: (focused) => setState(() => _focusedDay = focused),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final count = _countForDay(day);
          if (count <= 0) return null;
          return Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
