import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({required this.id, this.email, this.displayName, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String? email;
  final String? displayName;

  @JsonKey(fromJson: _fromTimestamp, toJson: _toTimestamp)
  final DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return User.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() => toJson();
  factory User.fromFirebase(fb.User u) => User(
    id: u.uid,
    email: u.email,
    displayName: u.displayName,
    createdAt: DateTime.now(),
  );

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
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
