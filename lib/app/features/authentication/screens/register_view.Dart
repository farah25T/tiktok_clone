import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tiktok/app/core/constants/enums/router_enum.dart'; // <-- for route names
import 'package:tiktok/app/features/authentication/state/auth_provider.dart';
import '../state/auth_form_state.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);

    // When registration succeeds, jump to the feed tab (inside the shell).
    ref.listen<AuthFormState>(registerFormProvider, (prev, next) {
      if (next.status == AuthFormStatus.success) {
        context.goNamed(RouterEnum.videoFeedView.name); // '/video-feed'
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
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

            // ── error banner ──────────────────────────────────────────────────
            if (form.status == AuthFormStatus.error)
              Text(
                form.message ?? '',
                style: const TextStyle(color: Colors.red),
              ),

            // ── submit button ────────────────────────────────────────────────
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
                  : const Text('Créer mon compte'),
            ),

            const SizedBox(height: 12),

            // ── link to Login screen ─────────────────────────────────────────
            TextButton(
              onPressed: () =>
                  context.goNamed(RouterEnum.loginView.name), // '/login'
              child: const Text("Déjà un compte ? Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
