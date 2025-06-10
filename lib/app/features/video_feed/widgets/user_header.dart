import 'package:flutter/material.dart';
import 'package:tiktok/app/features/video_feed/widgets/follow_button.dart';
import 'package:tiktok/app/presentation/theme/colors.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.profileImageUrl,
    required this.username,
  });

  final String profileImageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=800",
          ),
        ),
        Text(
          username,
          style: const TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const FollowButton(),
      ],
    );
  }
}
