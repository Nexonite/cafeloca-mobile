import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({
    super.key,
    required this.date,
    required this.time,
    required this.guestCount,
  });

  final DateTime date;
  final String time;
  final int guestCount;

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking summary',
            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            icon: Icons.calendar_today_outlined,
            label: '${date.day} ${_months[date.month - 1]} ${date.year}',
          ),
          const SizedBox(height: 12),
          _SummaryRow(icon: Icons.schedule_outlined, label: time),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Icons.people_outline_rounded,
            label: '$guestCount ${guestCount == 1 ? 'guest' : 'guests'}',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 11),
        Text(
          label,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
