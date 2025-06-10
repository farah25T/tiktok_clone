import 'package:tiktok/app/domain/models/user.dart';

abstract class IAuthRepository {
  Future<User> signInAnonymously();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
}
