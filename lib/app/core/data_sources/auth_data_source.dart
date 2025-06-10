import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiktok/app/domain/models/user.dart' as userModel;
import 'package:tiktok/app/domain/data_sources/i_auth_data_source.dart';

class AuthDataSource implements IAuthDataSource {
  AuthDataSource(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  @override
  Future<userModel.User> signInAnonymously() async {
    final credential = await _firebaseAuth.signInAnonymously();
    return userModel.User.fromFirebase(credential.user!);
  }

  @override
  Future<userModel.User> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel.User.fromFirebase(credential.user!);
  }

  @override
  Future<userModel.User> signUpWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel.User.fromFirebase(credential.user!);
  }
}
