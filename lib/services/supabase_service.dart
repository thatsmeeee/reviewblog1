import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  /// Singleton Supabase client
  static SupabaseClient? _client;

  /// Access client safely
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase is not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  /// Initialize Supabase (call this in main before runApp)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'http://study-supabase-20c378-167-88-45-173.traefik.me',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NzA5NTA3ODgsImV4cCI6MTg5MzQ1NjAwMCwicm9sZSI6ImFub24iLCJpc3MiOiJzdXBhYmFzZSJ9.xbUmbbWt1CBMd2JpnkL24A54Sa25OgRCjkcsB-odlh4',
      debug: true,
    );
    // Store the initialized client
    _client = Supabase.instance.client;
  }
}
