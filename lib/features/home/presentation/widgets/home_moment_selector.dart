import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class HomeMoment {
  const HomeMoment({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class HomeMomentSelector extends StatelessWidget {
  const HomeMomentSelector({
    super.key,
    required this.moments,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<HomeMoment> moments;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: moments.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 28);
        },
        itemBuilder: (context, index) {
          final moment = moments[index];
          final selected = index == selectedIndex;

          return InkWell(
            onTap: () {
              onSelected(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  moment.icon,
                  size: 20,
                  color: selected ? AppColors.espresso : AppColors.textTertiary,
                ),
                const SizedBox(height: 5),
                Text(
                  moment.label,
                  style: AppTypography.tiny.copyWith(
                    color: selected
                        ? AppColors.espresso
                        : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  width: selected ? 22 : 0,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
