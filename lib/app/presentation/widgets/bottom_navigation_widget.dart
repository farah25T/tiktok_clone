import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/app/core/constants/enums/router_enum.dart';
import 'package:tiktok/app/presentation/theme/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({
    super.key,
    this.child,
    required this.location,
    this.backgroundColor,
  });

  final Widget? child;
  final String location;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      backgroundColor: backgroundColor,
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(splashColor: transparent, highlightColor: transparent),
        child: BottomNavigationBar(
          key: ValueKey(location),
          currentIndex: _calculateSelectedIndex(context),
          selectedItemColor: black,
          unselectedItemColor: black54,
          onTap: (index) => _onItemTapped(index, context),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            const BottomNavigationBarItem(
              label: '',
              icon: Icon(LucideIcons.home, size: 28),
              activeIcon: Icon(LucideIcons.home, size: 28),
            ),
            const BottomNavigationBarItem(
              label: '',
              icon: Icon(LucideIcons.video, size: 28),
              activeIcon: Icon(LucideIcons.video, size: 28),
            ),
            const BottomNavigationBarItem(
              label: '',
              icon: Icon(LucideIcons.userCircle, size: 28),
              activeIcon: Icon(LucideIcons.userCircle, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

int _calculateSelectedIndex(BuildContext context) {
  final String location = GoRouterState.of(context).uri.toString();

  if (location == RouterEnum.dashboardView.routeName) {
    return 0;
  }
  if (location == RouterEnum.videoFeedView.routeName) {
    return 1;
  }
  if (location == RouterEnum.profileView.routeName) {
    return 2;
  }
  return 0;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      GoRouter.of(context).go(RouterEnum.dashboardView.routeName);
      break;
    case 1:
      GoRouter.of(context).go(RouterEnum.videoFeedView.routeName);
      break;
    case 2:
      GoRouter.of(context).go(RouterEnum.profileView.routeName);
      break;
  }
}
