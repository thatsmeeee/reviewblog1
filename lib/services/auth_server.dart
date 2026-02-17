import 'dart:async';
import 'dart:developer'; // for logging
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart'; // your singleton

/// AuthService handles authentication and profile fetching
class AuthService {
  /// Logs in the user using Supabase Auth and returns profile data if successful
  /// Returns null if login fails
  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    final client = SupabaseService.client;

    try {
      // Step 1: Sign in with Supabase Auth
      final res = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        log('Login failed: invalid credentials');
        return null;
      }

      log('Login successful: ${res.user!.email}');

      // Step 2: Fetch user profile from joel-profile table
      final profile = await client
          .from('joel-profile')
          .select()
          .eq(
            'id',
            res.user!.id,
          ) // assuming your profile ID matches auth user ID
          .maybeSingle(); // returns Map<String, dynamic> or null

      if (profile == null) {
        log('Profile not found for user: ${res.user!.email}');
        return null;
      }

      log('Profile fetched successfully');
      return profile;
    } on AuthException catch (e) {
      log('Supabase auth error: ${e.message}');
      return null;
    } catch (e) {
      log('Unexpected login error: $e');
      return null;
    }
  }

  /// Logs out the current user
  static Future<void> logout() async {
    final client = SupabaseService.client;

    try {
      await client.auth.signOut();
      log('Logout successful');
    } catch (e) {
      log('Logout failed: $e');
    }
  }

  /// Fetch current user profile from joel-profile
  static Future<Map<String, dynamic>?> getProfile(String id) async {
    final client = SupabaseService.client;

    try {
      final profile = await client
          .from('joel-profile')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (profile == null) {
        log('Profile not found for id: $id');
      }

      return profile;
    } catch (e) {
      log('Error fetching profile: $e');
      return null;
    }
  }
}
