import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

import 'package:tiktok/app/domain/models/video_item.dart';
import 'package:tiktok/app/features/video_feed/state/video_feed_provider.dart';
import 'package:tiktok/app/core/helpers/video_controller_cache.dart';
import 'package:tiktok/app/features/video_feed/widgets/video_feed_item.dart';

class VideoFeedView extends ConsumerStatefulWidget {
  const VideoFeedView({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoFeedView> createState() => _VideoFeedViewState();
}

class _VideoFeedViewState extends ConsumerState<VideoFeedView>
    with WidgetsBindingObserver {
  final _pageController = PreloadPageController();
  bool _hasStarted = false;
  int _current = 0;

  VideoControllerCache get _cache => ref.read(videoControllerCacheProvider);
  VideoFeedNotifier get _notifier => ref.read(videoFeedProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /* ---------- controller helpers ---------- */

  Future<VideoPlayerController> _initController(VideoItem v) {
    print("item in _initController: ${v.title}");
    return _cache.put(v.id, () async {
      final file = await _notifier.getCachedVideoFile(v.url);
      print("Initializing controller for video at: ${file.path}");
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      controller.setLooping(true);
      await controller.play();
      return controller;
    });
  }

  Future<void> _playCurrent() async {
    final videos = ref.read(videoFeedProvider).videos;
    if (_current >= videos.length) return;

    final controller = await _initController(videos[_current]);
    if (mounted) setState(() {}); // trigger rebuild when ready
  }

  Future<void> _pauseAll() async {
    for (final c in _cache.controllers) {
      if (c.value.isPlaying) await c.pause();
    }
  }

  Future<void> _onPageChanged(int index) async {
    final videos = ref.read(videoFeedProvider).videos;
    if (index >= videos.length) return;

    _current = index;
    await _pauseAll();
    await _initController(videos[index]);
    setState(() {}); // trigger update for new controller

    // Keep only current ±1 controllers in memory
    for (final v in videos) {
      final keep = (videos.indexOf(v) - index).abs() <= 1;
      if (!keep) await _cache.dispose(v.id);
    }

    _notifier.onPageChanged(index);
  }

  /* ---------- build ---------- */

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videoFeedProvider).videos;

    if (videos.isNotEmpty && !_hasStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _hasStarted) return;
        _hasStarted = true;
        await _playCurrent(); // wait until controller is ready
      });
    }

    return PreloadPageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (ctx, i) {
        final v = videos[i];
        final controller = _cache[v.id]; // might still be null
        return VideoFeedItem(
          key: ValueKey(v.id),
          controller: controller,
          videoItem: v,
        );
      },
    );
  }
}
