import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';
import '../widgets/volume_bar_chart.dart';
import '../widgets/weight_line_chart.dart';
import '../widgets/period_selector.dart';
import '../widgets/tuner_icon.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsPeriod _period = AnalyticsPeriod.week;

  // ── Mock data per period ───────────────────────────────────────────────────
  AnalyticsSnapshot get _snapshot => _buildSnapshot(_period);

  AnalyticsSnapshot _buildSnapshot(AnalyticsPeriod p) {
    switch (p) {
      case AnalyticsPeriod.week:
        return AnalyticsSnapshot(
          currentStreak: 9,
          longestStreak: 14,
          totalVolumeLbs: 22400,
          totalWorkouts: 5,
          volumeBars: const [
            ChartBar(label: 'Mon', value: 2800),
            ChartBar(label: 'Tue', value: 3600),
            ChartBar(label: 'Wed', value: 2100),
            ChartBar(label: 'Thu', value: 4200, isHighlight: true),
            ChartBar(label: 'Fri', value: 3900),
            ChartBar(label: 'Sat', value: 3200),
            ChartBar(label: 'Sun', value: 2600),
          ],
          weightProgress: _weightPointsWeek(),
          startWeightLbs: 186,
          currentWeightLbs: 190,
          goalWeightLbs: 198,
        );

      case AnalyticsPeriod.month:
        return AnalyticsSnapshot(
          currentStreak: 9,
          longestStreak: 14,
          totalVolumeLbs: 86400,
          totalWorkouts: 19,
          volumeBars: _monthBars(),
          weightProgress: _weightPointsMonth(),
          startWeightLbs: 183,
          currentWeightLbs: 190,
          goalWeightLbs: 198,
        );

      case AnalyticsPeriod.threeMonths:
        return AnalyticsSnapshot(
          currentStreak: 9,
          longestStreak: 21,
          totalVolumeLbs: 248000,
          totalWorkouts: 54,
          volumeBars: _threeMonthBars(),
          weightProgress: _weightPoints3M(),
          startWeightLbs: 178,
          currentWeightLbs: 190,
          goalWeightLbs: 198,
        );

      case AnalyticsPeriod.year:
        return AnalyticsSnapshot(
          currentStreak: 9,
          longestStreak: 28,
          totalVolumeLbs: 980000,
          totalWorkouts: 206,
          volumeBars: _yearBars(),
          weightProgress: _weightPointsYear(),
          startWeightLbs: 168,
          currentWeightLbs: 190,
          goalWeightLbs: 198,
        );
    }
  }

  // ── Mock weight data generators ────────────────────────────────────────────
  static List<WeightDataPoint> _weightPointsWeek() {
    final now = DateTime.now();
    return [
      WeightDataPoint(date: now.subtract(const Duration(days: 6)), weightLbs: 188.4),
      WeightDataPoint(date: now.subtract(const Duration(days: 5)), weightLbs: 188.8),
      WeightDataPoint(date: now.subtract(const Duration(days: 4)), weightLbs: 189.0),
      WeightDataPoint(date: now.subtract(const Duration(days: 3)), weightLbs: 189.6),
      WeightDataPoint(date: now.subtract(const Duration(days: 2)), weightLbs: 189.2),
      WeightDataPoint(date: now.subtract(const Duration(days: 1)), weightLbs: 190.1),
      WeightDataPoint(date: now, weightLbs: 190.0),
    ];
  }

  static List<WeightDataPoint> _weightPointsMonth() {
    final now = DateTime.now();
    final values = [183.0, 184.2, 184.8, 185.0, 185.6, 186.0, 186.4,
      186.2, 187.0, 187.8, 188.0, 188.4, 188.6, 189.0, 190.0];
    return List.generate(values.length, (i) => WeightDataPoint(
      date: now.subtract(Duration(days: (14 - i) * 2)),
      weightLbs: values[i],
    ));
  }

  static List<WeightDataPoint> _weightPoints3M() {
    final now = DateTime.now();
    final values = [178.0, 179.5, 181.0, 182.0, 183.0, 184.5,
      185.0, 186.0, 187.2, 188.0, 189.0, 190.0];
    return List.generate(values.length, (i) => WeightDataPoint(
      date: now.subtract(Duration(days: (11 - i) * 8)),
      weightLbs: values[i],
    ));
  }

  static List<WeightDataPoint> _weightPointsYear() {
    final now = DateTime.now();
    final values = [168.0, 171.0, 174.0, 176.0, 178.0, 181.0,
      183.0, 185.0, 186.5, 188.0, 189.5, 190.0];
    return List.generate(values.length, (i) => WeightDataPoint(
      date: now.subtract(Duration(days: (11 - i) * 30)),
      weightLbs: values[i],
    ));
  }

  // ── Mock bar data generators ───────────────────────────────────────────────
  static List<ChartBar> _monthBars() {
    final weeks = ['W1', 'W2', 'W3', 'W4'];
    final vals  = [19200.0, 22800.0, 24600.0, 19800.0];
    return List.generate(4, (i) => ChartBar(
      label: weeks[i],
      value: vals[i],
      isHighlight: vals[i] == vals.reduce((a, b) => a > b ? a : b),
    ));
  }

  static List<ChartBar> _threeMonthBars() {
    final labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final now = DateTime.now();
    final startMonth = now.month - 2;
    final vals = [72000.0, 86000.0, 90000.0];
    return List.generate(3, (i) {
      final m = (startMonth + i - 1) % 12;
      return ChartBar(
        label: labels[m],
        value: vals[i],
        isHighlight: i == 2,
      );
    });
  }

  static List<ChartBar> _yearBars() {
    const labels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    const vals = [58000.0, 62000.0, 78000.0, 72000.0, 82000.0, 90000.0,
      86000.0, 92000.0, 88000.0, 94000.0, 89000.0, 76000.0];
    final maxVal = vals.reduce((a, b) => a > b ? a : b);
    return List.generate(12, (i) => ChartBar(
      label: labels[i],
      value: vals[i],
      isHighlight: vals[i] == maxVal,
    ));
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final s = _snapshot;

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
            _buildPeriodSelector(),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildVolumeChartCard(s),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildStatsRow(s),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildStreakCard(s),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildWeightProgressCard(s),
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
        const Text('Analytics', style: AppTextStyles.screenTitle),
        _buildIconButton(
          child: const TunerIcon(size: 18, color: AppColors.textSecondary),
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

  // ── Period selector ────────────────────────────────────────────────────────
  Widget _buildPeriodSelector() {
    return PeriodSelector(
      selected: _period,
      onChanged: (p) => setState(() => _period = p),
    );
  }

  // ── Volume bar chart card ──────────────────────────────────────────────────
  Widget _buildVolumeChartCard(AnalyticsSnapshot s) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            label: 'Volume lifted',
            valueStr: _formatVolume(s.totalVolumeLbs),
            unit: 'lbs',
          ),
          const SizedBox(height: 30),
          VolumeBarChart(bars: s.volumeBars, height: 140),
        ],
      ),
    );
  }

  // ── Stats row: total workouts + avg volume ─────────────────────────────────
  Widget _buildStatsRow(AnalyticsSnapshot s) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildStatIsland(
              icon: Icons.fitness_center_rounded,
              value: s.totalWorkouts.toString(),
              unit: 'sessions',
            ),
          ),
          const SizedBox(width: AppDimens.cardSpacing),
          Expanded(
            child: _buildStatIsland(
              icon: Icons.bar_chart_rounded,
              value: _formatVolume(s.totalVolumeLbs / s.totalWorkouts),
              unit: 'lbs',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatIsland({
    required IconData icon,
    required String value,
    required String unit,
  }) {
    return _buildCard(
      minHeight: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const TunerIcon(size: 14, color: AppColors.textSecondary),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.analyticsStatValue,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(unit, style: AppTextStyles.analyticsStatUnit),
        ],
      ),
    );
  }

  // ── Streak card ────────────────────────────────────────────────────────────
  Widget _buildStreakCard(AnalyticsSnapshot s) {
    return _buildCard(
      child: Row(
        children: [
          // Current streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.streakAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text('Current streak', style: AppTextStyles.analyticsStatLabel),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('${s.currentStreak}', style: AppTextStyles.streakNumber),
                    const SizedBox(width: 6),
                    Text('days', style: AppTextStyles.analyticsStatUnit),
                  ],
                ),
              ],
            ),
          ),
          // Vertical divider
          Container(
            width: 1,
            height: 60,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          // Longest streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text('Best streak', style: AppTextStyles.analyticsStatLabel),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${s.longestStreak}',
                      style: AppTextStyles.analyticsStatValue,
                    ),
                    const SizedBox(width: 6),
                    Text('days', style: AppTextStyles.analyticsStatUnit),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Weight progress card ───────────────────────────────────────────────────
  Widget _buildWeightProgressCard(AnalyticsSnapshot s) {
    final gained = s.currentWeightLbs - s.startWeightLbs;
    final toGoal = s.goalWeightLbs - s.currentWeightLbs;
    final progress = ((s.currentWeightLbs - s.startWeightLbs) /
        (s.goalWeightLbs - s.startWeightLbs))
        .clamp(0.0, 1.0);

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            label: 'Weight progress',
            valueStr: '${s.currentWeightLbs.toInt()}',
            unit: 'lbs',
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildWeightBadge(
                label: '+${gained.toStringAsFixed(1)} lbs',
                sublabel: 'gained',
                isPositive: true,
              ),
              const SizedBox(width: 8),
              _buildWeightBadge(
                label: '${toGoal.toStringAsFixed(1)} lbs',
                sublabel: 'to goal',
                isPositive: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          WeightLineChart(data: s.weightProgress, height: 140),
          const SizedBox(height: 14),
          _buildGoalProgressBar(progress),
        ],
      ),
    );
  }

  Widget _buildWeightBadge({
    required String label,
    required String sublabel,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.chartBarActive.withOpacity(0.12)
            : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isPositive ? AppColors.chartBarActive : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 4),
          Text(sublabel, style: AppTextStyles.analyticsStatLabel),
        ],
      ),
    );
  }

  Widget _buildGoalProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Goal progress', style: AppTextStyles.analyticsStatLabel),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                color: AppColors.chartBarActive,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(
                height: 5,
                width: 33,
                color: AppColors.chartBarIdle,
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.chartBarActive,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared card header: label left, value+unit right ──────────────────────
  Widget _buildCardHeader({
    required String label,
    required String valueStr,
    required String unit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyles.chartSectionTitle),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(valueStr, style: AppTextStyles.analyticsStatValue),
            const SizedBox(width: 4),
            Text(unit, style: AppTextStyles.analyticsStatUnit),
          ],
        ),
      ],
    );
  }

  // ── Shared card wrapper — same as other screens ────────────────────────────
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

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _formatVolume(double value) {
    if (value >= 1000) {
      final thousands = (value ~/ 1000);
      final remainder = (value % 1000).toInt();
      return '$thousands.${remainder.toString().padLeft(3, '0')}';
    }
    return value.toInt().toString();
  }
}
