import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class HomeSearchBox extends StatelessWidget {
  const HomeSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Open Explore / Search.
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.only(left: 15, right: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              size: 21,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                'Search café, area, or vibe',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Open filter.
              },
              icon: const Icon(Icons.tune_rounded, size: 19),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
