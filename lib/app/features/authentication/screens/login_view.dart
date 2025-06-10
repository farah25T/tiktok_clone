import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/app/core/constants/enums/router_enum.dart';
import 'package:tiktok/app/features/authentication/state/auth_provider.dart';
import '../state/auth_form_state.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final notifier = ref.read(loginFormProvider.notifier);

    ref.listen<AuthFormState>(loginFormProvider, (prev, next) {
      if (next.status == AuthFormStatus.success) {
        context.goNamed(RouterEnum.videoFeedView.name);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: notifier.emailChanged,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: notifier.passwordChanged,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 24),
            if (form.status == AuthFormStatus.error)
              Text(
                form.message ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: form.status == AuthFormStatus.loading
                  ? null
                  : notifier.submit,
              child: form.status == AuthFormStatus.loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Se connecter'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.goNamed(RouterEnum.registerView.name),
              child: const Text("Pas de compte ? S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
