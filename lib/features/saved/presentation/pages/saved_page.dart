import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CafelocaBrand(size: CafelocaBrandSize.small),

              const SizedBox(height: 32),

              Text(
                'Saved',
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Places you want to come back to.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const Expanded(child: Center(child: _EmptySavedState())),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            size: 25,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Nothing saved yet',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),

        const SizedBox(height: 7),

        Text(
          'Save cafés you would like to visit.',
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
