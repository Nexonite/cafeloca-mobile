import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class BookingTimeSelector extends StatelessWidget {
  const BookingTimeSelector({
    super.key,
    required this.times,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> times;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: List.generate(times.length, (index) {
        final selected = index == selectedIndex;

        return InkWell(
          onTap: () => onSelected(index),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 76,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.textPrimary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.textPrimary : AppColors.border,
              ),
            ),
            child: Text(
              times[index],
              style: AppTypography.label.copyWith(
                color: selected ? AppColors.surface : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    );
  }
}
