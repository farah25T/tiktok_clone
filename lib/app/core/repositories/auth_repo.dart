import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:tiktok/app/domain/data_sources/i_auth_data_source.dart';
import 'package:tiktok/app/domain/models/user.dart' as userModel;
import 'package:tiktok/app/domain/repositories/i_auth_repo.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthRepository implements IAuthRepository {
  AuthRepository(this._ds);
  final IAuthDataSource _ds;

  @override
  Future<userModel.User> signInAnonymously() =>
      _wrap(() => _ds.signInAnonymously());

  @override
  Future<userModel.User> signInWithEmail(String e, String p) =>
      _wrap(() => _ds.signInWithEmail(e, p));

  @override
  Future<userModel.User> signUpWithEmail(String e, String p) =>
      _wrap(() => _ds.signUpWithEmail(e, p));

  Future<userModel.User> _wrap(Future<userModel.User> Function() fn) async {
    try {
      return await fn();
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapCode(e));
    } catch (e) {
      throw AuthException('Unexpected error: $e');
    }
  }

  String _mapCode(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun compte trouvé pour cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Format d’email invalide.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      default:
        return e.message ?? 'Erreur d’authentification.';
    }
  }
}
