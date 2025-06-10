import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/app/core/di/dependency_injector.dart';
import 'package:tiktok/app/core/init/router/app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
      ),
    );
  }
}
