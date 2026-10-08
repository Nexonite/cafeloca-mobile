import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_detail.dart';
import 'live_status_badge.dart';

class CafeDetailHeading extends StatelessWidget {
  const CafeDetailHeading({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                cafe.summary.name,
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 19,
                  color: AppColors.rating,
                ),
                const SizedBox(width: 4),
                Text(
                  cafe.summary.rating.toStringAsFixed(1),
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          cafe.summary.category,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            LiveStatusBadge(status: cafe.summary.liveStatus),
            const SizedBox(width: 14),
            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.textTertiary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            const Icon(
              Icons.near_me_outlined,
              size: 14,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 5),
            Text(
              cafe.summary.distance,
              style: AppTypography.tiny.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
