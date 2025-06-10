import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok/app/domain/repositories/i_auth_repo.dart';
import 'auth_form_state.dart';

class AuthFormNotifier extends StateNotifier<AuthFormState> {
  AuthFormNotifier({required this.isRegistration})
    : _repo = GetIt.I<IAuthRepository>(),
      super(const AuthFormState());

  final IAuthRepository _repo;
  final bool isRegistration;

  void emailChanged(String v) =>
      state = state.copyWith(email: v, status: AuthFormStatus.initial);

  void passwordChanged(String v) =>
      state = state.copyWith(password: v, status: AuthFormStatus.initial);

  // ── submit (sign-in OR sign-up) ────────────────────────────────────────
  Future<void> submit() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(
        status: AuthFormStatus.error,
        message: 'Email et mot de passe requis.',
      );
      return;
    }

    state = state.copyWith(status: AuthFormStatus.loading, message: null);

    try {
      if (isRegistration) {
        await _repo.signUpWithEmail(state.email.trim(), state.password.trim());
      } else {
        await _repo.signInWithEmail(state.email.trim(), state.password.trim());
      }
      state = state.copyWith(status: AuthFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: AuthFormStatus.error,
        message: e.toString(),
      );
    }
  }
}

final registerFormProvider =
    StateNotifierProvider<AuthFormNotifier, AuthFormState>(
      (ref) => AuthFormNotifier(isRegistration: true),
    );

final loginFormProvider =
    StateNotifierProvider<AuthFormNotifier, AuthFormState>(
      (ref) => AuthFormNotifier(isRegistration: false),
    );
