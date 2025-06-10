import 'package:tiktok/app/domain/models/video_item.dart';

abstract class IVideoFeedRepository {
  Future<List<VideoItem>> fetchVideos();

  Future<List<VideoItem>> fetchMoreVideos();
}
