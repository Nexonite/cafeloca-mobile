import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.espresso,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.espresso,
          onPrimary: AppColors.surface,
          secondary: AppColors.espresso,
          onSecondary: AppColors.surface,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          onError: AppColors.surface,
          outline: AppColors.border,
          outlineVariant: AppColors.divider,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.divider,

      textTheme: base.textTheme.copyWith(
        displaySmall: AppTypography.display.copyWith(
          color: AppColors.textPrimary,
        ),
        headlineSmall: AppTypography.heading1.copyWith(
          color: AppColors.textPrimary,
        ),
        titleLarge: AppTypography.heading2.copyWith(
          color: AppColors.textPrimary,
        ),
        titleMedium: AppTypography.title.copyWith(color: AppColors.textPrimary),
        bodyMedium: AppTypography.body.copyWith(color: AppColors.textPrimary),
        bodySmall: AppTypography.caption.copyWith(
          color: AppColors.textSecondary,
        ),
        labelLarge: AppTypography.label.copyWith(color: AppColors.textPrimary),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading2.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.espresso,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.surfaceMuted,
          disabledForegroundColor: AppColors.textTertiary,
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: AppTypography.label,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.espresso,
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(color: AppColors.border),
          textStyle: AppTypography.label,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.espresso,
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          textStyle: AppTypography.label,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.espresso, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.espressoSoft,
        disabledColor: AppColors.surfaceMuted,
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: AppTypography.caption.copyWith(
          color: AppColors.espresso,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.body.copyWith(color: AppColors.surface),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.espressoSoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTypography.tiny.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.espresso
                : AppColors.textSecondary,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
