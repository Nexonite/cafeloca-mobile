import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class ExploreCategory {
  const ExploreCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class ExploreCategorySelector extends StatelessWidget {
  const ExploreCategorySelector({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<ExploreCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = index == selectedIndex;

          return InkWell(
            onTap: () {
              onSelected(index);
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: selected ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? AppColors.textPrimary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    size: 15,
                    color: selected
                        ? AppColors.surface
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: AppTypography.tiny.copyWith(
                      color: selected
                          ? AppColors.surface
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
