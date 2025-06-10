import 'package:tiktok/app/domain/data_sources/i_reaction_data_source.dart';
import 'package:tiktok/app/domain/repositories/i_reaction_repo.dart';

class ReactionException implements Exception {
  final String message;
  ReactionException(this.message);
  @override
  String toString() => 'ReactionException: $message';
}

class ReactionRepository implements IReactionRepository {
  final IReactionDataSource _remote;
  final String _uid;

  ReactionRepository(this._remote, this._uid);

  @override
  Future<String?> getMyReaction(String videoId) {
    return _remote.fetchMyReaction(videoId: videoId, uid: _uid);
  }

  @override
  Future<void> setReaction(String videoId, String? type) {
    return _remote.setMyReaction(videoId: videoId, uid: _uid, type: type);
  }
}
