import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

enum CafelocaBrandSize { small, medium, large, splash }

class CafelocaBrand extends StatelessWidget {
  const CafelocaBrand({
    super.key,
    this.size = CafelocaBrandSize.medium,
    this.alignment = MainAxisAlignment.start,
    this.showName = true,
    this.color,
  });

  final CafelocaBrandSize size;
  final MainAxisAlignment alignment;
  final bool showName;
  final Color? color;

  double get _markSize {
    switch (size) {
      case CafelocaBrandSize.small:
        return 30;
      case CafelocaBrandSize.medium:
        return 36;
      case CafelocaBrandSize.large:
        return 42;
      case CafelocaBrandSize.splash:
        return 56;
    }
  }

  double get _fontSize {
    switch (size) {
      case CafelocaBrandSize.small:
        return 17;
      case CafelocaBrandSize.medium:
        return 21;
      case CafelocaBrandSize.large:
        return 24;
      case CafelocaBrandSize.splash:
        return 28;
    }
  }

  double get _gap {
    switch (size) {
      case CafelocaBrandSize.small:
        return 9;
      case CafelocaBrandSize.medium:
        return 11;
      case CafelocaBrandSize.large:
        return 12;
      case CafelocaBrandSize.splash:
        return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = color ?? AppColors.textPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/branding/cafeloca_mark.png',
          width: _markSize,
          height: _markSize,
          fit: BoxFit.contain,
        ),

        if (showName) ...[
          SizedBox(width: _gap),

          Text(
            'cafeloca',
            style: AppTypography.heading2.copyWith(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
              height: 1,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ],
    );
  }
}
