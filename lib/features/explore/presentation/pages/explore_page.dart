import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../cafe/data/cafe_dummy_data.dart';
import '../../../cafe/domain/models/cafe_summary.dart';
import '../../../cafe/presentation/widgets/cafe_list_item.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategory = 0;
  bool _showMap = false;

  final List<CafeSummary> _cafes = CafeDummyData.cafes;

  static const List<_ExploreCategory> _categories = [
    _ExploreCategory(label: 'Nearby', icon: Icons.near_me_outlined),
    _ExploreCategory(label: 'Quiet', icon: Icons.volume_down_outlined),
    _ExploreCategory(label: 'Work', icon: Icons.laptop_mac_outlined),
    _ExploreCategory(label: 'Study', icon: Icons.menu_book_outlined),
    _ExploreCategory(label: 'Hangout', icon: Icons.people_outline_rounded),
    _ExploreCategory(label: '24 Hours', icon: Icons.schedule_rounded),
  ];

  List<CafeSummary> get _filteredCafes {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _cafes;
    }

    return _cafes.where((cafe) {
      final name = cafe.name.toLowerCase();
      final category = cafe.category.toLowerCase();

      return name.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCafe(CafeSummary cafe) {
    context.push(AppRoutes.cafeDetailPath(cafe.id));
  }

  @override
  Widget build(BuildContext context) {
    final cafes = _filteredCafes;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(child: _ExploreHeader()),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _SearchField(
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
              child: _CategorySelector(
                categories: _categories,
                selectedIndex: _selectedCategory,
                onSelected: (index) {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ResultHeader(
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
                  child: _MapPlaceholder(cafes: cafes, onCafeTap: _openCafe),
                ),
              )
            else if (cafes.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptySearch(),
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
          ],
        ),
      ),
    );
  }
}

class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore',
          style: AppTypography.heading1.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 5),
        Text(
          'Find a café for your next moment.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.body.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search café, area, or vibe',
        hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 21,
          color: AppColors.textSecondary,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.text.isNotEmpty)
              IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.textTertiary,
              ),
            IconButton(
              tooltip: 'Filters',
              onPressed: onFilterPressed,
              icon: const Icon(Icons.tune_rounded, size: 19),
              color: AppColors.textPrimary,
            ),
          ],
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.espresso),
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_ExploreCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = index == selectedIndex;

          return InkWell(
            onTap: () {
              onSelected(index);
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: selected ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? AppColors.textPrimary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    size: 15,
                    color: selected
                        ? AppColors.surface
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: AppTypography.tiny.copyWith(
                      color: selected
                          ? AppColors.surface
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({
    required this.resultCount,
    required this.showMap,
    required this.onViewChanged,
  });

  final int resultCount;
  final bool showMap;
  final ValueChanged<bool> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover cafés',
                style: AppTypography.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$resultCount ${resultCount == 1 ? 'place' : 'places'} found',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        _ViewSwitcher(showMap: showMap, onChanged: onViewChanged),
      ],
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({required this.showMap, required this.onChanged});

  final bool showMap;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewButton(
            icon: Icons.format_list_bulleted_rounded,
            selected: !showMap,
            tooltip: 'List',
            onTap: () {
              onChanged(false);
            },
          ),
          _ViewButton(
            icon: Icons.map_outlined,
            selected: showMap,
            tooltip: 'Map',
            onTap: () {
              onChanged(true);
            },
          ),
        ],
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.icon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 34,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.textPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            size: 17,
            color: selected ? AppColors.surface : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.cafes, required this.onCafeTap});

  final List<CafeSummary> cafes;
  final ValueChanged<CafeSummary> onCafeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColors.surfaceSoft,
              child: CustomPaint(painter: _MapBackgroundPainter()),
            ),
          ),

          const Positioned(top: 26, left: 34, child: _FakeMapPin()),

          const Positioned(top: 112, right: 54, child: _FakeMapPin()),

          const Positioned(
            top: 186,
            left: 106,
            child: _FakeMapPin(selected: true),
          ),

          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: cafes.isEmpty
                  ? Text(
                      'No cafés match your search.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        onCafeTap(cafes.first);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: SizedBox(
                              width: 58,
                              height: 58,
                              child: cafes.first.imagePath != null
                                  ? Image.asset(
                                      cafes.first.imagePath!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: AppColors.surfaceSoft,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.local_cafe_outlined,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cafes.first.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.title.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${cafes.first.rating.toStringAsFixed(1)}  •  ${cafes.first.distance}',
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
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeMapPin extends StatelessWidget {
  const _FakeMapPin({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: selected ? 38 : 32,
      height: selected ? 38 : 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.espresso : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.espresso : AppColors.border,
        ),
      ),
      child: Icon(
        Icons.local_cafe_rounded,
        size: selected ? 17 : 15,
        color: selected ? AppColors.surface : AppColors.textPrimary,
      ),
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final secondaryRoadPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(-20, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.12,
        size.width * 0.58,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.48,
        size.width + 20,
        size.height * 0.30,
      );

    final path2 = Path()
      ..moveTo(size.width * 0.22, -20)
      ..quadraticBezierTo(
        size.width * 0.36,
        size.height * 0.30,
        size.width * 0.24,
        size.height + 20,
      );

    final path3 = Path()
      ..moveTo(size.width * 0.72, -20)
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.36,
        size.width * 0.78,
        size.height + 20,
      );

    final path4 = Path()
      ..moveTo(-20, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.36,
        size.height * 0.50,
        size.width + 20,
        size.height * 0.70,
      );

    canvas.drawPath(path1, roadPaint);
    canvas.drawPath(path2, secondaryRoadPaint);
    canvas.drawPath(path3, secondaryRoadPaint);
    canvas.drawPath(path4, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 60, 32, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 26,
              color: AppColors.textTertiary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'No cafés found',
            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
          ),

          const SizedBox(height: 6),

          Text(
            'Try another café name, area, or vibe.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ExploreCategory {
  const _ExploreCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
