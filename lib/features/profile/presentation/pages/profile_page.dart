import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/widgets/cafeloca_brand.dart';
import '../../../../core/widgets/cafeloca_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_guest_state.dart';
import '../../../booking/presentation/providers/booking_history_provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CafelocaBrand(size: CafelocaBrandSize.small),
              const SizedBox(height: 32),
              Text(
                'Profile',
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Cafeloca account and activity.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: authState.isGuest
                    ? const AuthGuestState(
                        icon: Icons.person_outline_rounded,
                        title: 'You’re exploring as a guest',
                        description:
                            'Sign in to save cafés, write reviews, '
                            'and manage your bookings.',
                      )
                    : _ProfileContent(
                        fallbackName: authState.name,
                        email: authState.email,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.fallbackName, required this.email});

  final String? fallbackName;
  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final profileAsync = ref.watch(userProfileProvider(userId));

    return profileAsync.when(
      loading: () => _AuthenticatedProfile(
        key: ValueKey(userId),
        userId: userId,
        name: fallbackName,
        email: email,
        isProfileLoading: true,
      ),
      error: (_, _) => _AuthenticatedProfile(
        key: ValueKey(userId),
        userId: userId,
        name: fallbackName,
        email: email,
        hasProfileError: true,
        onRetry: () {
          ref.invalidate(userProfileProvider(userId));
        },
      ),
      data: (profile) {
        final databaseName = profile.fullName;

        final displayName =
            databaseName != null && databaseName.trim().isNotEmpty
            ? databaseName
            : fallbackName;

        return _AuthenticatedProfile(
          key: ValueKey(userId),
          userId: userId,
          name: displayName,
          email: email,
        );
      },
    );
  }
}

class _AuthenticatedProfile extends ConsumerStatefulWidget {
  const _AuthenticatedProfile({
    super.key,
    required this.userId,
    required this.name,
    required this.email,
    this.isProfileLoading = false,
    this.hasProfileError = false,
    this.onRetry,
  });

  final String userId;
  final String? name;
  final String? email;
  final bool isProfileLoading;
  final bool hasProfileError;
  final VoidCallback? onRetry;

  @override
  ConsumerState<_AuthenticatedProfile> createState() =>
      _AuthenticatedProfileState();
}

class _AuthenticatedProfileState extends ConsumerState<_AuthenticatedProfile> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    setState(() {
      _isSigningOut = true;
    });

    try {
      await ref.read(authProvider.notifier).signOut();

      ref.invalidate(userProfileProvider);
      ref.invalidate(myBookingsProvider);
    } on AuthException catch (error) {
      if (!mounted) return;

      _showError(error.message);
    } catch (_) {
      if (!mounted) return;

      _showError('Unable to sign out. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name;

    final displayName = name != null && name.trim().isNotEmpty
        ? name
        : 'Cafeloca Explorer';

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 30,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              displayName,
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
            ),
            if (widget.email != null && widget.email!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.email!,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'Signed in',
                style: AppTypography.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (widget.isProfileLoading) ...[
              const SizedBox(height: 16),
              const Text('Syncing your profile...'),
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
            ],
            if (widget.hasProfileError) ...[
              const SizedBox(height: 16),
              Text(
                'Your profile could not be synced.',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: widget.onRetry,
                child: const Text('Try again'),
              ),
            ],
            const SizedBox(height: 28),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {
                  ref.invalidate(myBookingsProvider(widget.userId));

                  context.push(AppRoutes.myBookings);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event_note_rounded,
                        color: AppColors.espresso,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'My Bookings',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: AbsorbPointer(
                absorbing: _isSigningOut,
                child: CafelocaButton(
                  label: _isSigningOut ? 'Signing out...' : 'Sign out',
                  onPressed: _signOut,
                ),
              ),
            ),
            if (_isSigningOut) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
