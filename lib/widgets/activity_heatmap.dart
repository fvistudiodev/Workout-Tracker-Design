import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';

class ActivityHeatmap extends StatelessWidget {
  final List<ActivityDot> dots;
  final List<String> monthLabels;

  const ActivityHeatmap({
    super.key,
    required this.dots,
    required this.monthLabels,
  });

  // Generates mock activity data matching the reference
  static List<ActivityDot> generateMockDots() {
    final now = DateTime.now();
    final List<ActivityDot> result = [];

    // ~90 days of data, some active
    final activeDays = {3, 7, 12, 15, 18, 22, 28, 33, 38, 42, 47, 52, 55, 60, 64, 70, 75, 80};

    for (int i = 89; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      result.add(ActivityDot(
        date: date,
        hasActivity: activeDays.contains(i),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthLabels(),
        const SizedBox(height: 8),
        _buildDotGrid(),
      ],
    );
  }

  Widget _buildMonthLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: monthLabels
          .map(
            (label) => Text(label, style: AppTextStyles.monthLabel),
          )
          .toList(),
    );
  }

  Widget _buildDotGrid() {
    // Display as a grid: 5 rows × N columns
    const rows = 5;
    final columns = (dots.length / rows).ceil();

    return SizedBox(
      height: rows * 10.0 + (rows - 1) * 4.0,
      child: Row(
        children: List.generate(columns, (col) {
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(rows, (row) {
                final index = col * rows + row;
                if (index >= dots.length) {
                  return const SizedBox(height: 10, width: 10);
                }
                final isActive = dots[index].hasActivity;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Center(
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.dotActive
                            : AppColors.dotInactive,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
