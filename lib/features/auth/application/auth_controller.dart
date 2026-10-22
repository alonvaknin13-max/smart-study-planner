import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authStateChangesProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
);

class AuthController {
  AuthController(this._client);

  final SupabaseClient _client;

  Future<void> signInWithGoogle() {
    return _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  Future<void> signOut() => _client.auth.signOut();
}

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(ref.watch(supabaseClientProvider)),
);
