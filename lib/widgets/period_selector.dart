import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';

/// Horizontal pill-style period selector.
/// Active pill: lime background with dark text.
/// Inactive: transparent with muted text.
class PeriodSelector extends StatelessWidget {
  final AnalyticsPeriod selected;
  final ValueChanged<AnalyticsPeriod> onChanged;

  const PeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: AnalyticsPeriod.values.map((period) {
          final isActive = period == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.chartBarActive : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  period.label,
                  style: AppTextStyles.periodLabel.copyWith(
                    color: isActive
                        ? AppColors.periodActiveText
                        : AppColors.periodInactiveText,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
