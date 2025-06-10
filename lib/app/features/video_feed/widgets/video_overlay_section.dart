import 'package:flutter/material.dart';
import 'package:tiktok/app/features/video_feed/widgets/interaction_buttons.dart';
import 'package:tiktok/app/features/video_feed/widgets/user_info_section.dart';

class VideoOverlaySection extends StatelessWidget {
  const VideoOverlaySection({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.description,
    required this.isBookmarked,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.videoId,
    required this.dislikeCount,
  });

  final String profileImageUrl;
  final String username;
  final String description;
  final bool isBookmarked;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int dislikeCount;
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          UserInfoSection(
            profileImageUrl: profileImageUrl,
            username: username,
            description: description,
          ),
          InteractionButtons(
            dislikeCount: dislikeCount,
            videoId: videoId,
            isBookmarked: isBookmarked,
            likeCount: likeCount,
            commentCount: commentCount,
            shareCount: shareCount,
          ),
        ],
      ),
    );
  }
}
