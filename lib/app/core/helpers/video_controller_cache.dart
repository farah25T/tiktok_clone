import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoControllerCache {
  VideoControllerCache({this.maxSize = 3});
  final int maxSize;

  final _cache = <String, VideoPlayerController>{};
  final _order = Queue<String>();

  VideoPlayerController? operator [](String id) => _cache[id];

  Future<VideoPlayerController> put(
    String id,
    Future<VideoPlayerController> Function() init,
  ) async {
    if (_cache.containsKey(id)) {
      _touch(id);
      return _cache[id]!;
    }

    final controller = await init();
    _cache[id] = controller;
    _touch(id);
    _evictIfNeeded();
    return controller;
  }

  Future<void> dispose(String id) async {
    final c = _cache.remove(id);
    _order.remove(id);
    if (c != null) await c.dispose();
  }

  Future<void> disposeAll() async {
    for (final c in _cache.values) {
      await c.dispose();
    }
    ;
    _cache.clear();
    _order.clear();
  }

  void _touch(String id) {
    _order.remove(id);
    _order.addLast(id);
  }

  void _evictIfNeeded() {
    while (_cache.length > maxSize) {
      final oldest = _order.removeFirst();
      _cache.remove(oldest)?.dispose();
    }
  }

  Iterable<String> get ids => _cache.keys;
  Iterable<VideoPlayerController> get controllers => _cache.values;
}

final videoControllerCacheProvider = Provider<VideoControllerCache>((ref) {
  final cache = VideoControllerCache();
  ref.onDispose(cache.disposeAll);
  return cache;
});
