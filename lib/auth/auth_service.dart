import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  /*Create a instance of Supabase Here*/

  final SupabaseClient _supabase = Supabase.instance.client;

/*Sign In With Email And Password*/

  Future<AuthResponse> signInWithEmailPassword(
      String email, String pass) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: pass,
    );
  }

/* Sign Up With Email And Password*/

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String pass) async {
    return await _supabase.auth.signUp(
      email: email,
      password: pass,
    );
  }

/*Sign Out*/

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

/*Get User Email To Show On Profile*/

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
