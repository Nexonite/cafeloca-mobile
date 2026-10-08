import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../cafe/domain/models/cafe_summary.dart';
import '../../../cafe/presentation/providers/cafe_providers.dart';
import '../../../cafe/presentation/widgets/cafe_list_item.dart';
import '../widgets/explore_category_selector.dart';
import '../widgets/explore_header.dart';
import '../widgets/explore_map_placeholder.dart';
import '../widgets/explore_result_header.dart';
import '../widgets/explore_search_field.dart';
import '../widgets/explore_states.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategory = 0;
  bool _showMap = false;

  static const List<ExploreCategory> _categories = [
    ExploreCategory(label: 'Nearby', icon: Icons.near_me_outlined),
    ExploreCategory(label: 'Quiet', icon: Icons.volume_down_outlined),
    ExploreCategory(label: 'Work', icon: Icons.laptop_mac_outlined),
    ExploreCategory(label: 'Study', icon: Icons.menu_book_outlined),
    ExploreCategory(label: 'Hangout', icon: Icons.people_outline_rounded),
    ExploreCategory(label: '24 Hours', icon: Icons.schedule_rounded),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CafeSummary> _filterCafes(List<CafeSummary> cafes) {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return cafes;
    }

    return cafes.where((cafe) {
      final name = cafe.name.toLowerCase();
      final category = cafe.category.toLowerCase();

      return name.contains(query) || category.contains(query);
    }).toList();
  }

  void _openCafe(CafeSummary cafe) {
    context.push(AppRoutes.cafeDetailPath(cafe.id));
  }

  @override
  Widget build(BuildContext context) {
    final cafesAsync = ref.watch(cafesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(child: ExploreHeader()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: ExploreSearchField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  onFilterPressed: () {
                    // TODO: Open advanced filter sheet.
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
            SliverToBoxAdapter(
              child: ExploreCategorySelector(
                categories: _categories,
                selectedIndex: _selectedCategory,
                onSelected: (index) {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
              ),
            ),
            ...cafesAsync.when(
              data: (allCafes) {
                final cafes = _filterCafes(allCafes);

                return [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: ExploreResultHeader(
                        resultCount: cafes.length,
                        showMap: _showMap,
                        onViewChanged: (showMap) {
                          setState(() {
                            _showMap = showMap;
                          });
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  if (_showMap)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverToBoxAdapter(
                        child: ExploreMapPlaceholder(
                          cafes: cafes,
                          onCafeTap: _openCafe,
                        ),
                      ),
                    )
                  else if (cafes.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: ExploreEmptySearch(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final cafe = cafes[index];

                          return CafeListItem(
                            cafe: cafe,
                            showDivider: index != cafes.length - 1,
                            onTap: () {
                              _openCafe(cafe);
                            },
                            onSaved: () {
                              // TODO: Auth guard + favorite.
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
                    child: ExploreLoadingState(),
                  ),
                ];
              },
              error: (error, stackTrace) {
                return [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ExploreErrorState(
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
