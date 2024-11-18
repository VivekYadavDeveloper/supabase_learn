import 'package:flutter/material.dart';
import 'package:supabase_learn/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();

  /* Logout Session*/
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userData = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraint) {
        return ListView(
          children: <Widget>[Text(userData.toString())],
        );
      }),
    );
  }
}
