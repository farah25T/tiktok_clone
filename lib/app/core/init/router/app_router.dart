import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tiktok/app/core/constants/enums/router_enum.dart';
import 'package:tiktok/app/core/init/router/custom_page_builder_widget.dart';
import 'package:tiktok/app/features/authentication/screens/login_view.dart';

import 'package:tiktok/app/features/dashboard/dashboard_view.dart';
import 'package:tiktok/app/features/profile/screens/profile_screen.dart';
import 'package:tiktok/app/features/video_feed/views/video_feed_view.dart';
import 'package:tiktok/app/features/authentication/screens/register_view.dart';

import 'package:tiktok/app/presentation/theme/colors.dart';
import 'package:tiktok/app/presentation/widgets/bottom_navigation_widget.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// lib/app/core/init/router/app_router.dart
// …imports…

class AppRouter {
  late final GoRouter router;
  AppRouter() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RouterEnum.dashboardView.routeName,
      routes: [
        // ───────── standalone screens (root) ─────────
        GoRoute(
          path: RouterEnum.registerView.routeName, // '/register'
          name: RouterEnum.registerView.name,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (c, s) =>
              customPageBuilderWidget(c, s, const RegisterView()),
        ),
        GoRoute(
          path: RouterEnum.loginView.routeName, // '/login'  ← NEW
          name: RouterEnum.loginView.name,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (c, s) =>
              customPageBuilderWidget(c, s, const LoginView()),
        ),

        // ───────── bottom-nav shell (feed, dashboard, profile) ─────────
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (c, s, child) => BottomNavigationWidget(
            location: s.uri.toString(),
            backgroundColor:
                s.uri.toString() == RouterEnum.videoFeedView.routeName
                ? black
                : null,
            child: child,
          ),
          routes: [
            GoRoute(
              path: RouterEnum.dashboardView.routeName,
              name: RouterEnum.dashboardView.name,
              pageBuilder: (c, s) =>
                  customPageBuilderWidget(c, s, const DashboardView()),
            ),
            GoRoute(
              path: RouterEnum.videoFeedView.routeName,
              name: RouterEnum.videoFeedView.name,
              pageBuilder: (c, s) =>
                  customPageBuilderWidget(c, s, const VideoFeedView()),
            ),
            GoRoute(
              path: RouterEnum.profileView.routeName,
              name: RouterEnum.profileView.name,
              pageBuilder: (c, s) =>
                  customPageBuilderWidget(c, s, const ProfileView()),
            ),
          ],
        ),
      ],
    );
  }
}
