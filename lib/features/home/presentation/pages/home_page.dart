import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../cafe/presentation/providers/cafe_providers.dart';
import '../../../cafe/presentation/widgets/cafe_card.dart';
import '../../../cafe/presentation/widgets/cafe_list_item.dart';
import '../../../saved/presentation/providers/saved_cafes_provider.dart';
import '../../../saved/presentation/utils/favorite_action.dart';
import '../widgets/home_header.dart';
import '../widgets/home_moment_selector.dart';
import '../widgets/home_search_box.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_states.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedMoment = 0;

  static const List<HomeMoment> _moments = [
    HomeMoment(label: 'Nearby', icon: Icons.near_me_outlined),
    HomeMoment(label: 'Quiet', icon: Icons.volume_down_outlined),
    HomeMoment(label: 'Work', icon: Icons.laptop_mac_outlined),
    HomeMoment(label: 'Study', icon: Icons.menu_book_outlined),
    HomeMoment(label: 'Hangout', icon: Icons.people_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final cafesAsync = ref.watch(cafesProvider);
    final savedCafeIds = ref.watch(savedCafesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeHeader(),
                  const SizedBox(height: 34),
                  Text(
                    'Find your place.',
                    style: AppTypography.heading1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'What kind of place fits your moment?',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const HomeSearchBox(),
                  const SizedBox(height: 28),
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: HomeMomentSelector(
                moments: _moments,
                selectedIndex: _selectedMoment,
                onSelected: (index) {
                  setState(() {
                    _selectedMoment = index;
                  });
                },
              ),
            ),
            ...cafesAsync.when(
              data: (cafes) {
                if (cafes.isEmpty) {
                  return const [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: HomeEmptyState(),
                    ),
                  ];
                }

                return [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: HomeSectionHeader(
                        title: 'Near you',
                        onSeeAll: () {
                          // TODO: Open Explore with Nearby filter.
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 292,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                        scrollDirection: Axis.horizontal,
                        itemCount: cafes.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 16);
                        },
                        itemBuilder: (context, index) {
                          final cafe = cafes[index];

                          return CafeCard(
                            cafe: cafe,
                            isSaved: savedCafeIds.contains(cafe.id),
                            onTap: () {
                              context.push(AppRoutes.cafeDetailPath(cafe.id));
                            },
                            onSaved: () {
                              FavoriteAction.toggle(
                                context: context,
                                ref: ref,
                                cafeId: cafe.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: HomeSectionHeader(
                        title: 'Recommended for you',
                        onSeeAll: () {
                          // TODO: Open Explore recommendations.
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final cafe = cafes[index];

                        return CafeListItem(
                          cafe: cafe,
                          isSaved: savedCafeIds.contains(cafe.id),
                          showDivider: index != cafes.length - 1,
                          onTap: () {
                            context.push(AppRoutes.cafeDetailPath(cafe.id));
                          },
                          onSaved: () {
                            FavoriteAction.toggle(
                              context: context,
                              ref: ref,
                              cafeId: cafe.id,
                            );
                          },
                        );
                      }, childCount: cafes.length),
                    ),
                  ),
                ];
              },
              loading: () {
                return const [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: HomeLoadingState(),
                  ),
                ];
              },
              error: (error, stackTrace) {
                return [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: HomeErrorState(
                      onRetry: () {
                        ref.invalidate(cafesProvider);
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
