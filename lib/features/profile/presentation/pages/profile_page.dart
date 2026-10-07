import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';
import '../../../../core/widgets/cafeloca_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                'Profile',
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your Cafeloca account and activity.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 30,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'You’re exploring as a guest',
                      textAlign: TextAlign.center,
                      style: AppTypography.title.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        'Sign in to save cafés, write reviews, and manage your bookings.',
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: 220,
                      child: CafelocaButton(
                        label: 'Sign in',
                        onPressed: () {
                          context.push(AppRoutes.login);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
