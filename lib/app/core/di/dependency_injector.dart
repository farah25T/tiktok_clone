import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok/app/core/data_sources/auth_data_source.dart';
import 'package:tiktok/app/core/data_sources/reaction_data_source.dart';
import 'package:tiktok/app/core/data_sources/video_feed_data_source.dart';
import 'package:tiktok/app/core/init/router/app_router.dart';
import 'package:tiktok/app/core/repositories/auth_repo.dart';
import 'package:tiktok/app/core/repositories/reaction_repo.dart';
import 'package:tiktok/app/core/repositories/video_feed_repo.dart';
import 'package:tiktok/app/domain/data_sources/i_auth_data_source.dart';
import 'package:tiktok/app/domain/data_sources/i_reaction_data_source.dart';
import 'package:tiktok/app/domain/data_sources/i_video_feed_data_source.dart';
import 'package:tiktok/app/domain/repositories/i_auth_repo.dart';
import 'package:tiktok/app/domain/repositories/i_reaction_repo.dart';
import 'package:tiktok/app/domain/repositories/i_video_feed_repo.dart';

final getIt = GetIt.instance;

/// Call this once after `Firebase.initializeApp()`.
///
/// Set [includeRouter] to **true** in the real app,
/// false/omitted in tooling scripts (e.g. seed_videos.dart).
Future<void> setupDependencies({bool includeRouter = false}) async {
  _registerLazy<FirebaseFirestore>(() => FirebaseFirestore.instance);
  _registerLazy<FirebaseAuth>(() => FirebaseAuth.instance);
  _registerLazy<FirebaseStorage>(() => FirebaseStorage.instance);
  _registerLazy<IVideoFeedDataSource>(
    () => VideoFeedDataSource(getIt<FirebaseFirestore>()),
  );
  _registerLazy<IVideoFeedRepository>(
    () => VideoFeedRepository(getIt<IVideoFeedDataSource>()),
  );
  _registerLazy<IAuthDataSource>(() => AuthDataSource(getIt<FirebaseAuth>()));
  _registerLazy<IAuthRepository>(
    () => AuthRepository(getIt<IAuthDataSource>()),
  );
  _registerLazy<IReactionDataSource>(
    () => ReactionDataSource(getIt<FirebaseFirestore>()),
  );
  _registerLazy<IReactionRepository>(
    () => ReactionRepository(
      getIt<IReactionDataSource>(),
      getIt<FirebaseAuth>().currentUser?.uid ?? '',
    ),
  );

  if (includeRouter) {
    _registerSingletonOnce(AppRouter());
  }
}

void _registerLazy<T extends Object>(T Function() factory) {
  if (!getIt.isRegistered<T>()) getIt.registerLazySingleton(factory);
}

void _registerSingletonOnce<T extends Object>(T instance) {
  if (!getIt.isRegistered<T>()) getIt.registerSingleton(instance);
}
