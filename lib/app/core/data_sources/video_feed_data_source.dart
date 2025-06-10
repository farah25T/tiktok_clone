import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok/app/domain/data_sources/i_video_feed_data_source.dart';
import 'package:tiktok/app/domain/models/video_item.dart';

class VideoFeedDataSource extends IVideoFeedDataSource {
  VideoFeedDataSource(this._firestore);

  final FirebaseFirestore _firestore;
  DocumentSnapshot? _lastDocument;

  @override
  Future<List<VideoItem>> fetchVideos({int limit = 2}) async {
    _lastDocument = null;
    print('Fetching initial videos with limit: $limit');
    return _fetch(limit: limit);
  }

  @override
  Future<List<VideoItem>> fetchMoreVideos({int limit = 2}) async {
    if (_lastDocument == null) return [];
    return _fetch(startAfter: _lastDocument, limit: limit);
  }

  Future<List<VideoItem>> _fetch({
    DocumentSnapshot? startAfter,
    required int limit,
  }) async {
    try {
      Query query = _firestore.collection('videos').limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      print('Fetched ${snapshot.size} docs');

      if (snapshot.docs.isEmpty) return [];

      _lastDocument = snapshot.docs.last;

      final items = <VideoItem>[];
      for (final doc in snapshot.docs) {
        try {
          final item = VideoItem.fromFirestore(doc);
          print('helllooooo $item');
          items.add(item);
        } catch (e) {
          print('VideoItem parse error: $e');
        }
      }

      return items;
    } catch (e, st) {
      print('Firestore error: $e\n$st');
      rethrow;
    }
  }
}
