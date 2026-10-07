import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_summary.dart';
import 'live_status_badge.dart';

class CafeCard extends StatelessWidget {
  const CafeCard({super.key, required this.cafe, this.onTap, this.onSaved});

  final CafeSummary cafe;
  final VoidCallback? onTap;
  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CafeImage(
              imagePath: cafe.imagePath,
              isSaved: cafe.isSaved,
              onSaved: onSaved,
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    cafe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.title.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _Rating(rating: cafe.rating),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              cafe.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 9),

            Row(
              children: [
                const Icon(
                  Icons.near_me_outlined,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  cafe.distance,
                  style: AppTypography.tiny.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                LiveStatusBadge(status: cafe.liveStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CafeImage extends StatelessWidget {
  const _CafeImage({
    required this.imagePath,
    required this.isSaved,
    required this.onSaved,
  });

  final String? imagePath;
  final bool isSaved;
  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagePath != null)
              Image.asset(imagePath!, fit: BoxFit.cover)
            else
              Container(
                color: AppColors.surfaceSoft,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_cafe_outlined,
                  size: 34,
                  color: AppColors.textTertiary,
                ),
              ),

            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: AppColors.surface.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onSaved,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: isSaved
                          ? AppColors.espresso
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.rating),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.tiny.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
