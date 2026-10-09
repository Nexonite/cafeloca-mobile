import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_summary.dart';
import 'live_status_badge.dart';

class CafeListItem extends StatelessWidget {
  const CafeListItem({
    super.key,
    required this.cafe,
    this.onTap,
    this.onSaved,
    this.isSaved,
    this.showDivider = true,
  });

  final CafeSummary cafe;
  final VoidCallback? onTap;
  final VoidCallback? onSaved;
  final bool? isSaved;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final saved = isSaved ?? cafe.isSaved;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CafeThumbnail(imagePath: cafe.imagePath),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cafe.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.title.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                            Icons.star_rounded,
                            size: 15,
                            color: AppColors.rating,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            cafe.rating.toStringAsFixed(1),
                            style: AppTypography.tiny.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppColors.textTertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            cafe.distance,
                            style: AppTypography.tiny.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      LiveStatusBadge(status: cafe.liveStatus),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onSaved,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    saved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 20,
                    color: saved ? AppColors.espresso : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

class _CafeThumbnail extends StatelessWidget {
  const _CafeThumbnail({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 92,
        height: 92,
        child: imagePath != null
            ? Image.asset(imagePath!, fit: BoxFit.cover)
            : Container(
                color: AppColors.surfaceSoft,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_cafe_outlined,
                  size: 28,
                  color: AppColors.textTertiary,
                ),
              ),
      ),
    );
  }
}
