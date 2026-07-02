import 'package:flutter/material.dart';

class AppColors {
  // Background layers
  static const Color background = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1C1C1E);
  static const Color cardBackgroundLight = Color(0xFF2C2C2E);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);

  // Accent / active
  static const Color dotActive = Color(0xFFFFFFFF);
  static const Color dotInactive = Color(0xFF3A3A3C);

  // Circle progress
  static const Color circleStroke = Color(0xFFFFFFFF);
  static const Color circleTrack = Color(0xFF3A3A3C);

  // Divider
  static const Color divider = Color(0xFF2C2C2E);

  // Bottom nav
  static const Color navIconActive = Color(0xFFFFFFFF);
  static const Color navIconInactive = Color(0xFF636366);

  // Buttons
  static const Color buttonBackground = Color(0xFF2C2C2E);
  static const Color addButtonBackground = Color(0xFF3A3A3C);

  // Profile screen
  static const Color avatarRingBackground = Color(0xFF2C2C2E);
  static const Color chevron = Color(0xFF636366);
  static const Color iconCircleBackground = Color(0xFF2C2C2E);

  // Calendar screen
  static const Color calendarDayActive = Color(0xFFFFFFFF);      // checked-in day fill
  static const Color calendarDayActiveText = Color(0xFF0A0A0A);  // text on white circle
  static const Color calendarDayToday = Color(0xFF2C2C2E);       // today outline
  static const Color calendarDayTodayText = Color(0xFFFFFFFF);   // today text
  static const Color calendarDayEmpty = Color(0xFF3A3A3C);       // future/empty text
  static const Color calendarHeader = Color(0xFF8E8E93);         // weekday header
  static const Color calendarArrow = Color(0xFF636366);
  static const Color checkedInButton = Color(0xFF2C2C2E);
  static const Color checkedInButtonActive = Color(0xFF3A3A3C);

  // Analytics / chart accent
  static const Color chartBarActive = Color.fromARGB(255, 255, 255, 255);   
  static const Color chartBarIdle = Color.fromARGB(255, 233, 239, 246);     
  static const Color chartBarMid = Color.fromARGB(255, 255, 255, 255);      
  static const Color periodSelectorBg = Color(0xFF1C1C1E);
  static const Color periodActiveText = Color(0xFF0A0A0A); 
  static const Color periodInactiveText = Color.fromARGB(255, 255, 255, 255); 
  static const Color weightLineColor = Color.fromARGB(255, 210, 217, 226);
  static const Color weightLineShadow = Color.fromARGB(51, 210, 216, 223); 
  static const Color weightFillTop = Color.fromARGB(68, 187, 210, 233);    
  static const Color weightFillBottom = Color.fromARGB(0, 230, 242, 255); 
  static const Color streakAccent = Color.fromARGB(255, 255, 255, 255);
}

class AppTextStyles {
  static const String fontFamily = 'SF Pro Display'; // iOS system font fallback

  static const TextStyle screenTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle bigNumber = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 52,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
    height: 1.0,
  );

  static const TextStyle bigNumberUnit = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
  );

  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle cardSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle workoutNumber = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static const TextStyle monthLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle volumeLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle volumeNumber = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static const TextStyle volumeUnit = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  // Profile screen
  static const TextStyle profileName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle profileEmail = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle profileMeta = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle statValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.0,
  );

  static const TextStyle statUnit = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle statLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle settingsLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionHeader = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle editProfileButton = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  // Calendar screen
  static const TextStyle calendarMonthTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle calendarWeekday = TextStyle(
    color: AppColors.calendarHeader,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle calendarDayNumber = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
  );

  static const TextStyle checkedInLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
  );

  static const TextStyle calendarStatValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.0,
  );

  static const TextStyle calendarStatLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Analytics screen
  static const TextStyle chartAxisLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle chartTooltip = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle periodLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
  );

  static const TextStyle streakNumber = TextStyle(
    color: AppColors.chartBarActive,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.0,
  );

  static const TextStyle analyticsStatValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.0,
  );

  static const TextStyle analyticsStatUnit = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle analyticsStatLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle chartSectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle weightProgressValue = TextStyle(
    color: AppColors.chartBarActive,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.0,
  );
}

class AppDimens {
  static const double screenPadding = 16.0;
  static const double cardRadius = 16.0;
  static const double cardPadding = 16.0;
  static const double cardSpacing = 10.0;
  static const double sectionSpacing = 16.0;
}
