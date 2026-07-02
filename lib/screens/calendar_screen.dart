import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';
import '../widgets/circular_progress_ring.dart';
import '../widgets/tuner_icon.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;
  late DateTime _today;

  // Workout plans — same source as dashboard
  final WorkoutPlan _plan1 = const WorkoutPlan(
    id: 1,
    name: 'Chest + tricep',
    scheduleLabel: 'Fridays',
    completionProgress: 0.82,
  );

  final WorkoutPlan _plan2 = const WorkoutPlan(
    id: 2,
    name: 'Back + bicep + legs',
    scheduleLabel: 'Mondays',
    completionProgress: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _displayedMonth = DateTime(_today.year, _today.month);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool _isToday(int day) =>
      _displayedMonth.year == _today.year &&
      _displayedMonth.month == _today.month &&
      day == _today.day;

  bool _isCheckedIn(int day) {
    if (day == 0) return false;
    final d = DateTime(_displayedMonth.year, _displayedMonth.month, day);
    return AppData.isCheckedIn(d);
  }

  bool _isTodayCheckedIn() => AppData.isCheckedIn(_today);

  /// Returns the number of days in the displayed month
  int get _daysInMonth {
    return DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
  }

  /// 0 = Mon … 6 = Sun (ISO weekday), mapped to SUN–SAT columns
  /// Column 0 = SUN, so we offset ISO weekday: Mon=1 → col 1, Sun=7 → col 0
  int _startColumnOffset() {
    final firstDay =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final isoWeekday = firstDay.weekday; // 1=Mon … 7=Sun
    return isoWeekday % 7; // Sun=0, Mon=1, … Sat=6
  }

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_displayedMonth.month - 1]} ${_displayedMonth.year}';
  }

  void _prevMonth() => setState(() {
        _displayedMonth =
            DateTime(_displayedMonth.year, _displayedMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _displayedMonth =
            DateTime(_displayedMonth.year, _displayedMonth.month + 1);
      });

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildTopBar(),
            const SizedBox(height: AppDimens.sectionSpacing),
            _buildCalendarCard(),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildStatsIsland(),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildNextWorkoutCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Calendar', style: AppTextStyles.screenTitle),
        _buildIconButton(
          child: const Icon(Icons.add, color: AppColors.textPrimary, size: 22),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildIconButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.buttonBackground,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }

  // ── Full calendar card ─────────────────────────────────────────────────────
  Widget _buildCalendarCard() {
    return _buildCard(
      child: Column(
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 16),
          _buildWeekdayHeader(),
          const SizedBox(height: 10),
          _buildDayGrid(),
          const SizedBox(height: 16),
          _buildCheckedInButton(),
        ],
      ),
    );
  }

  // Month nav: < April 2025 >
  Widget _buildMonthNavigation() {
    final isCurrentMonth = _displayedMonth.year == _today.year &&
        _displayedMonth.month == _today.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNavArrow(Icons.chevron_left_rounded, onTap: _prevMonth),
        Text(_monthLabel(), style: AppTextStyles.calendarMonthTitle),
        _buildNavArrow(
          Icons.chevron_right_rounded,
          onTap: isCurrentMonth ? null : _nextMonth,
          muted: isCurrentMonth,
        ),
      ],
    );
  }

  Widget _buildNavArrow(IconData icon,
      {required VoidCallback? onTap, bool muted = false}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          icon,
          color: muted ? AppColors.calendarArrow.withOpacity(0.3) : AppColors.calendarArrow,
          size: 22,
        ),
      ),
    );
  }

  // SUN MON TUE WED THU FRI SAT
  Widget _buildWeekdayHeader() {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Row(
      children: days.map((d) => Expanded(
        child: Center(
          child: Text(d, style: AppTextStyles.calendarWeekday),
        ),
      )).toList(),
    );
  }

  // Day cells grid
  Widget _buildDayGrid() {
    final offset = _startColumnOffset();
    final daysInMonth = _daysInMonth;

    // Build flat list: offset empty cells + day cells
    final totalCells = offset + daysInMonth;
    // Pad to full weeks
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final day = cellIndex - offset + 1;
              final isValid = day >= 1 && day <= daysInMonth;
              if (!isValid) {
                return const Expanded(child: SizedBox(height: 42));
              }
              return Expanded(child: _buildDayCell(day));
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(int day) {
    final today = _isToday(day);
    final checkedIn = _isCheckedIn(day);
    final isFuture = DateTime(_displayedMonth.year, _displayedMonth.month, day)
        .isAfter(_today);

    Color? bgColor;
    Color textColor;

    if (checkedIn) {
      bgColor = AppColors.calendarDayActive;
      textColor = AppColors.calendarDayActiveText;
    } else if (today) {
      bgColor = AppColors.calendarDayToday;
      textColor = AppColors.calendarDayTodayText;
    } else if (isFuture) {
      bgColor = null;
      textColor = AppColors.calendarDayEmpty;
    } else {
      bgColor = null;
      textColor = AppColors.textSecondary;
    }

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: AppTextStyles.calendarDayNumber.copyWith(
            color: textColor,
            fontWeight: checkedIn ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ✓ Checked In button
  Widget _buildCheckedInButton() {
    final todayCheckedIn = _isTodayCheckedIn();

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: todayCheckedIn
              ? AppColors.checkedInButtonActive
              : AppColors.checkedInButton,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              todayCheckedIn
                  ? Icons.check_circle_outline_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text('Checked In', style: AppTextStyles.checkedInLabel),
          ],
        ),
      ),
    );
  }

  // ── Stats island: Streak · Sessions ───────────────────────────────────────
  // Data sourced from AppData — consistent with Analytics tab
  Widget _buildStatsIsland() {
    final streak = AppData.currentStreak;
    final sessions = AppData.sessionsThisMonth;

    return _buildCard(
      child: Row(
        children: [
          // Streak
          Expanded(
            child: _buildStatCell(
              value: '$streak',
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.streakAccent,
              label: 'Streak',
            ),
          ),
          // Vertical divider
          Container(
            width: 1,
            height: 44,
            color: AppColors.divider,
          ),
          // Sessions
          Expanded(
            child: _buildStatCell(
              value: '$sessions',
              icon: Icons.fitness_center_rounded,
              iconColor: AppColors.textSecondary,
              label: 'Sessions',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCell({
    required String value,
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(value, style: AppTextStyles.calendarStatValue),
              const SizedBox(width: 4),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.calendarStatLabel),
        ],
      ),
    );
  }

  // ── Next workout card: wide plan card like dashboard ──────────────────────
  // Displays whichever plan is scheduled next (based on today's weekday)
  Widget _buildNextWorkoutCard() {
    // Determine which plan to show based on today
    final todayWeekday = _today.weekday; // 1=Mon … 7=Sun
    // plan1 = Fridays (5), plan2 = Mondays (1)
    final showPlan2 = todayWeekday <= 1 ||
        (todayWeekday > 5); // show plan2 if Mon or weekend approaching Mon

    final plan = showPlan2 ? _plan2 : _plan1;
    final daysUntil = _daysUntilNextOccurrence(plan);
    final nextLabel = daysUntil == 0
        ? 'Today'
        : daysUntil == 1
            ? 'Tomorrow'
            : 'In $daysUntil days';

    return _buildCard(
      child: Row(
        children: [
          CircularProgressRing(
            number: plan.id,
            progress: plan.completionProgress,
            size: 56,
            strokeWidth: 2.5,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: AppTextStyles.cardTitle),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(plan.scheduleLabel, style: AppTextStyles.cardSubtitle),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(nextLabel, style: AppTextStyles.cardSubtitle),
                  ],
                ),
              ],
            ),
          ),
          const TunerIcon(size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  int _daysUntilNextOccurrence(WorkoutPlan plan) {
    // plan1 = Fridays (5), plan2 = Mondays (1)
    final targetWeekday = plan.id == 1 ? 5 : 1;
    final todayWeekday = _today.weekday;
    int diff = targetWeekday - todayWeekday;
    if (diff < 0) diff += 7;
    return diff;
  }

  // ── Shared card wrapper — identical to all other screens ──────────────────
  Widget _buildCard({required Widget child, double? minHeight}) {
    return Container(
      constraints:
          minHeight != null ? BoxConstraints(minHeight: minHeight) : null,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.cardRadius),
      ),
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      child: child,
    );
  }
}
