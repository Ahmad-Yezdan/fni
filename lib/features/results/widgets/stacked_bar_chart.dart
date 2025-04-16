import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';

class StackedBarChart extends StatelessWidget {
  final double normalForm, completeness, normalizationCompleteness;

  const StackedBarChart({
    super.key,
    required this.normalForm,
    required this.completeness,
    required this.normalizationCompleteness,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BarChart(
        BarChartData(
          maxY: 4.5,
          barGroups: [
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: normalForm + completeness,
                  color: MyColors.primary,
                  width: 40,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(normalForm, normalForm + completeness,
                        MyColors.lightprimary)
                  ],
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 12,
                    getTitlesWidget: (value, _) {
                      if (value >= 0 && value <= 4 && value % 1 == 0) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      }
                      return Container();
                    })),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (_, __) => Text(
                        '$normalizationCompleteness NF',
                        style: const TextStyle(fontWeight: FontWeight.bold)))),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(
              show: true, drawVerticalLine: false, horizontalInterval: 1),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
