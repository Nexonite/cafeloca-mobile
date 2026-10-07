import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../data/cafe_dummy_data.dart';
import '../../domain/models/cafe_detail.dart';
import '../widgets/cafe_facility_item.dart';
import '../widgets/cafe_info_row.dart';
import '../widgets/live_status_badge.dart';

class CafeDetailPage extends StatelessWidget {
  const CafeDetailPage({super.key, required this.cafeId});

  final String cafeId;

  @override
  Widget build(BuildContext context) {
    final cafe = CafeDummyData.detailById(cafeId);

    if (cafe == null) {
      return const _CafeNotFoundPage();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _CafeHero(cafe: cafe),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _CafeHeading(cafe: cafe),

                    const SizedBox(height: 26),

                    const _SectionDivider(),

                    const SizedBox(height: 24),

                    _AboutSection(cafe: cafe),

                    const SizedBox(height: 30),

                    _SuitableForSection(cafe: cafe),

                    const SizedBox(height: 30),

                    _FacilitiesSection(cafe: cafe),

                    const SizedBox(height: 30),

                    const _SectionDivider(),

                    const SizedBox(height: 14),

                    CafeInfoRow(
                      icon: Icons.schedule_rounded,
                      title: 'Opening hours',
                      value: cafe.openingHours,
                    ),

                    const _SectionDivider(),

                    CafeInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      value: cafe.address,
                      onTap: () {
                        // TODO: Open map.
                      },
                    ),

                    const SizedBox(height: 30),

                    _MenuSection(cafe: cafe),

                    const SizedBox(height: 30),

                    _ReviewsSection(cafe: cafe),
                  ]),
                ),
              ),
            ],
          ),

          _BottomBookingBar(
            onPressed: () {
              context.push(AppRoutes.bookingPath(cafe.summary.id));
            },
          ),
        ],
      ),
    );
  }
}

class _CafeHero extends StatelessWidget {
  const _CafeHero({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
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
                        icon: cafe.summary.isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        onTap: () {
                          // TODO: Auth guard + favorite.
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
  const _HeroButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

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
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _CafeHeading extends StatelessWidget {
  const _CafeHeading({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                cafe.summary.name,
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 19,
                  color: AppColors.rating,
                ),

                const SizedBox(width: 4),

                Text(
                  cafe.summary.rating.toStringAsFixed(1),
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 7),

        Text(
          cafe.summary.category,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            LiveStatusBadge(status: cafe.summary.liveStatus),

            const SizedBox(width: 14),

            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.textTertiary,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 14),

            const Icon(
              Icons.near_me_outlined,
              size: 14,
              color: AppColors.textTertiary,
            ),

            const SizedBox(width: 5),

            Text(
              cafe.summary.distance,
              style: AppTypography.tiny.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'About'),

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

class _SuitableForSection extends StatelessWidget {
  const _SuitableForSection({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Suitable for'),

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

class _FacilitiesSection extends StatelessWidget {
  const _FacilitiesSection({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Facilities'),

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

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionTitle(title: 'Menu')),

            TextButton(
              onPressed: () {
                // TODO: Open full menu.
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'See all',
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ...cafe.menuItems.map((item) => _MenuItem(item: item)),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.item});

  final CafeMenuItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  item.category,
                  style: AppTypography.tiny.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Text(
            _formatPrice(item.price),
            style: AppTypography.label.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final value = price.toString();

    if (value.length <= 3) {
      return 'Rp$value';
    }

    final buffer = StringBuffer();
    final firstGroup = value.length % 3;

    if (firstGroup > 0) {
      buffer.write(value.substring(0, firstGroup));

      if (value.length > firstGroup) {
        buffer.write('.');
      }
    }

    for (int i = firstGroup; i < value.length; i += 3) {
      buffer.write(value.substring(i, i + 3));

      if (i + 3 < value.length) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Open reviews.
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.star_rounded, size: 22, color: AppColors.rating),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cafe.summary.rating.toStringAsFixed(1)} rating',
                    style: AppTypography.title.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${cafe.reviewCount} reviews',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBookingBar extends StatelessWidget {
  const _BottomBookingBar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          12 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Book a table',
              style: AppTypography.label.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.heading2.copyWith(color: AppColors.textPrimary),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }
}

class _CafeNotFoundPage extends StatelessWidget {
  const _CafeNotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_cafe_outlined,
                size: 38,
                color: AppColors.textTertiary,
              ),

              const SizedBox(height: 16),

              Text(
                'Café not found',
                style: AppTypography.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'This café may no longer be available.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
