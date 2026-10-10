import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_guest_state.dart';
import '../../../cafe/presentation/providers/cafe_providers.dart';
import '../../../cafe/presentation/widgets/cafe_list_item.dart';
import '../providers/saved_cafes_provider.dart';
import '../utils/favorite_action.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final savedCafeIds = ref.watch(savedCafesProvider);
    final syncState = ref.watch(savedSyncProvider);

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
                'Saved',
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Places you want to come back to.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: authState.isGuest
                    ? const AuthGuestState(
                        icon: Icons.favorite_border_rounded,
                        title: 'Keep your favorite places',
                        description:
                            'Sign in to save cafés you love '
                            'and find them again anytime.',
                      )
                    : _SavedContent(
                        savedCafeIds: savedCafeIds,
                        syncState: syncState,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedContent extends ConsumerWidget {
  const _SavedContent({required this.savedCafeIds, required this.syncState});

  final Set<String> savedCafeIds;
  final SavedSyncState syncState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (syncState.status == SavedSyncStatus.idle || syncState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.espresso),
      );
    }

    if (syncState.status == SavedSyncStatus.error) {
      return _SavedErrorState(
        message: syncState.message ?? 'Could not load your saved cafés.',
        onRetry: () {
          ref.read(savedCafesProvider.notifier).load();
        },
      );
    }

    if (savedCafeIds.isEmpty) {
      return const _EmptySavedState();
    }

    final cafesAsync = ref.watch(cafesProvider);

    return cafesAsync.when(
      data: (allCafes) {
        final savedCafes = allCafes
            .where((cafe) => savedCafeIds.contains(cafe.id))
            .toList();

        if (savedCafes.isEmpty) {
          return const _EmptySavedState();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 24),
          itemCount: savedCafes.length,
          itemBuilder: (context, index) {
            final cafe = savedCafes[index];

            final isPending = syncState.pendingIds.contains(cafe.id);

            return CafeListItem(
              cafe: cafe,
              isSaved: true,
              showDivider: index != savedCafes.length - 1,
              onTap: () {
                context.push(AppRoutes.cafeDetailPath(cafe.id));
              },
              onSaved: isPending
                  ? null
                  : () {
                      FavoriteAction.toggle(
                        context: context,
                        ref: ref,
                        cafeId: cafe.id,
                      );
                    },
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.espresso),
      ),
      error: (_, _) => _SavedErrorState(
        message: 'Could not load saved cafés.',
        onRetry: () {
          ref.invalidate(cafesProvider);
        },
      ),
    );
  }
}

class _SavedErrorState extends StatelessWidget {
  const _SavedErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 25,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Nothing saved yet',
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 7),
            Text(
              'Save cafés you would like to visit.',
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
