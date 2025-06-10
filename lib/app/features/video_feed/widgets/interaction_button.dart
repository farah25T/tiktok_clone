import 'package:flutter/material.dart';
import 'package:tiktok/app/presentation/theme/colors.dart';

class InteractionButton extends StatelessWidget {
  const InteractionButton({
    super.key,
    required this.icon,
    required this.count,
    this.color = white,
    this.onTap,
  });

  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                color: white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
