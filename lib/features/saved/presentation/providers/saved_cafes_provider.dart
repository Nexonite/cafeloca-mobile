import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/providers/supabase_provider.dart';
import '../../data/repositories/supabase_favorites_repository.dart';

enum SavedSyncStatus { idle, loading, ready, error }

class SavedSyncState {
  const SavedSyncState({
    this.status = SavedSyncStatus.idle,
    this.pendingIds = const {},
    this.message,
  });

  final SavedSyncStatus status;
  final Set<String> pendingIds;
  final String? message;

  bool get isLoading => status == SavedSyncStatus.loading;
}

class SavedSyncNotifier extends Notifier<SavedSyncState> {
  @override
  SavedSyncState build() => const SavedSyncState();

  void update(SavedSyncState value) {
    state = value;
  }
}

final savedSyncProvider = NotifierProvider<SavedSyncNotifier, SavedSyncState>(
  SavedSyncNotifier.new,
);

final favoritesRepositoryProvider = Provider<SupabaseFavoritesRepository>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);

  return SupabaseFavoritesRepository(client);
});

class SavedCafesNotifier extends Notifier<Set<String>> {
  late supabase.SupabaseClient _client;
  late SupabaseFavoritesRepository _repository;

  StreamSubscription<supabase.AuthState>? _subscription;

  String? _activeUserId;
  int _generation = 0;
  final Set<String> _pendingIds = {};

  @override
  Set<String> build() {
    _client = ref.watch(supabaseClientProvider);
    _repository = ref.watch(favoritesRepositoryProvider);

    _subscription?.cancel();

    _activeUserId = _client.auth.currentUser?.id;

    _subscription = _client.auth.onAuthStateChange.listen((event) {
      final nextUserId = event.session?.user.id;

      if (nextUserId != _activeUserId) {
        _switchUser(nextUserId);
      }
    });

    ref.onDispose(() {
      _generation++;
      _subscription?.cancel();
    });

    if (_activeUserId != null) {
      Future.microtask(() {
        if (ref.mounted) {
          load();
        }
      });
    }

    return <String>{};
  }

  bool isSaved(String cafeId) => state.contains(cafeId);

  void _setSync({required SavedSyncStatus status, String? message}) {
    if (!ref.mounted) return;

    ref
        .read(savedSyncProvider.notifier)
        .update(
          SavedSyncState(
            status: status,
            pendingIds: {..._pendingIds},
            message: message,
          ),
        );
  }

  void _switchUser(String? userId) {
    _generation++;
    _activeUserId = userId;
    _pendingIds.clear();
    state = <String>{};

    _setSync(status: SavedSyncStatus.idle);

    if (userId != null) {
      unawaited(load());
    }
  }

  Future<void> load() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) {
      _switchUser(null);
      return;
    }

    if (userId != _activeUserId) {
      _activeUserId = userId;
      _generation++;
      state = <String>{};
    }

    final requestGeneration = ++_generation;

    _setSync(status: SavedSyncStatus.loading);

    try {
      final favorites = await _repository.getFavoriteCafeIds(userId);

      if (!ref.mounted ||
          requestGeneration != _generation ||
          _client.auth.currentUser?.id != userId) {
        return;
      }

      state = favorites;
      _setSync(status: SavedSyncStatus.ready);
    } catch (_) {
      if (!ref.mounted ||
          requestGeneration != _generation ||
          _client.auth.currentUser?.id != userId) {
        return;
      }

      _setSync(
        status: SavedSyncStatus.error,
        message: 'Could not load your saved cafés.',
      );
    }
  }

  Future<void> toggle(String cafeId) async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null || userId != _activeUserId) {
      throw StateError('Please sign in to save cafés.');
    }

    final syncState = ref.read(savedSyncProvider);

    if (syncState.status != SavedSyncStatus.ready) {
      throw StateError('Saved cafés are still syncing. Please try again.');
    }

    if (_pendingIds.contains(cafeId)) {
      return;
    }

    final wasSaved = state.contains(cafeId);
    final requestGeneration = _generation;

    _pendingIds.add(cafeId);
    _setSync(status: SavedSyncStatus.ready);

    try {
      if (wasSaved) {
        await _repository.removeFavorite(userId: userId, cafeId: cafeId);
      } else {
        await _repository.addFavorite(userId: userId, cafeId: cafeId);
      }

      if (!ref.mounted ||
          requestGeneration != _generation ||
          _client.auth.currentUser?.id != userId) {
        return;
      }

      if (wasSaved) {
        state = {...state}..remove(cafeId);
      } else {
        state = {...state, cafeId};
      }
    } finally {
      if (ref.mounted && requestGeneration == _generation) {
        _pendingIds.remove(cafeId);
        _setSync(status: SavedSyncStatus.ready);
      }
    }
  }

  void clear() {
    _generation++;
    _pendingIds.clear();
    state = <String>{};

    _activeUserId = _client.auth.currentUser?.id;

    _setSync(status: SavedSyncStatus.idle);

    // Called by AuthNotifier when authentication changes.
    // Only local state is cleared. Database rows remain intact.
    if (_activeUserId != null) {
      Future.microtask(() {
        if (ref.mounted) {
          unawaited(load());
        }
      });
    }
  }
}

final savedCafesProvider = NotifierProvider<SavedCafesNotifier, Set<String>>(
  SavedCafesNotifier.new,
);
