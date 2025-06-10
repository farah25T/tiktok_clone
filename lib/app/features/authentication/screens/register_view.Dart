import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tiktok/app/core/constants/enums/router_enum.dart'; // <-- for route names
import 'package:tiktok/app/features/authentication/state/auth_provider.dart';
import '../state/auth_form_state.dart';
import 'package:tiktok/app/presentation/theme/device_dimensions.dart';
class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DeviceDimensions.initialize(context);

    final form = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);

    ref.listen<AuthFormState>(registerFormProvider, (prev, next) {
      if (next.status == AuthFormStatus.success) {
        context.goNamed(RouterEnum.videoFeedView.name);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceDimensions.width * 0.08,
            vertical: DeviceDimensions.height * 0.04,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Créer un compte',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: DeviceDimensions.height * 0.04),
              TextField(
                onChanged: notifier.emailChanged,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: DeviceDimensions.height * 0.02),
              TextField(
                onChanged: notifier.passwordChanged,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              SizedBox(height: DeviceDimensions.height * 0.03),
              if (form.status == AuthFormStatus.error)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    form.message ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: form.status == AuthFormStatus.loading
                      ? null
                      : notifier.submit,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: DeviceDimensions.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: form.status == AuthFormStatus.loading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Créer mon compte'),
                ),
              ),
              SizedBox(height: DeviceDimensions.height * 0.015),
              TextButton(
                onPressed: () => context.goNamed(RouterEnum.loginView.name),
                child: const Text("Déjà un compte ? Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}