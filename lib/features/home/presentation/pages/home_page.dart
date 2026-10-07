import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/cafeloca_brand.dart';
import '../../../cafe/data/cafe_dummy_data.dart';
import '../../../cafe/presentation/widgets/cafe_card.dart';
import '../../../cafe/presentation/widgets/cafe_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMoment = 0;

  final _cafes = CafeDummyData.cafes;

  static const List<_Moment> _moments = [
    _Moment(label: 'Nearby', icon: Icons.near_me_outlined),
    _Moment(label: 'Quiet', icon: Icons.volume_down_outlined),
    _Moment(label: 'Work', icon: Icons.laptop_mac_outlined),
    _Moment(label: 'Study', icon: Icons.menu_book_outlined),
    _Moment(label: 'Hangout', icon: Icons.people_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
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
                  const _HomeHeader(),

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

                  const _SearchBox(),

                  const SizedBox(height: 28),
                ]),
              ),
            ),

            SliverToBoxAdapter(
              child: _MomentSelector(
                moments: _moments,
                selectedIndex: _selectedMoment,
                onSelected: (index) {
                  setState(() {
                    _selectedMoment = index;
                  });
                },
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
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
                  itemCount: _cafes.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 16);
                  },
                  itemBuilder: (context, index) {
                    final cafe = _cafes[index];

                    return CafeCard(
                      cafe: cafe,
                      onTap: () {
                        context.push(AppRoutes.cafeDetailPath(cafe.id));
                      },
                      onSaved: () {
                        // TODO: Auth guard + favorite.
                      },
                    );
                  },
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
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
                  final cafe = _cafes[index];

                  return CafeListItem(
                    cafe: cafe,
                    showDivider: index != _cafes.length - 1,
                    onTap: () {
                      context.push(AppRoutes.cafeDetailPath(cafe.id));
                    },
                    onSaved: () {
                      // TODO: Auth guard + favorite.
                    },
                  );
                }, childCount: _cafes.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CafelocaBrand(size: CafelocaBrandSize.small),

        const Spacer(),

        InkWell(
          onTap: () {
            // TODO: Open Profile.
          },
          customBorder: const CircleBorder(),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 19,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Open Explore / Search.
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.only(left: 15, right: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              size: 21,
              color: AppColors.textSecondary,
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                'Search café, area, or vibe',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                // TODO: Open filter.
              },
              icon: const Icon(Icons.tune_rounded, size: 19),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MomentSelector extends StatelessWidget {
  const _MomentSelector({
    required this.moments,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_Moment> moments;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: moments.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 28);
        },
        itemBuilder: (context, index) {
          final moment = moments[index];
          final selected = index == selectedIndex;

          return InkWell(
            onTap: () {
              onSelected(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  moment.icon,
                  size: 20,
                  color: selected ? AppColors.espresso : AppColors.textTertiary,
                ),

                const SizedBox(height: 5),

                Text(
                  moment.label,
                  style: AppTypography.tiny.copyWith(
                    color: selected
                        ? AppColors.espresso
                        : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 8),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  width: selected ? 22 : 0,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),

        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'See all',
            style: AppTypography.label.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _Moment {
  const _Moment({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
