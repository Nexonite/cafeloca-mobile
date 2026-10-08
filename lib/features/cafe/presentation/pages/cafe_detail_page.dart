import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cafe_providers.dart';
import '../widgets/cafe_detail_content.dart';
import '../widgets/cafe_detail_states.dart';

class CafeDetailPage extends ConsumerWidget {
  const CafeDetailPage({super.key, required this.cafeId});

  final String cafeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cafeAsync = ref.watch(cafeDetailProvider(cafeId));

    return cafeAsync.when(
      data: (cafe) {
        if (cafe == null) {
          return const CafeDetailNotFoundPage();
        }

        return CafeDetailContent(cafe: cafe);
      },
      loading: () => const CafeDetailLoadingPage(),
      error: (error, stackTrace) {
        return CafeDetailErrorPage(
          onRetry: () {
            ref.invalidate(cafeDetailProvider(cafeId));
          },
        );
      },
    );
  }
}
