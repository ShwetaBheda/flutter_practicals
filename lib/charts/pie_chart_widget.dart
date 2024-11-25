import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> categoryCounts;

  const PieChartWidget({super.key, required this.categoryCounts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: categoryCounts.entries.map((entry) {
            final color = _getColorForCategory(entry.key);
            return PieChartSectionData(
              color: color,
              value: entry.value.toDouble(),
              title: '${entry.key} (${entry.value})',
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            );
          }).toList(),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'beauty':
        return Colors.pink;
      case 'fragrances':
        return Colors.blue;
      case 'groceries':
        return Colors.green;
      case 'furniture':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
