import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shared bottom navigation bar — identical across all screens.
/// [currentIndex] reflects which tab is active; [onTap] receives the new index.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<IconData> _icons = [
    Icons.grid_view_rounded,
    Icons.calendar_today_outlined,
    Icons.bar_chart_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
          (index) => _buildNavItem(index: index, icon: _icons[index]),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 80,
        child: Center(
          child: Icon(
            icon,
            color: isSelected
                ? AppColors.navIconActive
                : AppColors.navIconInactive,
            size: 24,
          ),
        ),
      ),
    );
  }
}
