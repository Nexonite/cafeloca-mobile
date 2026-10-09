import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../saved/presentation/providers/saved_cafes_provider.dart';
import '../../../saved/presentation/utils/favorite_action.dart';
import '../../domain/models/cafe_detail.dart';

class CafeDetailHero extends ConsumerWidget {
  const CafeDetailHero({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCafeIds = ref.watch(savedCafesProvider);
    final isSaved = savedCafeIds.contains(cafe.summary.id);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (cafe.summary.imagePath != null)
              Image.asset(cafe.summary.imagePath!, fit: BoxFit.cover)
            else
              Container(
                color: AppColors.surfaceSoft,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_cafe_outlined,
                  size: 42,
                  color: AppColors.textTertiary,
                ),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Color(0x55000000), Color(0x00000000)],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      _HeroButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.home);
                          }
                        },
                      ),
                      const Spacer(),
                      _HeroButton(
                        icon: isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: isSaved
                            ? AppColors.espresso
                            : AppColors.textPrimary,
                        onTap: () {
                          FavoriteAction.toggle(
                            context: context,
                            ref: ref,
                            cafeId: cafe.summary.id,
                            returnPath: AppRoutes.cafeDetailPath(
                              cafe.summary.id,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}
