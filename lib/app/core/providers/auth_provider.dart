import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

final firebaseAuthProvider = Provider<fb.FirebaseAuth>(
  (ref) => fb.FirebaseAuth.instance,
);

final firebaseUserStreamProvider = StreamProvider<fb.User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

final isConnectedProvider = Provider<bool>((ref) {
  final authState = ref.watch(firebaseUserStreamProvider);
  return authState.maybeWhen(
    data: (user) => user != null && !user.isAnonymous,
    orElse: () => false,
  );
});
