import 'package:flutter/material.dart';
import 'package:tiktok/app/core/di/dependency_injector.dart';
import 'package:tiktok/app/core/init/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupDependencies(includeRouter: true);

  runApp(const AppWidget());
}
