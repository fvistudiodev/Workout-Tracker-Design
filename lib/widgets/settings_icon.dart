import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Icon identifiers used by [SettingsIcon].
enum SettingsIconType {
  language,
  currencies,
  appearance,
  security,
  devices,
  password,
}

/// Renders a consistent outline-style icon inside a circular backdrop,
/// matching the settings-row icon language from the reference design.
class SettingsIcon extends StatelessWidget {
  final SettingsIconType type;
  final double size;

  const SettingsIcon({
    super.key,
    required this.type,
    this.size = 38,
  });

  IconData get _icon {
    switch (type) {
      case SettingsIconType.language:
        return Icons.public_outlined;
      case SettingsIconType.currencies:
        return Icons.attach_money_rounded;
      case SettingsIconType.appearance:
        return Icons.palette_outlined;
      case SettingsIconType.security:
        return Icons.shield_outlined;
      case SettingsIconType.devices:
        return Icons.devices_outlined;
      case SettingsIconType.password:
        return Icons.lock_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.iconCircleBackground,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          _icon,
          size: size * 0.48,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
