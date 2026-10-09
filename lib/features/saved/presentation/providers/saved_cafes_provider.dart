import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedCafesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  bool isSaved(String cafeId) => state.contains(cafeId);

  void toggle(String cafeId) {
    if (state.contains(cafeId)) {
      state = {...state}..remove(cafeId);
    } else {
      state = {...state, cafeId};
    }
  }

  void clear() {
    state = <String>{};
  }
}

final savedCafesProvider = NotifierProvider<SavedCafesNotifier, Set<String>>(
  SavedCafesNotifier.new,
);
