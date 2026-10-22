import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/presentation/auth_gate.dart';

class SmartStudyPlannerApp extends ConsumerWidget {
  const SmartStudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Smart Study Planner',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
