import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok/app/domain/data_sources/i_reaction_data_source.dart';

class ReactionDataSource implements IReactionDataSource {
  final FirebaseFirestore _firestore;
  ReactionDataSource(this._firestore);

  @override
  Future<String?> fetchMyReaction({
    required String videoId,
    required String uid,
  }) async {
    final snap = await _firestore
        .collection('videos')
        .doc(videoId)
        .collection('reactions')
        .doc(uid)
        .get();
    return snap.exists ? snap.data()!['type'] as String : null;
  }

  @override
  Future<void> setMyReaction({
    required String videoId,
    required String uid,
    required String? type,
  }) {
    print('Setting reaction for video $videoId by user $uid with type $type');
    final videoRef = _firestore.collection('videos').doc(videoId);
    final reactionRef = videoRef.collection('reactions').doc(uid);

    return _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(reactionRef);
      final oldType = existing.exists
          ? existing.data()!['type'] as String
          : null;

      if (oldType != null) {
        transaction.update(videoRef, {
          oldType == 'like' ? 'likes' : 'dislikes': FieldValue.increment(-1),
        });
      }

      // apply new
      if (type != null) {
        transaction.set(reactionRef, {
          'type': type,
          'reactedAt': FieldValue.serverTimestamp(),
        });
        transaction.update(videoRef, {
          type == 'like' ? 'likes' : 'dislikes': FieldValue.increment(1),
        });
      } else {
        transaction.delete(reactionRef);
      }
    });
  }
}
