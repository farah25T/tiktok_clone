abstract class IReactionDataSource {
  Future<String?> fetchMyReaction({
    required String videoId,
    required String uid,
  });

  Future<void> setMyReaction({
    required String videoId,
    required String uid,
    required String? type,
  });
}
