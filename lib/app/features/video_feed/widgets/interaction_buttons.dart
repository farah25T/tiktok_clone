import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tiktok/app/core/constants/enums/router_enum.dart';
import 'package:tiktok/app/core/providers/auth_provider.dart';
import 'package:tiktok/app/features/video_feed/state/reaction_provider.dart';
import 'package:tiktok/app/features/video_feed/widgets/interaction_button.dart';
import 'package:tiktok/app/presentation/theme/colors.dart';

class InteractionButtons extends ConsumerWidget {
  const InteractionButtons({
    super.key,
    required this.videoId,
    required this.isBookmarked,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    required this.shareCount,
  });

  final String videoId;
  final bool isBookmarked;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final int shareCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedProvider);
    final reactionState = ref.watch(reactionProvider(videoId));
    final myReaction = reactionState.maybeWhen(
      data: (r) => r,
      orElse: () => null,
    );
    final isLiked = myReaction == 'like';
    final isDisliked = myReaction == 'dislike';
    final isBusy = reactionState is AsyncLoading;

    final displayedLikeCount = isLiked ? likeCount + 1 : likeCount;
    final displayedDislikeCount = isDisliked ? dislikeCount + 1 : dislikeCount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InteractionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            count: displayedLikeCount,
            color: isLiked ? red : white,
            onTap: () {
              if (isBusy) return;
              if (!isConnected) {
                context.pushNamed(RouterEnum.registerView.name);
              } else {
                ref.read(reactionProvider(videoId).notifier).toggleLike();
              }
            },
          ),
          const SizedBox(height: 20),

          // Dislike button
          InteractionButton(
            icon: isDisliked ? Icons.thumb_down : Icons.thumb_down_off_alt,
            count: displayedDislikeCount,
            onTap: () {
              if (isBusy) return;
              if (!isConnected) {
                context.pushNamed(RouterEnum.registerView.name);
              } else {
                ref.read(reactionProvider(videoId).notifier).toggleDislike();
              }
            },
          ),
          const SizedBox(height: 20),

          // Comment button
          InteractionButton(
            icon: LucideIcons.messageCircle,
            count: 0,
            onTap: () {},
          ),
          const SizedBox(height: 20),

          // Share button
          InteractionButton(
            icon: LucideIcons.send,
            count: shareCount,
            onTap: () {},
          ),
          const SizedBox(height: 20),

          // Bookmark button
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              if (!isConnected) {
                context.pushNamed(RouterEnum.registerView.name);
              } else {}
            },
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
