import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_summary.dart';

class LiveStatusBadge extends StatelessWidget {
  const LiveStatusBadge({super.key, required this.status});

  final CafeLiveStatus status;

  @override
  Widget build(BuildContext context) {
    final data = _statusData;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          data.label,
          style: AppTypography.tiny.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  _StatusData get _statusData {
    switch (status) {
      case CafeLiveStatus.quiet:
        return const _StatusData(label: 'Quiet', color: AppColors.success);

      case CafeLiveStatus.moderate:
        return const _StatusData(label: 'Moderate', color: AppColors.warning);

      case CafeLiveStatus.crowded:
        return const _StatusData(label: 'Crowded', color: AppColors.error);
    }
  }
}

class _StatusData {
  const _StatusData({required this.label, required this.color});

  final String label;
  final Color color;
}
