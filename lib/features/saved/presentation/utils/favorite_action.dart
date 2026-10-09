import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/utils/auth_navigation.dart';
import '../providers/saved_cafes_provider.dart';

abstract final class FavoriteAction {
  static void toggle({
    required BuildContext context,
    required WidgetRef ref,
    required String cafeId,
    String? returnPath,
  }) {
    final authState = ref.read(authProvider);

    if (authState.isGuest) {
      context.push(AuthNavigation.loginPath(from: returnPath));
      return;
    }

    ref.read(savedCafesProvider.notifier).toggle(cafeId);
  }
}
