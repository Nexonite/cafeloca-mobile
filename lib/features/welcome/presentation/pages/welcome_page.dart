import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';
import '../../../../core/widgets/cafeloca_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CafelocaBrand(size: CafelocaBrandSize.medium),
                        const SizedBox(height: 28),
                        const _WelcomeHero(),
                        const SizedBox(height: 30),
                        Text(
                          'Find your kind\nof place.',
                          style: AppTypography.display.copyWith(
                            fontSize: 34,
                            height: 1.16,
                            letterSpacing: -1.1,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'For coffee breaks, quiet afternoons, '
                          'and everything in between.',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CafelocaButton(
                          label: 'Get started',
                          onPressed: () {
                            context.push(AppRoutes.register);
                          },
                        ),
                        const SizedBox(height: 12),
                        CafelocaButton(
                          label: 'I already have an account',
                          variant: CafelocaButtonVariant.secondary,
                          onPressed: () {
                            context.push(AppRoutes.login);
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              context.go(AppRoutes.home);
                            },
                            child: Text(
                              'Continue as guest',
                              style: AppTypography.label.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.28,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/welcome/welcome_cafe.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const _WelcomeHeroFallback();
              },
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
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
                    const SizedBox(width: 8),
                    Text(
                      'A place for every moment',
                      style: AppTypography.tiny.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeroFallback extends StatelessWidget {
  const _WelcomeHeroFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.espressoSoft,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_cafe_outlined,
              size: 64,
              color: AppColors.espresso,
            ),
            const SizedBox(height: 20),
            Text(
              'Your next favorite café\nis waiting.',
              textAlign: TextAlign.center,
              style: AppTypography.heading2.copyWith(
                color: AppColors.espresso,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
