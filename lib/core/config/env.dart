class Env {
  const Env._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');

  static void validate() {
    const missing = <String>[
      if (supabaseUrl.isEmpty) 'SUPABASE_URL',
      if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
      if (openAiApiKey.isEmpty) 'OPENAI_API_KEY',
    ];

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required --dart-define values: ${missing.join(', ')}',
      );
    }
  }
}
