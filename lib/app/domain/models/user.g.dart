// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String?,
  displayName: json['displayName'] as String?,
  createdAt: User._fromTimestamp(json['createdAt']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'createdAt': User._toTimestamp(instance.createdAt),
};
