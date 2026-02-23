import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Bar chart for "Hearings this week" on Dashboard. [counts] = 7 days starting today.
class HearingsThisWeekBarChart extends StatelessWidget {
  const HearingsThisWeekBarChart({
    super.key,
    this.counts = const [0, 0, 0, 0, 0, 0, 0],
  });

  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final maxY = counts.isEmpty ? 1.0 : (counts.reduce((a, b) => a > b ? a : b) + 1).toDouble();
    if (maxY <= 0) return const SizedBox(height: 160);
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          barGroups: List.generate(7, (i) {
            final v = i < counts.length ? counts[i] : 0;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: v.toDouble(),
                  color: Theme.of(context).colorScheme.primary,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
