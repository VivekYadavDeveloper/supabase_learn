import 'package:flutter/material.dart';
import 'package:supabase_learn/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void signUp() async {
    final email = _emailController.text;
    final password = _passController.text;
    final confirmPassword = _confirmPassController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password Didn't Match")));
      return;
    }
    /*Attempt Signup*/
    try {
      await authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(" ERROR $e")));
      }
      print("Signup Error --> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SIGN UP"),
      ),
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
              TextField(
                controller: _confirmPassController,
                decoration:
                    const InputDecoration(labelText: "Confirm Password"),
              ),
              const SizedBox(height: 30),
              TextButton(
                  onPressed: () {
                    signUp();
                    // Navigator.pop(context);
                  },
                  child: const Text("REGISTER")),
            ],
          ),
        );
      }),
    );
  }
}
