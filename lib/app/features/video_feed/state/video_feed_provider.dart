import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tiktok/app/domain/repositories/i_video_feed_repo.dart';
import 'package:tiktok/app/features/video_feed/state/video_feed_state.dart';

final _getIt = GetIt.instance;

final videoFeedRepositoryProvider = Provider<IVideoFeedRepository>(
  (ref) => _getIt<IVideoFeedRepository>(),
);

class VideoFeedNotifier extends StateNotifier<VideoFeedState> {
  VideoFeedNotifier(this._repo) : super(VideoFeedState.initial()) {
    _loadVideos();
  }

  final IVideoFeedRepository _repo;

  final _preloadQueue = Queue<String>();
  final _preloadedFiles = <String, File>{};
  bool _isPreloadingMore = false;

  Future<void> loadMoreVideos() async {
    if (state.isPaginating || !state.hasMoreVideos) return;
    state = state.copyWith(isPaginating: true);

    try {
      if (state.videos.isNotEmpty) {
        final more = await _repo.fetchMoreVideos();
        final hasMore = more.length == 2;
        state = state.copyWith(
          videos: [...state.videos, ...more],
          isPaginating: false,
          hasMoreVideos: hasMore,
        );
        _preloadNextVideos();
      }
    } catch (e) {
      state = state.copyWith(isPaginating: false, error: e.toString());
    }
  }

  void onPageChanged(int newIndex) async {
    state = state.copyWith(currentVideoIndex: newIndex);
    _preloadNextVideos();

    if (!_isPreloadingMore &&
        state.hasMoreVideos &&
        newIndex >= state.videos.length - 2) {
      _isPreloadingMore = true;
      await loadMoreVideos();
      _isPreloadingMore = false;
    }
  }

  Future<void> _loadVideos() async {
    state = state.copyWith(isLoading: true);
    try {
      final videos = await _repo.fetchVideos();
      final hasMore = videos.length == 2;
      state = state.copyWith(
        isLoading: false,
        videos: videos,
        hasMoreVideos: hasMore,
        currentVideoIndex: 0,
      );
      if (videos.isNotEmpty) _preloadNextVideos();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _preloadNextVideos() async {
    if (state.videos.isEmpty) return;

    final currentIndex = state.currentVideoIndex;
    final urls = state.videos
        .skip(currentIndex + 1)
        .take(2)
        .map((v) => v.url)
        .where((u) => !_preloadedFiles.containsKey(u));
    for (final url in urls) {
      if (!_preloadQueue.contains(url)) {
        _preloadQueue.add(url);

        _preloadVideo(url);
      }
    }
  }

  Future<void> _preloadVideo(String url) async {
    try {
      final file = await _getCachedFile(url);
      _preloadedFiles[url] = file;
      state = state.copyWith(
        preloadedVideoUrls: {...state.preloadedVideoUrls, url},
      );
    } catch (e) {
      debugPrint('Error preloading video: $e');
    } finally {
      _preloadQueue.remove(url);
    }
  }

  Future<File> _getCachedFile(String url) async {
    final cached = _preloadedFiles[url];
    if (cached != null) {
      debugPrint('✅ RAM cache → $url');
      return cached;
    }

    final cache = DefaultCacheManager();

    try {
      final info = await cache.getFileFromCache(url);
      debugPrint('🗂️  Disk cache info → $info');

      final file = info?.file ?? await cache.getSingleFile(url);
      _preloadedFiles[url] = file;

      debugPrint('📥 Saved $url → ${file.path}');
      return file;
    } on HttpException catch (e, st) {
      debugPrint('🚫 HTTP error ($e) while fetching $url\n$st');
      rethrow;
    } on ClientException catch (e, st) {
      debugPrint('🌐 Network / CORS failure for $url → $e\n$st');
      rethrow;
    } on FileSystemException catch (e, st) {
      debugPrint('💾 File-system error caching $url → $e\n$st');
      rethrow;
    } catch (e, st) {
      debugPrint('❗ Unexpected error for $url → $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    _preloadQueue.clear();
    _preloadedFiles.clear();

    super.dispose();
  }

  Future<File> getCachedVideoFile(String url) async {
    return _getCachedFile(url);
  }
}

/// Use this in your UI.
final videoFeedProvider =
    StateNotifierProvider<VideoFeedNotifier, VideoFeedState>((ref) {
      final repo = ref.watch(videoFeedRepositoryProvider);
      return VideoFeedNotifier(repo);
    });
