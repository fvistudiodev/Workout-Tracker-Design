import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';
import '../widgets/tuner_icon.dart';
import '../widgets/settings_icon.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Mock data ─────────────────────────────────────────────────────────────
  final UserProfile _user = const UserProfile(
    name: 'Alex Johnson',
    email: 'alex.official@email.com',
    role: '',
    location: 'Madrid, Spain',
    bodyWeightLbs: 190,
    heightCm: 178,
    activityLevel: ActivityLevel.active,
    mainGoal: FitnessGoal.muscleGain,
  );

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return SafeArea(
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
            _buildProfileCard(),
            const SizedBox(height: AppDimens.cardSpacing),
            _buildStatsRow(),
            const SizedBox(height: AppDimens.sectionSpacing),
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 10),
            _buildSettingsGroup([
              SettingsItem(
                label: 'Language',
                iconName: 'language',
                onTap: () {},
              ),
              SettingsItem(
                label: 'Currencies',
                iconName: 'currencies',
                onTap: () {},
              ),
              SettingsItem(
                label: 'Appearance',
                iconName: 'appearance',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppDimens.sectionSpacing),
            _buildSectionHeader('Security'),
            const SizedBox(height: 10),
            _buildSettingsGroup([
              SettingsItem(
                label: 'Application Security',
                iconName: 'security',
                onTap: () {},
              ),
              SettingsItem(
                label: 'Manage Devices',
                iconName: 'devices',
                onTap: () {},
              ),
              SettingsItem(
                label: 'Change Password',
                iconName: 'password',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Top bar: title + filter button ─────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Profile', style: AppTextStyles.screenTitle),
        _buildIconButton(
          child: const Icon(
            Icons.settings_outlined,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onTap: () {},
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
        decoration: const BoxDecoration(
          color: AppColors.buttonBackground,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }

  // ── Profile card: avatar, name, email, role/location, edit button ─────────
  Widget _buildProfileCard() {
    return _buildCard(
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 14),
          Text(_user.name, style: AppTextStyles.profileName),
          const SizedBox(height: 4),
          Text(_user.email, style: AppTextStyles.profileEmail),
          const SizedBox(height: 6),
          _buildRoleLocationRow(),
          const SizedBox(height: 18),
          _buildEditProfileButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 84,
      height: 84,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.avatarRingBackground,
      ),
      padding: const EdgeInsets.all(2.5),
      child: ClipOval(
        child: Container(
          color: AppColors.cardBackgroundLight,
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.textSecondary,
            size: 44,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleLocationRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_user.role, style: AppTextStyles.profileMeta),
        const Icon(
          Icons.location_on_outlined,
          size: 13,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 2),
        Text(_user.location, style: AppTextStyles.profileMeta),
      ],
    );
  }

  Widget _buildEditProfileButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundLight,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_outlined, size: 16, color: AppColors.textPrimary),
            SizedBox(width: 8),
            Text('Edit Profile', style: AppTextStyles.editProfileButton),
          ],
        ),
      ),
    );
  }

  // ── Stats row: body weight · height · activity level · main goal ──────────
  Widget _buildStatsRow() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildStatIsland(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Body weight',
                  value: _user.bodyWeightLbs.toInt().toString(),
                  unit: 'lbs',
                ),
              ),
              const SizedBox(width: AppDimens.cardSpacing),
              Expanded(
                child: _buildStatIsland(
                  icon: Icons.height_rounded,
                  label: 'Height',
                  value: _user.heightCm.toInt().toString(),
                  unit: 'cm',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.cardSpacing),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildStatIsland(
                  icon: Icons.bolt_rounded,
                  label: 'Activity level',
                  value: _user.activityLevel.label,
                  unit: null,
                ),
              ),
              const SizedBox(width: AppDimens.cardSpacing),
              Expanded(
                child: _buildStatIsland(
                  icon: Icons.flag_outlined,
                  label: 'Main goal',
                  value: _user.mainGoal.label,
                  unit: null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A single stat "island" card — matches the dashboard card language
  /// (rounded container, tuner icon top-right, label/value bottom).
  Widget _buildStatIsland({
    required IconData icon,
    required String label,
    required String value,
    String? unit,
  }) {
    return _buildCard(
      minHeight: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
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
                  style: AppTextStyles.statValue,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 3),
                Text(unit, style: AppTextStyles.statUnit),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.statLabel),
        ],
      ),
    );
  }

  // ── Section header label (e.g. "Preferences", "Security") ─────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(title.toUpperCase(), style: AppTextStyles.sectionHeader),
    );
  }

  // ── Grouped settings rows rendered as a single rounded card stack ─────────
  Widget _buildSettingsGroup(List<SettingsItem> items) {
    return Column(
      children: List.generate(items.length, (index) {
        final isLast = index == items.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.cardSpacing),
          child: _buildSettingsRow(items[index]),
        );
      }),
    );
  }

  Widget _buildSettingsRow(SettingsItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            SettingsIcon(type: _iconTypeFor(item.iconName)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(item.label, style: AppTextStyles.settingsLabel),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.chevron,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  SettingsIconType _iconTypeFor(String name) {
    switch (name) {
      case 'language':
        return SettingsIconType.language;
      case 'currencies':
        return SettingsIconType.currencies;
      case 'appearance':
        return SettingsIconType.appearance;
      case 'security':
        return SettingsIconType.security;
      case 'devices':
        return SettingsIconType.devices;
      case 'password':
        return SettingsIconType.password;
      default:
        return SettingsIconType.language;
    }
  }

  // ── Shared card wrapper — identical to WorkoutsScreen for visual parity ───
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
