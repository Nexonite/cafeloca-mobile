import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_button.dart';
import '../utils/auth_navigation.dart';

class AuthGuestState extends StatelessWidget {
  const AuthGuestState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: 30, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
            ),

            const SizedBox(height: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                description,
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
                  context.push(AuthNavigation.loginPath());
                },
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                context.push(AuthNavigation.registerPath());
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
              ),
              child: Text(
                'Create account',
                style: AppTypography.label.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
