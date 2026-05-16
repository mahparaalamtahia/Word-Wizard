import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../errors/exceptions.dart';

class SupabaseService {
  SupabaseService._internal();
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  static SupabaseService get instance => _instance;

  static SupabaseClient get client => instance._client;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Could not load .env file: $e');
      }
    }

    final url = dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key-here';

    // Check if using placeholder values
    if (url.contains('your-project') || anonKey.contains('your-anon-key')) {
      throw ServerException(
        message: 'Supabase configuration incomplete.\n\n'
            'Please add your Supabase credentials to .env:\n'
            'SUPABASE_URL=https://your-project.supabase.co\n'
            'SUPABASE_ANON_KEY=your-actual-key'
      );
    }

    try {
      // Add timeout to prevent hanging on web (30 seconds max)
      await Supabase.initialize(url: url, anonKey: anonKey, debug: false)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw ServerException(
              message: 'Supabase initialization timeout. Check your internet connection.',
            ),
          );
      _initialized = true;
    } catch (e) {
      throw ServerException(message: 'Failed to initialize Supabase: $e');
    }
  }

  SupabaseClient get _client {
    if (!_initialized) {
      throw StateError('SupabaseService is not initialized. Call initialize() first.');
    }
    return Supabase.instance.client;
  }

  User? get currentUser => _client.auth.currentUser;

  bool get isAuthenticated => _client.auth.currentUser != null;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
