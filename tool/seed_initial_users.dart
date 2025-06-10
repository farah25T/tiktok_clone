#!/usr/bin/env dart
// Seeds Firestore with 5 dummy users.
// Run with:  flutter pub run tool/seed_users.dart

import 'package:flutter/widgets.dart'; // WidgetsFlutterBinding
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tiktok/firebase_options.dart';
import 'package:tiktok/app/core/di/dependency_injector.dart';
import 'package:tiktok/app/domain/models/user.dart'
    as model; // adjust path if needed

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupDependencies(); // same DI you already use
  await getIt<FirebaseAuth>()
      .signInAnonymously(); // any authenticated context works

  await _seedUsers();
}

Future<void> _seedUsers() async {
  final firestore = getIt<FirebaseFirestore>();

  final users = <model.User>[
    model.User(
      id: 'u_001',
      email: 'alice@example.com',
      displayName: 'Alice Doe',
    ),
    model.User(id: 'u_002', email: 'bob@example.com', displayName: 'Bob Lee'),
    model.User(
      id: 'u_003',
      email: 'charlie@example.com',
      displayName: 'Charlie P.',
    ),
    model.User(
      id: 'u_004',
      email: 'diana@example.com',
      displayName: 'Diana Q.',
    ),
    model.User(id: 'u_005', email: 'eric@example.com', displayName: 'Eric R.'),
  ];

  for (final u in users) {
    await firestore.collection('users').doc(u.id).set(u.toFirestore());
    print('✅  Added user ${u.displayName} (${u.id})');
  }

  print('🎉  All users inserted.');
}
