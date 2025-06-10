import 'package:flutter/material.dart';
import 'package:tiktok/app/domain/models/video_item.dart';
import 'package:tiktok/app/features/video_feed/widgets/optimized_video_player.dart';
import 'package:tiktok/app/features/video_feed/widgets/video_overlay_section.dart';
import 'package:video_player/video_player.dart';

class VideoFeedItem extends StatelessWidget {
  const VideoFeedItem({
    super.key,
    required this.videoItem,
    required this.controller,
  });

  final VideoItem videoItem;
  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OptimizedVideoPlayer(controller: controller, videoId: videoItem.id),
        VideoOverlaySection(
          dislikeCount: videoItem.dislikes,
          videoId: videoItem.id,
          profileImageUrl: '',
          username: 'test_user',
          description: 'This is a sample video description.',
          isBookmarked: false,
          likeCount: videoItem.likes,
          commentCount: videoItem.dislikes,
          shareCount: 12,
        ),
      ],
    );
  }
}
