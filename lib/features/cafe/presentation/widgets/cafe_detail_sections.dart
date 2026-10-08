import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_detail.dart';
import 'cafe_facility_item.dart';

class CafeAboutSection extends StatelessWidget {
  const CafeAboutSection({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CafeDetailSectionTitle(title: 'About'),
        const SizedBox(height: 10),
        Text(
          cafe.description,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class CafeSuitableForSection extends StatelessWidget {
  const CafeSuitableForSection({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CafeDetailSectionTitle(title: 'Suitable for'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cafe.suitableFor.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                item,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CafeFacilitiesSection extends StatelessWidget {
  const CafeFacilitiesSection({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CafeDetailSectionTitle(title: 'Facilities'),
        const SizedBox(height: 16),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cafe.facilities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 44,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            return CafeFacilityItem(facility: cafe.facilities[index]);
          },
        ),
      ],
    );
  }
}

class CafeDetailSectionTitle extends StatelessWidget {
  const CafeDetailSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.heading2.copyWith(color: AppColors.textPrimary),
    );
  }
}

class CafeDetailDivider extends StatelessWidget {
  const CafeDetailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }
}
