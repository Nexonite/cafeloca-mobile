import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../cafe/domain/models/cafe_summary.dart';

class ExploreMapPlaceholder extends StatelessWidget {
  const ExploreMapPlaceholder({
    super.key,
    required this.cafes,
    required this.onCafeTap,
  });

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
