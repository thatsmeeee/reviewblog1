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
    // 1. Get Supabase client from SupabaseService singleton
    final client = SupabaseService.client;

    try {
      // 2. Authenticate user with Supabase Auth API
      // This sends HTTP request to your Supabase instance
      final res = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // 3. Check if authentication was successful
      if (res.user == null) {
        log('Login failed: invalid credentials');
        return null;
      }

      log('Login successful: ${res.user!.email}');

      // 4. Fetch user profile from joel-profile table
      // This queries your database for the user's profile data
      final profile = await client
          .from('joel_profile')
          .select()
          .eq(
            'id',
            res.user!.id,
          ) // assuming your profile ID matches auth user ID
          .maybeSingle(); // returns Map<String, dynamic> or null

      // 5. Check if profile exists in database
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

  /// Signs up a new user and creates their profile
  static Future<bool> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    final client = SupabaseService.client;

    try {
      // Step 1: Create user in Supabase Auth
      final authResponse = await client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      // Check if user was created (even if confirmation is pending)
      if (authResponse.user == null) {
        log('Signup failed: could not create auth user');
        return false;
      }

      log('Auth user created: ${authResponse.user!.email}');
      log('Email confirmation: ${authResponse.user!.emailConfirmedAt}');

      // Step 2: Try to auto-login to bypass email confirmation
      try {
        final loginResponse = await client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (loginResponse.user != null) {
          log('Auto-login successful after signup');
        }
      } catch (e) {
        log('Auto-login failed (expected if email confirmation required): $e');
      }

      // Step 3: Create user profile in joel_profile table
      final profileData = {
        'id': authResponse.user!.id,
        'email': email,
        'username': username,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final profileResponse = await client
          .from('joel_profile')
          .insert(profileData);

      if (profileResponse.error != null) {
        log('Profile creation failed: ${profileResponse.error!.message}');
        return false;
      }

      log('Profile created successfully for user: $username');
      return true;
    } on AuthException catch (e) {
      log('Supabase auth signup error: ${e.message}');
      log('Auth error details: ${e.toString()}');

      // Check if user was created but needs email confirmation
      if (e.message.contains('confirmation') || e.message.contains('email')) {
        log('User created but email confirmation required');
        return true; // User was created, just needs confirmation
      }
      return false;
    } catch (e) {
      log('Unexpected signup error: $e');
      log('Error type: ${e.runtimeType}');
      return false;
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
