import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_controller.dart';

class ProfileMenuButton extends ConsumerWidget {
  const ProfileMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<void>(
      icon: const Icon(Icons.account_circle_outlined),
      itemBuilder: (_) => [
        PopupMenuItem<void>(
          onTap: () => ref.read(authControllerProvider).signOut(),
          child: const Text('Sign out'),
        ),
      ],
    );
  }
}
