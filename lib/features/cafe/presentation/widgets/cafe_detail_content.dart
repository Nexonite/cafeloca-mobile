import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/models/cafe_detail.dart';
import 'cafe_detail_sections.dart';
import 'cafe_detail_hero.dart';
import 'cafe_detail_heading.dart';
import 'cafe_detail_menu.dart';
import 'cafe_detail_reviews.dart';
import 'cafe_detail_booking_bar.dart';
import 'cafe_info_row.dart';

class CafeDetailContent extends StatelessWidget {
  const CafeDetailContent({super.key, required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CafeDetailHero(cafe: cafe),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CafeDetailHeading(cafe: cafe),
                    const SizedBox(height: 26),
                    const CafeDetailDivider(),
                    const SizedBox(height: 24),
                    CafeAboutSection(cafe: cafe),
                    const SizedBox(height: 30),
                    CafeSuitableForSection(cafe: cafe),
                    const SizedBox(height: 30),
                    CafeFacilitiesSection(cafe: cafe),
                    const SizedBox(height: 30),
                    const CafeDetailDivider(),
                    const SizedBox(height: 14),
                    CafeInfoRow(
                      icon: Icons.schedule_rounded,
                      title: 'Opening hours',
                      value: cafe.openingHours,
                    ),
                    const CafeDetailDivider(),
                    CafeInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      value: cafe.address,
                      onTap: () {
                        // TODO: Open map.
                      },
                    ),
                    const SizedBox(height: 30),
                    CafeDetailMenu(cafe: cafe),
                    const SizedBox(height: 30),
                    CafeDetailReviews(cafe: cafe),
                  ]),
                ),
              ),
            ],
          ),
          CafeDetailBookingBar(
            onPressed: () {
              context.push(AppRoutes.bookingPath(cafe.summary.id));
            },
          ),
        ],
      ),
    );
  }
}
