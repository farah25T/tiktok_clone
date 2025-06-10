enum AuthFormStatus { initial, loading, success, error }

class AuthFormState {
  final String email;
  final String password;
  final AuthFormStatus status;
  final String? message;

  const AuthFormState({
    this.email = '',
    this.password = '',
    this.status = AuthFormStatus.initial,
    this.message,
  });

  AuthFormState copyWith({
    String? email,
    String? password,
    AuthFormStatus? status,
    String? message,
  }) => AuthFormState(
    email: email ?? this.email,
    password: password ?? this.password,
    status: status ?? this.status,
    message: message,
  );
}
