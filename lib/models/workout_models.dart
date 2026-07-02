/// Represents a workout program/plan
class WorkoutPlan {
  final int id;
  final String name;
  final String scheduleLabel; // e.g. "Fridays", "Mondays"
  final List<String> exercises;
  final double completionProgress; // 0.0 - 1.0

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.scheduleLabel,
    this.exercises = const [],
    this.completionProgress = 0.0,
  });
}

/// Represents a single workout session log
class WorkoutSession {
  final DateTime date;
  final int workoutPlanId;
  final double totalVolumeKg;
  final Duration duration;
  final List<ExerciseSet> sets;

  const WorkoutSession({
    required this.date,
    required this.workoutPlanId,
    required this.totalVolumeKg,
    required this.duration,
    this.sets = const [],
  });
}

/// Individual exercise set
class ExerciseSet {
  final String exerciseName;
  final double weightKg;
  final int reps;

  const ExerciseSet({
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
  });
}

/// Body weight entry
class BodyWeightEntry {
  final DateTime date;
  final double weightLbs;

  const BodyWeightEntry({
    required this.date,
    required this.weightLbs,
  });
}

/// Activity dot for the heatmap calendar widget
class ActivityDot {
  final DateTime date;
  final bool hasActivity;

  const ActivityDot({
    required this.date,
    required this.hasActivity,
  });
}

/// Fitness goal options for the user's profile
enum FitnessGoal { strength, muscleGain, weightLoss, endurance, mobility }

extension FitnessGoalLabel on FitnessGoal {
  String get label {
    switch (this) {
      case FitnessGoal.strength:
        return 'Strength';
      case FitnessGoal.muscleGain:
        return 'Muscle gain';
      case FitnessGoal.weightLoss:
        return 'Weight loss';
      case FitnessGoal.endurance:
        return 'Endurance';
      case FitnessGoal.mobility:
        return 'Mobility';
    }
  }
}

/// Self-reported activity level, used for analytics baselines
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

extension ActivityLevelLabel on ActivityLevel {
  String get label {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.light:
        return 'Lightly active';
      case ActivityLevel.moderate:
        return 'Moderate';
      case ActivityLevel.active:
        return 'Active';
      case ActivityLevel.veryActive:
        return 'Very active';
    }
  }
}

/// Core user profile — identity + body stats + preferences
class UserProfile {
  final String name;
  final String email;
  final String role;
  final String location;
  final String? avatarUrl;
  final double bodyWeightLbs;
  final double heightCm;
  final ActivityLevel activityLevel;
  final FitnessGoal mainGoal;

  const UserProfile({
    required this.name,
    required this.email,
    required this.role,
    required this.location,
    this.avatarUrl,
    required this.bodyWeightLbs,
    required this.heightCm,
    required this.activityLevel,
    required this.mainGoal,
  });
}

/// A single tappable settings row (Language, Currencies, etc.)
class SettingsItem {
  final String label;
  final String iconName; // maps to a custom painter or IconData key
  final void Function()? onTap;

  const SettingsItem({
    required this.label,
    required this.iconName,
    this.onTap,
  });
}

/// Represents the workout status of a single calendar day
enum CalendarDayStatus { empty, checkedIn, today, todayCheckedIn }

/// A day cell in the calendar widget
class CalendarDay {
  final int day;          // 1–31; 0 = padding cell (before month starts)
  final CalendarDayStatus status;

  const CalendarDay({required this.day, required this.status});
}

/// Shared mock data source — both CalendarScreen and AnalyticsScreen
/// read from here so streaks and sessions are always consistent.
abstract class AppData {
  // Workout session dates for the current year (mock)
  // In production this would come from a database/provider.
  static final Set<String> _checkedInDates = _buildCheckedInDates();

  static Set<String> _buildCheckedInDates() {
    final now = DateTime.now();
    final result = <String>{};
    // Simulate Mon/Fri pattern for the past ~3 months + some gaps
    for (int i = 0; i <= 90; i++) {
      final d = now.subtract(Duration(days: i));
      final weekday = d.weekday; // 1=Mon … 7=Sun
      // Skip some days to make it realistic
      if ((weekday == 1 || weekday == 3 || weekday == 5) && i % 7 != 6) {
        result.add(_dateKey(d));
      }
    }
    return result;
  }

  static String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  static bool isCheckedIn(DateTime d) => _checkedInDates.contains(_dateKey(d));

  /// Returns all checked-in dates as a list for use across screens
  static List<DateTime> get checkedInDates {
    final now = DateTime.now();
    final result = <DateTime>[];
    for (int i = 0; i <= 365; i++) {
      final d = now.subtract(Duration(days: i));
      if (_checkedInDates.contains(_dateKey(d))) result.add(d);
    }
    return result;
  }

  /// Streak — consecutive days going back from today
  static int get currentStreak {
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0; i <= 365; i++) {
      final d = now.subtract(Duration(days: i));
      if (isCheckedIn(d)) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  /// Sessions completed in current month
  static int get sessionsThisMonth {
    final now = DateTime.now();
    return checkedInDates
        .where((d) => d.month == now.month && d.year == now.year)
        .length;
  }

  /// Total sessions all time
  static int get totalSessions => checkedInDates.length;
}

/// Time period options for the analytics screen filter
enum AnalyticsPeriod { week, month, threeMonths, year }

extension AnalyticsPeriodLabel on AnalyticsPeriod {
  String get label {
    switch (this) {
      case AnalyticsPeriod.week:
        return 'Week';
      case AnalyticsPeriod.month:
        return 'Month';
      case AnalyticsPeriod.threeMonths:
        return '3 Months';
      case AnalyticsPeriod.year:
        return 'Year';
    }
  }
}

/// Single bar in the volume/workout chart
class ChartBar {
  final String label;    // x-axis label: day name or date
  final double value;    // raw value (volume in lbs, or count)
  final bool isHighlight; // peaks shown in lime, others in olive

  const ChartBar({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });
}

/// Single data point for the body-weight line chart
class WeightDataPoint {
  final DateTime date;
  final double weightLbs;

  const WeightDataPoint({
    required this.date,
    required this.weightLbs,
  });
}

/// Aggregated analytics data for a given period
class AnalyticsSnapshot {
  final int currentStreak;       // days
  final int longestStreak;       // days
  final double totalVolumeLbs;   // total lbs lifted in period
  final int totalWorkouts;       // sessions completed
  final List<ChartBar> volumeBars;
  final List<WeightDataPoint> weightProgress;
  final double startWeightLbs;
  final double currentWeightLbs;
  final double goalWeightLbs;

  const AnalyticsSnapshot({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalVolumeLbs,
    required this.totalWorkouts,
    required this.volumeBars,
    required this.weightProgress,
    required this.startWeightLbs,
    required this.currentWeightLbs,
    required this.goalWeightLbs,
  });
}
