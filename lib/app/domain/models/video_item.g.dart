// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoItem _$VideoItemFromJson(Map<String, dynamic> json) => VideoItem(
  id: json['id'] as String,
  url: json['url'] as String,
  title: json['title'] as String,
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  dislikes: (json['dislikes'] as num?)?.toInt() ?? 0,
  createdAt: VideoItem._fromTimestamp(json['createdAt']),
);

Map<String, dynamic> _$VideoItemToJson(VideoItem instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'title': instance.title,
  'likes': instance.likes,
  'dislikes': instance.dislikes,
  'createdAt': VideoItem._toTimestamp(instance.createdAt),
};
