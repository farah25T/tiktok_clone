import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tiktok/firebase_options.dart';
import 'package:tiktok/app/core/di/dependency_injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDependencies();
  await getIt<FirebaseAuth>().signInAnonymously();

  await _uploadInitialVideos();
}

Future<void> _uploadInitialVideos() async {
  final firestore = getIt<FirebaseFirestore>();
  final storage = getIt<FirebaseStorage>();

  const assetPaths = [
    'assets/videos/video1.mp4',
    'assets/videos/video2.mp4',
    'assets/videos/video3.mp4',
    'assets/videos/video4.mp4',
    'assets/videos/video5.mp4',
  ];

  for (var i = 0; i < assetPaths.length; i++) {
    final assetPath = assetPaths[i];
    final fileName = 'video${i + 1}.mp4';
    final storagePath = 'videos/$fileName';

    // 1️⃣ Load bytes from bundled asset
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // 2️⃣ Upload to Cloud Storage
    final ref = storage.ref(storagePath);
    await ref.putData(bytes, SettableMetadata(contentType: 'video/mp4'));

    final downloadUrl = await ref.getDownloadURL();

    await firestore.collection('videos').add({
      'url': downloadUrl,
      'title': 'Video ${i + 1}',
      'likes': 0,
      'dislikes': 0,
      'createdAt': DateTime.now(),
    });

    print('✅ Uploaded $fileName and created Firestore entry.');
  }

  print('🎉 All 5 videos uploaded to Storage and seeded in Firestore.');
}
