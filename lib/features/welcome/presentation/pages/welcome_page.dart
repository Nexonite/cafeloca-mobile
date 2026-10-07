import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            children: [
              const CafelocaBrand(
                size: CafelocaBrandSize.medium,
                alignment: MainAxisAlignment.center,
              ),

              const SizedBox(height: 28),

              const Expanded(child: _CafePreview()),

              const SizedBox(height: 28),

              const _WelcomeContent(),

              const SizedBox(height: 28),

              _WelcomeActions(
                onExplore: () {
                  context.go(AppRoutes.home);
                },
                onSignIn: () {
                  context.push(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CafePreview extends StatelessWidget {
  const _CafePreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final previewHeight = constraints.maxHeight.clamp(250.0, 380.0);

        return SizedBox(
          width: double.infinity,
          height: previewHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 12,
                left: 0,
                right: 74,
                child: _PreviewCard(
                  height: previewHeight * 0.56,
                  title: 'Kopi Nako',
                  subtitle: 'Coffee · Casual',
                ),
              ),

              Positioned(
                top: previewHeight * 0.34,
                right: 0,
                width: 178,
                child: const _CompactPreviewCard(
                  title: 'Sejiwa Coffee',
                  subtitle: '1.2 km',
                ),
              ),

              const Positioned(
                left: 18,
                bottom: 8,
                child: _StatusPreview(label: 'Quiet right now'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.height,
    required this.title,
    required this.subtitle,
  });

  final double height;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_cafe_outlined,
                size: 38,
                color: AppColors.textTertiary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.title.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              const _Rating(rating: '4.8'),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _CompactPreviewCard extends StatelessWidget {
  const _CompactPreviewCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.coffee_outlined,
              size: 22,
              color: AppColors.textTertiary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: AppTypography.tiny.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPreview extends StatelessWidget {
  const _StatusPreview({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 7),

          const Icon(
            Icons.volume_down_outlined,
            size: 15,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: 5),

          Text(
            label,
            style: AppTypography.tiny.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 15, color: AppColors.rating),

        const SizedBox(width: 3),

        Text(
          rating,
          style: AppTypography.tiny.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Find your place.',
          textAlign: TextAlign.center,
          style: AppTypography.display.copyWith(color: AppColors.textPrimary),
        ),

        const SizedBox(height: 10),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 310),
          child: Text(
            'Discover cafés that fit your mood, needs, and moment.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _WelcomeActions extends StatelessWidget {
  const _WelcomeActions({required this.onExplore, required this.onSignIn});

  final VoidCallback onExplore;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onExplore,
            style: FilledButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.textPrimary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Start exploring',
              style: AppTypography.label.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: onSignIn,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Already a member? ',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                TextSpan(
                  text: 'Sign in',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
