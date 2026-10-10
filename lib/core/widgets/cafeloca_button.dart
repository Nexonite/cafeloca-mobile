import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum CafelocaButtonVariant { primary, secondary }

class CafelocaButton extends StatelessWidget {
  const CafelocaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = CafelocaButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final CafelocaButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == CafelocaButtonVariant.primary;

    final isDisabled = onPressed == null || isLoading;

    final foregroundColor = isDisabled
        ? AppColors.textTertiary
        : isPrimary
        ? AppColors.surface
        : AppColors.espresso;

    final backgroundColor = isDisabled
        ? AppColors.surfaceMuted
        : isPrimary
        ? AppColors.espresso
        : AppColors.surface;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: AppColors.surfaceMuted,
          disabledForegroundColor: AppColors.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AppColors.border),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textSecondary,
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.label.copyWith(color: foregroundColor),
              ),
      ),
    );
  }
}
