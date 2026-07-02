import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';
import '../widgets/circular_progress_ring.dart';
import '../widgets/activity_heatmap.dart';
import '../widgets/tuner_icon.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  // ── Mock data ─────────────────────────────────────────────────────────────
  final WorkoutPlan _plan1 = const WorkoutPlan(
    id: 1,
    name: 'Chest + tricep',
    scheduleLabel: 'Fridays',
    completionProgress: 0.82,
  );

  final WorkoutPlan _plan2 = const WorkoutPlan(
    id: 2,
    name: 'Back + bicep + Legs',
    scheduleLabel: 'Mondays',
    completionProgress: 1.0,
  );

  final BodyWeightEntry _latestWeight = BodyWeightEntry(
    date: DateTime.now().subtract(const Duration(minutes: 31)),
    weightLbs: 190,
  );

  final double _volumeLastWeekLbs = 3200;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildTopBar(),
                  const SizedBox(height: AppDimens.sectionSpacing),
                  _buildTopCardRow(),
                  const SizedBox(height: AppDimens.cardSpacing),
                  _buildPlan2Card(),
                  const SizedBox(height: AppDimens.cardSpacing),
                  _buildVolumeCard(),
                  const SizedBox(height: AppDimens.cardSpacing),
                  _buildAddCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar: title + action buttons ───────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Workouts', style: AppTextStyles.screenTitle),
        Row(
          children: [
            _buildIconButton(
              child: const TunerIcon(size: 18, color: AppColors.textSecondary),
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _buildIconButton(
              child: const Icon(
                Icons.add,
                color: AppColors.textPrimary,
                size: 22,
              ),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required Widget child,
    required VoidCallback onTap,
    double size = 44,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.buttonBackground,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }

  // ── Row: Plan 1 card + Body weight card ───────────────────────────────────
  Widget _buildTopCardRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildPlan1Card()),
          const SizedBox(width: AppDimens.cardSpacing),
          Expanded(child: _buildBodyWeightCard()),
        ],
      ),
    );
  }

  // ── Plan 1 card (Chest + tricep / Fridays) ─────────────────────────────
  Widget _buildPlan1Card() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularProgressRing(
                number: _plan1.id,
                progress: _plan1.completionProgress,
                size: 64,
                strokeWidth: 2.5,
              ),
              _buildTunerButton(),
            ],
          ),
          const Spacer(),
          Text(_plan1.name, style: AppTextStyles.cardTitle),
          const SizedBox(height: 2),
          Text(_plan1.scheduleLabel, style: AppTextStyles.cardSubtitle),
        ],
      ),
      minHeight: 170,
    );
  }

  // ── Body weight card ───────────────────────────────────────────────────────
  Widget _buildBodyWeightCard() {
    final minutesAgo = DateTime.now()
        .difference(_latestWeight.date)
        .inMinutes;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: _buildTunerButton(),
          ),
          const Spacer(),
          // Big number row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${_latestWeight.weightLbs.toInt()}',
                style: AppTextStyles.bigNumber,
              ),
              const SizedBox(width: 4),
              const Text('lbs', style: AppTextStyles.bigNumberUnit),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Body weight', style: AppTextStyles.cardTitle),
          const SizedBox(height: 2),
          Text('$minutesAgo min ago', style: AppTextStyles.cardSubtitle),
        ],
      ),
      minHeight: 170,
    );
  }

  // ── Plan 2 card with heatmap (Back + bicep + legs / Mondays) ─────────────
  Widget _buildPlan2Card() {
    final dots = ActivityHeatmap.generateMockDots();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityHeatmap(
            dots: dots,
            monthLabels: const ['Jan', 'Feb', 'Mar'],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircularProgressRing(
                number: _plan2.id,
                progress: _plan2.completionProgress,
                size: 48,
                strokeWidth: 2.0,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_plan2.name, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(
                      _plan2.scheduleLabel,
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
              _buildTunerButton(),
            ],
          ),
        ],
      ),
    );
  }

  // ── Volume lifted card ─────────────────────────────────────────────────────
  Widget _buildVolumeCard() {
    // Format: "3.200" (dot as thousand separator, European style)
    final volumeStr = _formatVolumeEuro(_volumeLastWeekLbs);

    return _buildCard(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Volume lifted', style: AppTextStyles.volumeLabel),
              const SizedBox(height: 2),
              Text('Last 7 days', style: AppTextStyles.cardSubtitle),
            ],
          ),
          const Spacer(),
          // Vertical divider line (subtle)
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(volumeStr, style: AppTextStyles.volumeNumber),
              const SizedBox(width: 4),
              const Text('lbs', style: AppTextStyles.volumeUnit),
            ],
          ),
          const SizedBox(width: 12),
          _buildTunerButton(),
        ],
      ),
    );
  }

  /// Format volume with dot as thousand separator (e.g. 3200 → "3.200")
  String _formatVolumeEuro(double value) {
    if (value >= 1000) {
      final thousands = (value ~/ 1000);
      final remainder = (value % 1000).toInt();
      return '$thousands.${remainder.toString().padLeft(3, '0')}';
    }
    return value.toInt().toString();
  }

  // ── Add card (+ placeholder) ───────────────────────────────────────────────
  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        ),
        child: const Center(
          child: Icon(Icons.add, color: AppColors.navIconInactive, size: 36),
        ),
      ),
    );
  }

  // ── Shared card wrapper ────────────────────────────────────────────────────
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

  // ── Tuner/sliders button (small) ───────────────────────────────────────────
  Widget _buildTunerButton({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: const TunerIcon(size: 16, color: AppColors.textSecondary),
    );
  }
}
