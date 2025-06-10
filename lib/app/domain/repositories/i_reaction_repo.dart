abstract class IReactionRepository {
  Future<String?> getMyReaction(String videoId);
  Future<void> setReaction(String videoId, String? type);
}
