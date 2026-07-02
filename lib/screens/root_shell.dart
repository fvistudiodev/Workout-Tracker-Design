import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import 'workouts_screen.dart';
import 'calendar_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

/// Hosts all four bottom-nav tabs. Each screen is kept alive via IndexedStack.
class RootShell extends StatefulWidget {
  const RootShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late int _currentIndex = widget.initialIndex;

  static const List<Widget> _tabs = [
    WorkoutsScreen(),
    CalendarScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}


