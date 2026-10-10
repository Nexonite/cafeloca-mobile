import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';
import '../../../../core/widgets/cafeloca_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_guest_state.dart';

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
                    : _AuthenticatedProfile(
                        name: authState.name,
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

class _AuthenticatedProfile extends ConsumerStatefulWidget {
  const _AuthenticatedProfile({required this.name, required this.email});

  final String? name;
  final String? email;

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
    final displayName = widget.name != null && widget.name!.trim().isNotEmpty
        ? widget.name!
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
            const SizedBox(height: 32),
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
