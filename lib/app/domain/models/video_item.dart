import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_item.g.dart';

@JsonSerializable()
class VideoItem {
  VideoItem({
    required this.id,
    required this.url,
    required this.title,
    this.likes = 0,
    this.dislikes = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String url;
  final String title;
  final int likes;
  final int dislikes;

  @JsonKey(fromJson: _fromTimestamp, toJson: _toTimestamp)
  final DateTime createdAt;

  factory VideoItem.fromJson(Map<String, dynamic> json) =>
      _$VideoItemFromJson(json);

  Map<String, dynamic> toJson() => _$VideoItemToJson(this);

  factory VideoItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return VideoItem.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() => toJson();

  VideoItem copyWith({
    String? id,
    String? url,
    String? title,
    int? likes,
    int? dislikes,
    DateTime? createdAt,
  }) => VideoItem(
    id: id ?? this.id,
    url: url ?? this.url,
    title: title ?? this.title,
    likes: likes ?? this.likes,
    dislikes: dislikes ?? this.dislikes,
    createdAt: createdAt ?? this.createdAt,
  );

  static DateTime _fromTimestamp(dynamic ts) {
    if (ts == null) return DateTime.now();

    if (ts is Timestamp) return ts.toDate();

    if (ts is int) {
      return DateTime.fromMillisecondsSinceEpoch(ts);
    }

    if (ts is String) {
      return DateTime.tryParse(ts) ?? DateTime.now();
    }

    return DateTime.now();
  }

  static Timestamp _toTimestamp(DateTime dt) => Timestamp.fromDate(dt);
}
