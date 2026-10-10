import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/utils/auth_navigation.dart';
import '../providers/saved_cafes_provider.dart';

abstract final class FavoriteAction {
  static Future<void> toggle({
    required BuildContext context,
    required WidgetRef ref,
    required String cafeId,
    String? returnPath,
  }) async {
    final authState = ref.read(authProvider);

    if (authState.isGuest) {
      context.push(AuthNavigation.loginPath(from: returnPath));
      return;
    }

    try {
      await ref.read(savedCafesProvider.notifier).toggle(cafeId);
    } catch (error) {
      if (!context.mounted) return;

      final message = error is StateError
          ? error.message.toString()
          : 'Could not update your favorites. Please try again.';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
