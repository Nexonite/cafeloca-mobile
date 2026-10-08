import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_detail.dart';
import 'cafe_detail_sections.dart';

class CafeDetailMenu extends StatelessWidget {
  const CafeDetailMenu({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: CafeDetailSectionTitle(title: 'Menu')),
            TextButton(
              onPressed: () {
                // TODO: Open full menu.
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'See all',
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...cafe.menuItems.map((item) => _MenuItem(item: item)),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.item});

  final CafeMenuItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.category,
                  style: AppTypography.tiny.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _formatPrice(item.price),
            style: AppTypography.label.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final value = price.toString();

    if (value.length <= 3) {
      return 'Rp$value';
    }

    final buffer = StringBuffer();
    final firstGroup = value.length % 3;

    if (firstGroup > 0) {
      buffer.write(value.substring(0, firstGroup));

      if (value.length > firstGroup) {
        buffer.write('.');
      }
    }

    for (int i = firstGroup; i < value.length; i += 3) {
      buffer.write(value.substring(i, i + 3));

      if (i + 3 < value.length) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }
}
