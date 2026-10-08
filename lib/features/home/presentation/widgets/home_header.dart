import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/cafeloca_brand.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
