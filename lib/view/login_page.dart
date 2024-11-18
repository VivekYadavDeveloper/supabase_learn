import 'package:flutter/material.dart';
import 'package:supabase_learn/auth/auth_service.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passController.text;

    /*Attempt Login*/
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(" ERROR $e")));
      }
      print("Login Error --> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _passController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 30),
              TextButton(
                  onPressed: () {
                    login();
                  },
                  child: const Text("LOGIN")),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: const Text("Don,t Have An Account? SignUp"))
            ],
          ),
        );
      }),
    );
  }
}
