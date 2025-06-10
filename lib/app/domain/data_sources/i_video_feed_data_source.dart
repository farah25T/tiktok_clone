import 'package:tiktok/app/domain/models/video_item.dart';

abstract class IVideoFeedDataSource {
  Future<List<VideoItem>> fetchVideos();

  Future<List<VideoItem>> fetchMoreVideos();
}
