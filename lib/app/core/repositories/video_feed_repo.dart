import 'package:tiktok/app/domain/data_sources/i_video_feed_data_source.dart';
import 'package:tiktok/app/domain/models/video_item.dart';
import 'package:tiktok/app/domain/repositories/i_video_feed_repo.dart';

class VideoFeedRepository implements IVideoFeedRepository {
  VideoFeedRepository(this._remote);

  final IVideoFeedDataSource _remote;

  @override
  Future<List<VideoItem>> fetchVideos() async {
    try {
      return await _remote.fetchVideos();
    } catch (e) {
      throw Exception('Failed to fetch videos: $e');
    }
  }

  @override
  Future<List<VideoItem>> fetchMoreVideos() async {
    try {
      return await _remote.fetchMoreVideos();
    } catch (e) {
      throw Exception('Failed to fetch more videos: $e');
    }
  }
}
