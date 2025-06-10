import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok/app/domain/repositories/i_reaction_repo.dart';

class ReactionNotifier extends StateNotifier<AsyncValue<String?>> {
  final String videoId;
  final IReactionRepository _repo;

  ReactionNotifier(this.videoId, this._repo)
    : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final type = await _repo.getMyReaction(videoId);
      state = AsyncValue.data(type);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleLike() => _toggle('like');
  Future<void> toggleDislike() => _toggle('dislike');

  Future<void> _toggle(String newType) async {
    print("Toggling reaction: $newType for video: $videoId");
    final current = state.value;
    final target = current == newType ? null : newType;
    state = const AsyncValue.loading();
    try {
      await _repo.setReaction(videoId, target);
      state = AsyncValue.data(target);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final reactionRepositoryProvider = Provider<IReactionRepository>((ref) {
  return GetIt.instance<IReactionRepository>();
});

final reactionProvider =
    StateNotifierProvider.family<ReactionNotifier, AsyncValue<String?>, String>(
      (ref, videoId) {
        final repo = ref.watch(reactionRepositoryProvider);
        return ReactionNotifier(videoId, repo);
      },
    );
