import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/booking.dart';
import '../../domain/models/booking_history_item.dart';
import '../providers/booking_history_provider.dart';

class MyBookingsPage extends ConsumerWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final client = ref.watch(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (auth.isGuest || userId == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Please sign in to view your bookings.')),
      );
    }

    final bookingsAsync = ref.watch(myBookingsProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: bookingsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.espresso),
        ),
        error: (_, _) => _ErrorState(
          onRetry: () {
            ref.invalidate(myBookingsProvider(userId));
          },
        ),
        data: (bookings) {
          if (bookings.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              final _ = await ref.refresh(myBookingsProvider(userId).future);
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return _BookingCard(booking: booking);
              },
            ),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final BookingHistoryItem booking;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final date = booking.date;
    final dateLabel = '${date.day} ${_months[date.month - 1]} ${date.year}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  booking.cafeName,
                  style: AppTypography.title.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.calendar_today_outlined, label: dateLabel),
          const SizedBox(height: 10),
          _DetailRow(icon: Icons.schedule_outlined, label: booking.time),
          const SizedBox(height: 10),
          _DetailRow(
            icon: Icons.people_outline_rounded,
            label:
                '${booking.guestCount} '
                '${booking.guestCount == 1 ? 'guest' : 'guests'}',
          ),
          if (booking.notes != null && booking.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _DetailRow(icon: Icons.notes_rounded, label: booking.notes!),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'ID: ${booking.id.substring(0, 8).toUpperCase()}',
                  style: AppTypography.tiny.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(AppRoutes.cafeDetailPath(booking.cafeId));
                },
                child: const Text('View café'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      BookingStatus.pending => 'Pending',
      BookingStatus.confirmed => 'Confirmed',
      BookingStatus.cancelled => 'Cancelled',
      BookingStatus.completed => 'Completed',
    };

    final color = switch (status) {
      BookingStatus.pending => AppColors.espresso,
      BookingStatus.confirmed => AppColors.success,
      BookingStatus.cancelled => AppColors.textSecondary,
      BookingStatus.completed => AppColors.textPrimary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTypography.tiny.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_note_outlined,
              size: 52,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 18),
            Text(
              'No bookings yet',
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Your café reservation requests '
              'will appear here.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not load your bookings',
            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
